---
title: Arch Linux 安装记
date: 2025-09-29 20:48:19
tags:
categories:
description:
---

## 前言

本文假设读者已充分阅读过[安装指南](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)，重复内容不再赘述。

本文假设读者具有 Linux 基础，熟悉终端操作。

本文假设电脑引导模式为 64 位 x64 UEFI，具备 Intel CPU。

本文使用 GRUB 引导，BTRFS 文件系统，使用 NetworkManager 连接互联网，图形界面为 SDDM + KDE Plasma 桌面，输入法管理 fcitx5，声音管理使用 pipewire。

## 基础安装

### 获取安装镜像

逃课：[Arch Linux GUI](https://sourceforge.net/projects/arch-linux-gui/files/)

### 准备安装介质

强推 [Ventoy](https://www.ventoy.net/cn/index.html)

### 联网

个人建议连网线，或者通过数据线连接手机并在手机里开启 USB 网络共享（安卓大概都支持）。

### 分区并挂载

#### 文件系统选择

笔者使用过 [ext4](https://wiki.archlinux.org/title/Ext4) 和 [btrfs](https://wiki.archlinux.org/title/Btrfs)。
- ext4 更加成熟稳定。
- btrfs 支持快照和数据校验等多种高级功能，并且 CoW 机制能保证数据一致性。（注：请确保硬件可靠，据说 btrfs 数据恢复比较困难）
- 如果希望创建额外数据分区用于多系统互通，使用 (ex)FAT 或 NTFS（仅与 Windows 互通）

#### 设计分区方案

1. 将 EFI 分区挂载于 `/efi`
    - 可以减少 EFI 分区的空间占用，双系统友好。
    - 本人教训：260M 的 EFI 分区，装完 nvidia 驱动占用 370MB💥
    - 注意引导程序应能够访问 `/boot` 目录。
2。 若文件系统支持子卷，为了灵活性建议尽量以子卷取代分区。 
3. 使用交换文件取代交换分区（若文件系统支持）
    - 二者在功能和性能上没有区别，前者的优点是可以灵活调整。
4. 可将特定目录单独分区，例如 `/home`（用户的各种文件）和 `/opt`（独立软件，感觉类似 AppImage）。
    - 可防止回滚/重装系统时误删文件。
    - 清除旧系统时可以直接格式化根分区。
5. 一些不需要分区的目录：
  1. `/var`
    - btrfs 和 ext4 文件系统都不会因为存储大量小文件而影响性能。
    - 主要空间占用来自软件包缓存和系统日志，定期清理即可。
  2. `/usr`
    - [详见](https://systemd.io/SEPARATE_USR_IS_BROKEN/)
  3. `/tmp`
    - 默认使用 `tmpfs` 挂载，因此该分区实际位于内存或交换空间，无需担心性能问题。
    - 若默认一半物理内存的容量不足，可以临时 `sudo mount -o remount,size=64G /tmp` 或者在 `fstab` 里添加挂载选项 `size=...G` 手动设置大小。

#### 格式化并挂载

过程略，BTRFS 的比较细致的分卷方法见另一篇博文的相应章节：{% post_link "Arch Linux 下 Btrfs 使用小记" %}。


### 安装必需的软件包

如果你的镜像不是最近下载的，需要先更新密钥环：
```sh
pacman -Sy archlinux-keyring
```

然后安装软件包到新系统：

```sh
pacstrap -K /mnt base linux linux-firmware btrfs-progs vim sudo networkmanager wpa_supplicant iwd usb_modeswitch intel-ucode
```

- `-c` 选项使用系统软件包缓存，如果是重装系统，可以加上。
- 文本编辑器三选一：`nano`, `vim`, `emacs` ，我选 `vim`，新手推荐 `nano`。
- `btrfs-progs`：管理 `btrfs` 文件系统需要的工具。
- `networkmanager`, `wpa_supplicant`, `iwd`：联网用的。
- `usb_modeswitch`：切换设备的工作模式，部分型号的无线网卡可能安装这个包才能正常识别，因为默认模式是存储器（存放驱动程序？）

### 杂项速通

```sh
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime # 北京时间
echo "主机名" > /etc/hostname
passwd
vim /etc/locale.gen # uncomment en_US.UTF-8 and zh_CN.UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### 安装 GRUB

```sh
pacman -S efibootmgr grub
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## 进阶配置

### 启用网络服务

```sh
systemctl enable NetworkManager
```

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

### 启用 archlinuxcn 源

[摘自](https://github.com/archlinuxcn/repo)

在 `/etc/pacman.conf` 末尾添加：
```conf
[archlinuxcn]
Server = https://repo.archlinuxcn.org/$arch
# Server = https://mirrors.pku.edu.cn/archlinuxcn/$arch
```

```sh
sudo pacman -Syu archlinuxcn-keyring
```

### 安装 yay（AUR 助手）

需要 archlinuxcn 源，或者从 Github 下载。`base-devel` 是所有 AUR 包的依赖。

```sh
sudo pacman -S yay base-devel
```

### ssh 服务端与 Tailscale 内网穿透

```sh
sudo pacman -S openssh tailscale
sudo systemctl enable --now tailscaled sshd
```

运行命令 `tailscale up` 以连接到 Tailscale 虚拟局域网，首次使用需登陆认证，之后开机自动连接。

## 安装桌面

```sh
pacman -S sddm plasma konsole dolphin
systemctl enable sddm bluetooth
```
- 音频方面统一选带 `pipewire` 的
- `sddm`：显示管理器
- `konsole`：终端
- `dolphin`：文件管理器
- `sof-firmware`：音频固件
- 可选安装应用全家桶：`kde-applications-meta`

### 让我们说中文！

安装中文字体，请出门右转 [Arch Wiki](https://wiki.archlinux.org/title/Localization/Simplified_Chinese#Chinese_fonts)。

- `noto-fonts-cjk` 可能出现日文汉字 {% inlineImg /images/00/ill-chars.png 16px %}，解决方法记录于上方🔗的 1.2.2.2 章节。

再次编辑 `/etc/locale.conf`，改成 `LANG=zh_CN.UTF-8`。

安装 `fcitx5` 输入法^[[Using Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma)]:
```sh
sudo pacman -S 
```
在系统设置中，找到虚拟键盘，选择 Fcitx5。
在 `/etc/environment` 末尾添加一行 `XMODIFIERS=@im=fcitx5`，不然包括 VSCode 在内的部分应用无法使用输入法。

### 配置登录界面

SDDM 的默认主题又老又丑，换成 Plasma 自带的 `breeze` 主题。（p.s. 主题位于 `/usr/share/sddm/themes`）

以及登陆界面在我的 3072x1920 14 寸💻上界面太小，需要改大一些。

创建文件 `/etc/sddm.conf.d/wayland.conf`，写入：
```conf
[Theme]
Current=breeze
CursorSize=24
CursorTheme=breeze_cursors

[General]
DisplayServer=wayland
GreeterEnvironment=QT_FONT_DPI=120

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1 --inputmethod qt6-virtualkeyboard
```

### 使用 pipewire 播放声音 ^[[Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=273969)]

Update: 服务 `pipewire-media-session` 已经不存在了。

```sh
sudo pacman -S pipewire-{jack,alsa,pulse} wireplumber sof-firmware
systemctl --user enable --now pipewire{,-pulse}
```

### 软件推荐

按需安装。分别是：邮箱，笔记，压缩包管理器，截图工具，画图，[蒸汽学]{.heimu title="你知道的太多了"}。

```sh
sudo pacman -S thunderbird xournalpp ark spectacle kolourpaint steam
```

#### oh-my-zsh

安装软件包，其中 `ttf-firacode-nerd` 可换成其他 `nerd` [字体](https://www.nerdfonts.com/font-downloads)：
```sh
sudo pacman -S zsh git ttf-firacode-nerd --needed
```

安装 oh-my-zsh^[[Oh My Zsh](https://ohmyz.sh/)]：
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

安装 `powerlevel10k` 主题并配置^[[zsh 安装与配置，使用 oh-my-zsh 美化终端](https://www.haoyep.com/posts/zsh-config-oh-my-zsh/)]：
```sh
yay -S zsh-theme-powerlevel10k-git
echo "source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
p10k configure
```

安装插件：`zsh-autosuggestions`，`zsh-syntax-highlighting`

```sh
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
```

启用插件，编辑配置文件：
```sh ~/.zshrc
plugins=(git z extract web-search)
```

效果截图（VSCode Integrate Terminal）：
![](/images/00/omz.png)

#### VSCode

开源版插件不全，所以用闭源的。由于 vscode 通过最近文件打开文件夹会变成文件管理器打开，所以再装个补丁。

```sh
yay -S visual-studio-code-bin vscode-xdg-patch-hook
```

### 配置
按 <kbd>Ctrl</kbd>+<kbd> , </kbd> 打开设置，点击右上角 `Open Settings(JSON)`，编辑配置文件。

示例：（以下配置需要 `FiraCode Nerd` 字体）
```json settings.json
{
    "editor.fontFamily": "'Firacode Nerd Font Mono', 'Noto Sans Mono CJK SC'",
    "editor.fontLigatures": true, // 开启字体连字
    "terminal.integrated.enableMultiLinePasteWarning": "never",
    "terminal.integrated.defaultProfile.linux": "zsh",
    
    "[markdown]": {
        "editor.wordBasedSuggestions": "off",
        // 快速补全
        "editor.quickSuggestions": {
            "other": true,
            "comments": true,
            "strings": true
        },
        // 显示空格
        "editor.renderWhitespace": "all",
        // snippet 提示优先（看个人喜欢）
        "editor.snippetSuggestions": "top",
        "editor.tabCompletion": "on",
        // 使用enter 接受提示
        // "editor.acceptSuggestionOnEnter": "on",
    },
    "makefile.configureOnOpen": true,
    "terminal.integrated.fontFamily": "'Firacode Nerd Font Mono'",
}
```

#### Neovide

neovim 的一款图形界面，参考配置[见此](https://github.com/berrylium0078/nvim-config/blob/main/lua/config/neovide.lua)。

#### Thinkbook 补丁

Thinkbook 2024 系列似乎普遍有个 bug，电脑（电池供电？）睡眠后合盖会导致关机，安装 AUR 补丁 `ideapad-laptop-tb-dkms`。

### 配置代理

图形界面可以安装 `clash-verge-rev`，但是新版不知道在抽什么风（截至2025.9）目前本人在用 `2.3.1-1`。
