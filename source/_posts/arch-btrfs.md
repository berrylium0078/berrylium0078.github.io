---
title: BTRFS 入坑记
date: 2024-10-31 17:03:08
excerpt: 记录了为全新安装的 Arch Linux 配置 btrfs 文件系统的过程
category: [瞎折腾,Linux]
---

被学长传教了……

## 关于 [BTRFS](https://btrfs.readthedocs.io)

{B|<span title="你知道的太多了" class="heimu">Bug</span>}-Tree File System 是一个支持写时复制(CoW)、子卷快照、数据校验、透明压缩等多种高级功能的现代文件系统。
- 写时复制（Copy on Write, CoW）
  - 修改不是原地覆盖，而是先写入到空白区域，再修改指针，可保证数据一致性。
  - 支持快速复制（reflink），因为 CoW 机制所以后续只需要存储对副本的改动。
  - 避免对统一区域的反复写入，对 SSD 友好。
- 快照和子卷地位相当，也可以修改和创建快照。有人认为将其称作“分支”更加贴切。
- 数据校验可以发现 silent corruption 等数据损坏。
  - 发现损坏时，会尝试用通过校验的备份修复，失败则报告 IO 错误。默认配置中，数据只存一份，元数据复制两份[^duplicate]。
  - 重要数据需要在其他设备上备份[^backup]。
- 透明压缩：
  - 通过牺牲一定的 CPU 时间，减少实际写入硬盘的数据，提高存储容量与 IO 速度。
  - 文件系统内部行为，用户无感。
- 顾名思义，该文件系统使用数据结构 B 树维护元数据。
  - 为了支持其先进的快照功能，实际使用的是一种能够高效复制的改进版。[^btree]
  - 原理可以理解为一种懒惰思想，因而会共用各副本的相同部分。
  - <span title="某退役 OIer 的评论" class="heimu">这就是有垃圾回收的可持久化多叉平衡树，太裤辣！</span>

[^backup]: [文件备份的 321 原则](https://sspai.com/post/39591)，本地一份，云端一份，算上原件共三份。
[^duplicate]: 见[格式化选项](https://btrfs.readthedocs.io/en/latest/mkfs.btrfs.html#options) `-d` 和 `-m` 部分。
[^btree]: [幻灯片](https://github.com/liujinmarshall/btrfs-doc/blob/master/LinuxFS_Workshop%20on%20wiki%20----.pdf)和[论文](https://github.com/liujinmarshall/btrfs-doc/blob/master/btree_TOS%20on%20wiki%20-----.pdf)
[^cowlog]: [copy on write logging](https://btrfs.readthedocs.io/en/latest/dev/dev-btrfs-design.html#copy-on-write-logging)

### 试用 btrfs（雾）

安装软件包 `btrfs-progs`。

用文件虚拟出一块硬盘，用来测试 btrfs 在各种情况下的表现[^failure]。

[^failure]:[硬盘错误模拟测试 - 知乎](https://zhuanlan.zhihu.com/p/272482813)

```sh
# 创建一个镜像
sudo dd if=/dev/zero of=test.img bs=1M count=128
# 格式化为btrfs格式
sudo mkfs.btrfs test.img
# 挂载
sudo mount -o loop test.img /mnt
```

## 为新系统安装 BTRFS

记录了笔者为全新安装的 Arch Linux 配置 btrfs 文件系统的过程，全过程[*戳我*](/2024/11/02/arch-install)。

参考资料[^btrfs]

笔者的分区方案：
- `/dev/nvme0n1p1` 分配 260MB，挂载于 `/efi`。
- `/dev/nvme0n1p2` 分配剩余空间，格式化为 btrfs 文件系统。
- 使用交换文件而非交换分区。

```sh
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.btrfs /dev/nvme0n1p2
mount -t btrfs /dev/nvme0n1p2 /mnt
```

### 设计子卷布局
[^btrfs]: [Arch Linux+btrfs配置简明指南](https://blog.azurezeng.com/archlinux-with-btrfs-simple-guide/)

- 个人认为，尽量不要在需要拍摄快照的子卷里面放子卷，用挂载或软链接代替。
  - btrfs 中的子卷使用目录结构组织，表现像文件夹。
  - 虽然看上去子卷可以嵌套，但其实本质上并不是，快照时并不会和嵌套的子卷一起快照。
    例如可以建立 `@A/@B` 这样的子卷结构。然后给 `@A` 拍摄快照 `@a`，会发现 `@a/@B` 并不是子卷，而是无法写入的普通目录。
    回滚时需要处理这些嵌套的子卷，比较麻烦。
- 文件系统的根子卷比较特殊，无法从快照恢复，因此选择将 `@` 子卷挂载于 `/`。
- 最终决定采用所谓的“扁平布局”，如下：

| 子卷   | 挂载点 |
| ---   | --- |
| @     | / |
| @snapshots | /.snapshots |
| @swap | /swap |
| @home | /home |
| @root | /root |
| @var_log | /var/log |
| @var_cache | /var/cache |
| @var_tmp | /var/tmp |
| @docker | /var/lib/docker |
| @opt | /opt |

说明：
- `@` 子卷存放操作系统与安装的软件，`@snapshots` 存放系统快照。
- `@swap` 存放交换文件。包含交换文件的子卷无法快照，故单独分卷。
- `/home/用户名` 和 `/root` 是普通用户和 root 用户的主目录，分卷可在快照回滚时保留其中的用户数据。
- `/var/log` 存放日志，不应该快照。
- `/var/cache` 和 `/var/tmp` 存储缓存和临时文件，不需要快照。
- `@docker` 存放 docker 数据，`@opt` 存放自包含软件，我理解这些东西独立于系统存在，不需要一起快照。

### 分卷并挂载

分区：

```sh
btrfs subvolume create /mnt/@{,snapshots,swap,home,root,var_{cache,log,tmp},docker,opt}
umount /mnt
```

挂载：

```sh
mount -o noatime,compress=zstd:3,subvol=@          /dev/nvme0n1p2 /mnt
mount --mkdir -o noatime,compress=zstd:3,subvol=@opt       /dev/nvme0n1p2 /mnt/opt
mount --mkdir -o noatime,compress=zstd:3,subvol=@home      /dev/nvme0n1p2 /mnt/home
mount --mkdir -o noatime,compress=zstd:3,subvol=@root      /dev/nvme0n1p2 /mnt/root
mount --mkdir -o noatime,compress=zstd:3,subvol=@swap      /dev/nvme0n1p2 /mnt/swap
mount --mkdir -o noatime,compress=zstd:3,subvol=@var_log   /dev/nvme0n1p2 /mnt/var/log
mount --mkdir -o noatime,compress=zstd:3,subvol=@var_tmp   /dev/nvme0n1p2 /mnt/var/tmp
mount --mkdir -o noatime,compress=zstd:3,subvol=@var_cache /dev/nvme0n1p2 /mnt/var/cache
mount --mkdir -o noatime,compress=zstd:3,subvol=@docker    /dev/nvme0n1p2 /mnt/var/lib/docker
mount /dev/nvme0n1p1 /mnt/efi --mkdir
```

- `-o` 选项表示指定挂载选项，后面的部分不能有空格。
- `subvol=` 指定挂载的子卷。
- `noatime` 禁用文件访问时间更新，可以减少写入量，对 SSD 友好。
  - 在一个有快照的子卷内访问文件会更糟，会导致元数据 B 树复制（这原本是懒惰的）。
  - `chattr +A` 可以对特定的文件和目录单独禁用访问时间更新。
- `nodiratime` 被 `noatime` 蕴含，没必要。
- `compress=zstd:3` 指定压缩算法为 `zstd`，并指定压缩级别为 $3$。
  - zstd 压缩又快又好。
  - 默认级别是 $3$，没测试过哪个级别最快。
- `ssd` 会自动检测并优化，不需要加该选项。
- `discard=async` 自 kernel 6.2 起已经是默认选项。

### 安装必要软件包

需要安装 `btrfs-progs` 包，不然装 `linux` 内核时会报错。

```sh
pacstrap -K /mnt btrfs-progs
```

## 安装 Snapper[^snapper] 并配置

[^snapper]: [Snapper - ArchWiki](https://wiki.archlinux.org/title/Snapper)

```sh
sudo pacman -S snapper
```

然后创建快照配置。
```sh
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mount -o noatime,compress=zstd:3,subvol=@snapshots /dev/nvme0n1p2 /.snapshots --mkdir
```

修改 `/lib/systemd/system/snapper-timeline.timer`，设置创建快照频率
```conf
[Timer]
OnCalendar=00/6:00  # 每6小时创建一次快照
```
修改配置文件 `/etc/snapper/configs/root`，设置保留的快照数量
```conf
TIMELINE_MIN_AGE="3600"
TIMELINE_LIMIT_HOURLY="3"  # 保留3个小时快照
TIMELINE_LIMIT_DAILY="7"  # 保留7个每日快照
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

开启Snapper自动快照和自动清理

```sh
sudo systemctl enable --now snapper-{timeline,cleanup}.timer
```

## 从快照恢复

如果系统崩了启动不了，就用启动盘。

如果没崩，重启后生效。

```sh
# 挂载 btrfs 分区
mount /dev/nvme0n1p2 /mnt
cd /mnt
# 把损坏的 `@` 子卷挪到别处
mv @ @broken
# 列出所有快照及其创建时间
grep -r '<date>' /mnt/@snapshots/*/info.xml
# 给快照创建一个可读写副本作为新的 `@` 子卷
btrfs subvolume snapshot /mnt/@snapshots/编号/snapshot /mnt/@
```

## 交换文件与休眠

创建并启用交换文件：
```sh
btrfs filesystem mkswapfile --size 8G /swap/swapfile
swapon /swap/swapfile
```

推荐的交换空间大小大概是 $\max(M/2,\sqrt{M})+M\cdot H$ 其中 $M$ 为物理内存大小（单位 GB），$H$ 表示是否使用休眠功能。

编辑 `fstab`，追加：
```conf /etc/fstab
/swap/swapfile        none        swap        defaults      0 0
```
以在开机时自动启用交换文件。

### 配置休眠
参考 Arch Wiki[^suspend]。

[^suspend]: [Suspend and hibernate - ArchWiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation)

运行
```
btrfs inspect-internal map-swapfile -r /swap/swapfile
```

然后创建 `/etc/tmpfiles.d/hibernation.conf`，写入如下内容，其中*偏移量*为上述命令的输出：
```conf
#    Path                   Mode UID  GID  Age Argument
w    /sys/power/resume_offset  -    -    -    -   偏移量
w    /sys/power/image_size  -    -    -    -   0
w    /sys/power/resume  -    -    -    -   /dev/nvme0n1p2(交换文件所在分区)
```

编辑 `/etc/mkinitcpio.conf`，修改 `HOOKS=()` 一行，添加 `resume`（必须在 `udev` 后面）（以下仅为示例）：
```conf
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)
```

然后    ostname command is not located in my path, it is located at /usr/lib/gettext/hostname.

    I assume symlinking to it in /usr/bin would fix any issues.. right?

You need to update your system, no symlinking is necessary.
```sh
sudo mkinitcpio -P
```