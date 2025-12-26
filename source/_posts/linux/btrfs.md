---
title: Arch Linux 下 Btrfs 使用小记
date: 2025-05-13 14:26:00
excerpt: 介绍了 Btrfs，安装方法，快照与交换文件配置
category: [Linux]
tags: [linux, btrfs, snapper, grub-btrfs, swap, hibernation]
mathjax: on
---

## [BTRFS](https://btrfs.readthedocs.io) 介绍

B-TRee File System 是一个支持子卷快照、数据校验、透明压缩等多种高级功能的现代写时复制(Copy on Write)文件系统。

- 写时复制
  - 修改不是原地覆盖，而是先写入到空白区域，再修改指针，可保证数据一致性。[^cowlog]
  - 支持快速复制(reflink)，简单来说就是副本之间尽量共用数据块，通过 CoW 机制只需额外存储改动部分。
  - 可以通过 `chattr +C` 命令对特定文件禁用。
- 快照和子卷地位相当，也可以修改和创建快照。有人认为将其称作“分支(fork)”更加贴切。
- CRC 数据校验可以发现数据损坏，但修复依靠外部备份或 RAID。
- 透明压缩：
  - 通过牺牲一定的 CPU 时间，减少实际写入硬盘的数据，提高存储容量与 IO 速度。
  - 文件系统内部行为，用户无感。
  - 其实当写入稀疏时是负优化，可以通过 `chattr +m` 命令对特定文件禁用。
- 顾名思义，该文件系统使用数据结构 B 树维护元数据。
  - 为了支持其先进的快照功能，实际使用的是一种能够高效复制的改进版。[^btree]
  - 原理可以理解为一种懒惰思想，即尽可能共用各副本的相同部分。
  - <span title="某退役 OIer 的评论" class="heimu">这就是有垃圾回收的可持久化多叉平衡树，太裤辣！</span>


[^btree]: [幻灯片](https://github.com/liujinmarshall/btrfs-doc/blob/master/LinuxFS_Workshop%20on%20wiki%20----.pdf) 和 [论文](https://github.com/liujinmarshall/btrfs-doc/blob/master/btree_TOS%20on%20wiki%20-----.pdf)
[^cowlog]: [copy on write logging](https://btrfs.readthedocs.io/en/latest/dev/dev-btrfs-design.html#copy-on-write-logging)

### BTRFS 数据损坏测试^[[Btrfs使用简谈与硬盘错误模拟测试——知乎](https://zhuanlan.zhihu.com/p/272482813)]

安装软件包 `btrfs-progs`。

用文件虚拟出一块硬盘。之后你可以手动编辑该文件模拟数据损坏，看看会发生什么。

```sh
# 创建一个镜像
sudo dd if=/dev/zero of=test.img bs=1M count=128
# 格式化为btrfs格式
sudo mkfs.btrfs test.img
# 挂载
sudo mount -o loop test.img /mnt
```

## 安装 BTRFS

参考资料：

- [Arch Linux+btrfs 配置简明指南](https://blog.azurezeng.com/archlinux-with-btrfs-simple-guide/)
- [Snapper - ArchWiki](https://wiki.archlinux.org/title/Snapper)
- [ArchLinux 安装及 Snapper 和 btrfs-grub 的使用](https://blog.zrlab.org/posts/sabgia/#snapper)

笔者的分区方案（终端推荐 `cfdisk` 工具）：

- `/dev/nvme0n1p1` 分配 260MB，挂载于 `/efi`。（引导模式为 `x64 UEFI`）
- `/dev/nvme0n1p2` 分配剩余空间，格式化为 btrfs 文件系统。
- 无交换分区。
- 此方案也适用于双系统，注意设备标签可能不同。

### 设计子卷布局

- 前置知识：btrfs 的子卷是按照目录结构组织的，可以用 `mv` 命令移动。
- 个人认为，尽量不要在需要拍摄快照的子卷里面放子卷，用挂载或软链接代替。
  - 快照是不会递归拍摄的，嵌套子卷拍摄后显示为空目录，恢复时需要进一步处理。
- 文件系统的根子卷比较特殊，无法从快照恢复（和不能把目录移动/复制到祖先同理），因此选择创建 `@` 子卷表示根目录。

| 子卷       | 挂载点            |
| :----      | :----             |
| @          | `/`               |
| @snapshots | `/.snapshots`     |
| @swap      | `/swap`           |
| @home      | `/home`           |
| @root      | `/root`           |
| @var_log   | `/var/log`        |
| @var_cache | `/var/cache`      |
| @var_tmp   | `/var/tmp`        |
| @docker    | `/var/lib/docker` |
| @opt       | `/opt`            |

- `@` 子卷存放操作系统与安装的软件，`@snapshots` 存放系统快照（snapper 会自己生成一个子卷）。
- `@swap` 存放交换文件。包含交换文件的子卷无法快照，故单独分卷。
- `/home/用户名` 和 `/root` 是普通用户和 root 用户的主目录，分卷可在快照回滚时保留其中的用户数据。
- `/var/log` 存放日志，不应该快照。
- `/var/cache` 和 `/var/tmp` 存储缓存和临时文件，不需要快照。
- `@docker` 存放容器，`@opt` 存放自包含软件，我理解这些东西独立于系统存在，不需要一起快照。

### 分卷并挂载

格式化并分卷：

```sh
# mkfs.fat -F 32 /dev/nvme0n1p1 # 如果你要重建 EFI 分区的话
mkfs.btrfs /dev/nvme0n1p2
mount -t btrfs /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@{,snapshots,swap,home,root,var_{cache,log,tmp},docker,opt}
umount /mnt
```

挂载：

```sh
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@          /mnt
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@opt       /mnt/opt
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@home      /mnt/home
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@root      /mnt/root
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@swap      /mnt/swap
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@var_log   /mnt/var/log
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@var_tmp   /mnt/var/tmp
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@var_cache /mnt/var/cache
mount --mkdir /dev/nvme0n1p2 -o noatime,compress=zstd,subvol=@docker    /mnt/var/lib/docker
mount  --mkdir /dev/nvme0n1p1 /mnt/efi
```

关于挂载选项的说明：

- `-o` 选项表示指定挂载选项，后面紧跟的参数是个字符串，所以注意不要输入空格（或者用双引号括起来）
- `subvol` 指定挂载的子卷。（或 `subvolid` 通过 ID 指定，但是 ID 快照后会改变，不推荐）
- `noatime` 禁用文件访问时间更新，可以减少写入量，对 SSD 友好。
  - 在一个有快照的子卷内访问文件会更糟，会导致相应的 B 树复制（这原本是懒惰的）。
  - `chattr +A` 可以对特定的文件和目录单独禁用访问时间更新。没试过。
- `nodiratime` 被 `noatime` 蕴含，没必要。
- `compress=zstd:3` 指定压缩算法为 `zstd`，并指定压缩级别为 3。
  - zstd 压缩又快又好。
  - 默认级别是 3，没测试过哪个级别最快。
- `ssd` 会自动检测并优化，不需要加该选项。
- `discard=async` 自 kernel 6.2 起已经是默认选项。

### 安装必要软件包

需要安装 `btrfs-progs` 包，不然装 `linux` 内核时会报错。

```sh
pacstrap -K /mnt btrfs-progs
```

## Snapper 快照管理

```sh
sudo pacman -S snapper snap-pac
```

`snap-pac` 是一个 pacman hook，用来在每次更改软件包前后自动创建快照。

然后创建快照配置。

```sh
sudo snapper -c root create-config /
# snapper 会自动创建被快照子卷对应目录下的 .snapshots 子卷。
# 因为破坏了扁平布局，改成将之前创建的 @snapshots 子卷挂载在这里。（其实算精神洁癖）
sudo btrfs subvolume delete /.snapshots
sudo mount -o noatime,compress=zstd:3,subvol=@snapshots /dev/nvme0n1p2 /.snapshots --mkdir
```

修改 `/lib/systemd/system/snapper-timeline.timer`，设置创建快照频率

修改配置文件 `/etc/snapper/configs/root`，设置保留的快照数量

开启 Snapper 自动快照和自动清理的后台服务：

```sh
sudo systemctl enable --now snapper-{timeline,cleanup}.timer
```

## 从快照恢复

推荐安装 `grub-btrfs` 包，这个包可以在 grub 界面里列出快照并启动。

如果系统崩了启动不了，就用启动盘；如果没崩，重启后生效。

```sh
# 挂载 btrfs 分区
mount /dev/nvme0n1p2 /mnt
cd /mnt
# 把损坏的 @ 子卷挪到别处
mv @ @broken
# 列出所有快照及其创建时间
grep -r '<date>' /mnt/@snapshots/*/info.xml
# 给快照创建一个可读写副本作为新的 @ 子卷
btrfs subvolume snapshot /mnt/@snapshots/编号/snapshot /mnt/@
# 事后检查无误可删除损坏的子卷
btrfs subvolume delete /mnt/@broken
```

## 交换文件与休眠^[[Suspend and hibernate - ArchWiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation)]

创建并启用交换文件：
```sh
btrfs filesystem mkswapfile --size 8G /swap/swapfile
swapon /swap/swapfile
```

据说推荐的交换空间大小大概是 $\max(M/2,\sqrt{M})+M\cdot H$ 其中 $M$ 为物理内存大小（GB），$H$ 表示是否使用休眠功能。

编辑 `fstab`，追加：


{% code /etc/fstab lang:plaintext %}
/swap/swapfile        none        swap        defaults      0 0
{% endcode %}

以在开机时自动启用交换文件。

### 配置休眠

运行
```sh
btrfs inspect-internal map-swapfile -r /swap/swapfile
```


然后创建 `/etc/tmpfiles.d/hibernation.conf`，写入如下内容，其中:

- `${offset}` 为上述命令的输出
- `${swap_file_partition}` 为交换文件所在分区，在我们的例子中是 `/dev/nvme0n1p2`
- `${image_size}` 指定生成的镜像大小，0 表示尽可能压缩

{% code /etc/tmpfiles.d/hibernation.conf lang:plaintext %}
#    Path                     Mode UID  GID  Age Argument
w    /sys/power/resume_offset -    -    -    -   ${offset}
w    /sys/power/image_size    -    -    -    -   ${image_size}
w    /sys/power/resume        -    -    -    -   ${swap_file_partition}
{% endcode %}

编辑 `/etc/mkinitcpio.conf`，修改 `HOOKS=()` 一行，添加 `resume`（必须在 `udev` 后面），示例：


{% code /etc/mkinitcpio.conf lang:conf first_line:55 %}
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)
{% endcode %}

然后

```sh
sudo mkinitcpio -P
```

## 其他

GUI 快照管理软件：
```sh
sudo pacman -S btrfs-assistant
```
