---
title: Arch Linux 安装记录
date: 2024-10-31 17:03:08
excerpt: 记录日用系统的安装流程，以备不时之需
category: [瞎折腾,Linux]
---

## 前言

记录日用系统的安装流程，以备不时之需。

执行每一步操作前，请务必==确认你知道自己在做什么==。本文不做任何担保。
<span title="你知道的太多了" class="heimu">It works on my machine</span>
<span title="你知道的太多了" class="heimu">It worked last year</span>

{% folding blue::电脑配置 %}
型号：ThinkBook 14 G6+ IMH
CPU：Intel® Core™ Ultra 5 125H
GPU：Mesa Intel® Arc（核显）
RAM：32GB
SSD：1TB
{% endfolding %}

## Part I. 基础安装

请与 [安装指南 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)对比阅读。

按照惯例，新手要在终端手敲命令完成安装！

<span title="你知道的太多了" class="heimu">逃课方法1：[Archinstall](https://wiki.archlinuxcn.org/wiki/Archinstall)</span>

<span title="你知道的太多了" class="heimu">逃课方法2：[Arch Linux GUI](https://sourceforge.net/projects/arch-linux-gui/files/)</span>

### 1.1-1.4 准备安装介质

在[下载页面](https://archlinux.org/download/)下载 ISO 文件，并使用 [Ventoy](https://www.ventoy.net/cn/index.html) 制作启动盘。

开机按 F1 进入 live 环境，其他电脑型号请自行百度「U盘启动 + 厂商/型号」获得相关教程。

### 1.5 配置控制台键盘布局和字体

键盘布局默认为美式键盘，不用管。

字体文件位于 `/usr/share/kbd/consolefonts/` 目录，修改字体实例：

```sh
setfont ter-132b
```

### 1.6 验证引导模式为 `x64 UEFI`

如果以下文件内容不是 $64$ 或文件不存在，请查阅 Arch Wiki。

```sh
cat /sys/firmware/efi/fw_platform_size
```

### 1.7 联网

我建议连网线，或者通过数据线连接手机并在手机里开启 USB 网络共享（安卓应该都支持）。

### 1.9-1.11 分区

#### 设计分区方案

先选择一款文件系统，笔者使用过 [ext4](https://wiki.archlinux.org/title/Ext4) 和 [btrfs](https://wiki.archlinux.org/title/Btrfs)。
- ext4 更加稳定，读写速度更快。
- btrfs 支持快照和数据校验等多种高级功能，并且 CoW 机制能保证数据一致性。
- <span title="你知道的太多了" class="heimu">一部分人认为 btrfs 容易坏，但[官方](https://btrfs.readthedocs.io/en/latest/Hardware.html#hardware-as-the-main-source-of-filesystem-corruptions)认为大概率是硬件的问题</span>

{% folding blue::关于分区的一些建议 %}
1. 将 EFI 分区挂载于 `/efi`（前提是电脑为 UEFI 引导！）
    - 可以减少 EFI 分区的空间占用。
    - 本人教训：260M 的 EFI 分区，装完 nvidia 驱动占用 370MB💥
    - 注意引导程序应能够访问 `/boot` 目录，已知 GRUB 支持 ext4 和 btrfs。
2. 使用交换文件取代交换分区
    - 二者在功能和性能上没有区别，前者的优点是可以灵活调整。
3. 可将特定目录单独分区，例如 `/home`（用户的各种文件）和 `/opt`（独立软件，感觉类似 AppImage）。
    - 可防止回滚/重装系统时误删文件。
    - 清除旧系统时可以直接格式化根分区。
4. 一些不需要分区的目录：
  1. `/var`
    - 现代文件系统不会因为存储大量小文件而影响性能。
    - 主要空间占用来自软件包缓存和系统日志，定期清理即可。
  2. `/usr`
    - [见](https://systemd.io/SEPARATE_USR_IS_BROKEN/)
  3. `/tmp`
    - 默认使用 `tmpfs` 挂载，因此该分区实际位于内存或交换空间，无需担心性能问题。
    - 若默认一半物理内存的容量不足，可以临时 `sudo mount -o remount,size=64G /tmp` 或者在 `fstab` 里添加挂载选项 `size=...G` 手动设置大小。
{% endfolding %}

这次我试用了 btrfs，过程见我的[*这篇博文*](/2024/10/31/arch-btrfs/)

### 2.1 选择镜像站

<span title="你知道的太多了" class="heimu">我觉得 wiki 废话有点多</span>

下载中国镜像站列表并编辑，取消注释其中要使用的镜像站。

```sh
curl -L 'https://archlinux.org/mirrorlist/?country=CN&protocol=https' -o /etc/pacman.d/mirrorlist
nano /etc/pacman.d/mirrorlist
```

### 2.2 安装必需的软件包

```sh
pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs nano vim networkmanager wpa_supplicant iwd intel-ucode
```

- `nano`, `vim`, `emacs`：终端文本编辑器，新手推荐 `nano`。
- `networkmanager`, `wpa_supplicant`, `iwd`：联网用的。
- `btrfs-progs`：管理 `btrfs` 文件系统需要的工具。
- `base-devel`：包含构建软件包的工具，AUR 上的包默认已经安装 `base-devel`。

### 3.1-3.7 杂项

fstab 文件可用于定义磁盘分区，各种其他块设备或远程文件系统应如何装入文件系统。
```sh
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab # 检查一下
```

chroot 到新系统中，完成后续配置。
```sh
arch-chroot /mnt
```

设置时区，主机名，root 密码
```sh
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "主机名" > /etc/hostname
passwd # 设置 root 密码
```

最后是语言设置。为避免麻烦，先用英文，装完桌面再改成中文。

编辑 `/etc/locale.gen`，取消注释 `en_US.UTF-8 UTF-8` 和 `zh_CN.UTF-8 UTF-8` 两行。

之后运行
```sh
locale-gen
```
再编辑 `/etc/locale.conf`：
```conf
LANG=en_US.UTF-8
```

### 3.8 安装引导程序

[GRUB](https://wiki.archlinux.org/title/GRUB) 可自定义主题，暂时不想尝试 Systemd Boot。

```sh
pacman -S efibootmgr grub
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## Part II. 安装桌面

### 安装 plasma 并启用服务

{% note green fa-lightbulb %}

花括号是 shell 的语法糖，如 `a{b,c}d` 表示 `abd acd`。

{% endnote %}

```sh
pacman -S sddm plasma konsole dolphin firefox sof-firmware
systemctl enable {sddm,NetworkManager}.service
```
- `sddm`：显示管理器
- `konsole`：终端
- `dolphin`：文件管理器
- `firefox`：网页浏览器<span title="你知道的太多了" class="heimu">兼 pdf 阅读器</span>（可换成 `chromium` 或 `google-chrome` （AUR））
- `sof-firmware`：音频固件
- 应用全家桶：`kde-applications`

### 创建管理员账户

```sh
useradd -G wheel 用户名
passwd 用户名
```
接着修改 `/etc/sudoers`：
```sh
# Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```

### 让我们说中文！

安装中文字体，请出门右转 [Arch Wiki](https://wiki.archlinux.org/title/Localization/Simplified_Chinese#Chinese_fonts)。
- `noto-fonts-cjk` 可能出现日文汉字 ![](/images/00/ill-chars.png =50x){style="display:inline"}，解决方法记录于上方🔗的 1.2.2.2 章节。
- HMCL 可能需要安装 `wqy-microhei`，不然中文会变成口口。

再次编辑 `/etc/locale.conf`，改成 `LANG=zh_CN.UTF-8`。

安装 `fcitx5` 输入法：
```sh
sudo pacman -S fcitx5{,-chinese-addons,-qt,-gtk,-configtool}
```
在系统设置中，找到虚拟键盘，选择 Fcitx5。
在 `/etc/environment` 末尾添加一行 `XMODIFIERS=@im=fcitx5`，不然包括 VSCode 在内的部分应用无法使用输入法。

[参考资料](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma "Using Fcitx 5 on Wayland")，实测应该把 `fcitx` 换成 `fcitx5`

### 配置登录界面

SDDM 的默认主题又老又丑，换成 Plasma 自带的 `breeze` 主题。（p.s. 主题位于 `/usr/share/sddm/themes`）

以及登陆界面在我的 3072x1920 14 寸💻上界面太小，需要改大一些。

编辑 `/usr/lib/sddm/sddm.conf.d/default.conf`，找到对应位置改成：
```conf
[General]
GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192

[Theme]
Current=breeze
```

[参考资料](https://github.com/sddm/sddm/issues/1704 "Arch Linux Forums")

### 使用 pipewire 播放声音

据说延时比 pulseaudio 低，但这真的是有必要的吗？

[搬运](https://bbs.archlinux.org/viewtopic.php?id=273969 "Arch Linux Forums")

服务 `pipewire-media-session` 已经不存在了。

```sh
sudo pacman -S pipewire-{jack,alsa,pulse} wireplumber
systemctl --user enable --now pipewire{,-pulse}
```

## 其他软件及配置

### 启用 archlinuxcn 源

[摘自](https://github.com/archlinuxcn/repo)

在 `/etc/pacman.conf` 末尾添加：
```conf
[archlinuxcn]
Server = https://repo.archlinuxcn.org/$arch
# Server = https://mirrors.pku.edu.cn/archlinuxcn/$arch
```

```sh
sudo pacman -Sy archlinuxcn-keyring
```

### 安装 yay

```sh
sudo pacman -S yay
```

### vscode

开源版插件不全，所以用闭源的。由于 vscode 通过最近文件打开文件夹会变成文件管理器打开，所以再装个补丁。

```sh
yay -S visual-studio-code-bin vscode-xdg-patch-hook
```

按 Ctrl+Comma， 打开设置，修改字体，推荐 Fira Code（运行 `pacman -S ttf-fira-code` 安装）。

### 代理

安装代理软件 Clash Verge，并导入订阅。
```sh
sudo pacman -S clash-verge
```

在浏览器配置代理，然后在 clash 里面复制环境变量，编辑 `shell` 的配置文件，在末尾添加：

```sh
function proxy_on() {
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890 # 此处粘贴环境变量
}
function proxy_off() {
  unset http_proxy https_proxy all_proxy
}
```

配置 `git` 代理：

```sh
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy https://127.0.0.1:7890
```

### 其他软件

按需安装。分别是：邮箱，笔记，压缩包管理器，截图工具，画图，[蒸汽学原理]{.heimu title="你知道的太多了"}。

```sh
sudo pacman -S thunderbird xournalpp ark spectacle kolourpaint steam
```

### Thinkbook 补丁

Thinkbook 2024 系列似乎普遍有个 bug，电脑睡眠后合盖会立刻关机，安装补丁 `ideapad-laptop-tb2024g6plus-dkms`。

然而 AUR 上的包已经过时了，所以我们直接去[上游 `github` 仓库](https://github.com/ty2/ideapad-laptop-tb2024g6plus)。

upd 2025/4/1：在内核版本 `6.13.8-arch1-1` 中，电池供电（时睡眠？）虽然不会关机但是会导致电脑变非常卡（测试：使用 `stress --cpu 18` 烤鸡时 `grep cat /proc/cpuinfo | grep MHz` 显示每个核心的频率均不足 1GHz），安装上述补丁可以解决该问题。
