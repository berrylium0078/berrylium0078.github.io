---
title: archlinux 安装记录
date: 2024-11-02 10:05:24
tags: archlinux
---

## 前言

记录一下日用 archlinux 系统的安装过程。使用 KDE Plasma 桌面环境。

以下是笔者的电脑配置：
型号：ThinkBook 14 G6+ IMH
CPU：Intel® Core™ Ultra 5 125H
核显：Mesa Intel® Arc
RAM：32GB

## 基础安装

先装一个能启动的 linux。

### 制作并启动安装介质

由于笔者已有安装 archlinux 的硬盘，所以这一步就跳过了。

没有怎么办？

先推荐一款启动盘制作工具：[Ventoy](https://www.ventoy.net/cn/index.html)，只要把下好的 iso 文件复制到 U 盘里就可以用了！非常方便！

然后执行 [Installation guide - ArchWiki](https://wiki.archlinux.org/title/Installation_guide) 1.1 ~ 1.8。

### 硬盘分区并挂载

前置知识：[Device file - ArchWiki](https://wiki.archlinux.org/title/Device_file#Block_device_names) 中的 1.1.{1,2,6}

~~其实可以自己找规律，不看问题也不大~~

终端分区工具推荐 cfdisk。确认写入之前请认真检查。

#### EFI 分区

可以用现成的，可以按需扩容，作为参考我 archlinux 占用 188.2MB，官方推荐 1GB。

如果新建的话分区类型选 1 号 EFI System，然后 `mkfs.fat -F 32 /dev/efi分区`。

#### swap 分区

主要有两个作用：
1. 内存不够时将一部分数据交换到硬盘里（相当于一块低速扩展内存）
2. 休眠时将内存数据保存到硬盘

看个人需求吧。这里我没有建。

#### 系统分区

如无特殊需求，可以只分一个根分区(`/`)，也可以将 `/home` 和 `/opt` 独立分区。其他似乎没有必要。

分区类型选 20 号 `Linux Filesystem`。

运行 `mkfs.ext4 /dev/分区名` 格式化为 `ext4` 文件系统。如果要选择其他文件系统，请先三思。

#### 挂载

```sh
mount /dev/根分区 /mnt
mount /dev/efi分区 /mnt/boot --mkdir
```

其他自建分区同理挂载。

#### 生成 fstab

这是一个告诉 linux 系统开机时要挂载哪些分区的文件。

```sh
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

生成后检查一下有没有问题，若有，手动修改。

注：新系统的根目录 `/` 在这里被我们挂载到 `/mnt`，但对新系统来说还是 `/`，请不要画蛇添足。

### 配置新系统

#### 安装必要软件包 & chroot

```sh
pacstrap -K /mnt base base-devel linux linux-firmware vim nano
arch-chroot /mnt
```

#### 设置时间

~~很遗憾没有北京时间~~

```sh
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```

#### 区域与语言设置

编辑 `/etc/locale.gen`，取消注释 `en_US.UTF-8 UTF-8` 和 `zh_CN.UTF-8 UTF-8` 两行。之后运行
```sh
locale-gen
```

为避免麻烦，这里先用英文，有 GUI 之后再改。创建并编辑 `/etc/locale.conf`，输入：
```conf
LANG=en_US.UTF-8
```

#### 主机名与账户密码

```sh
echo 起个霸气的名字 > /etc/hostname
```

设置 root 密码。

```sh
passwd
```

再创建一个管理员账户[^1]：

```sh
useradd -G wheel 管理员账户名
passwd 管理员账户名
```

开通权限，修改 `/etc/sudoers` 文件，取消注释：
```sh
# Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```

[^1]:[如何在 Arch Linux 下创建并配置 sudo 用户？](https://zhuanlan.zhihu.com/p/614960162)


#### 启用 multilib

编辑 `/etc/pacman.conf`，取消注释：

```conf
[multilib]
Include = /etc/pacman.d/mirrorlist
```

#### GRUB

[建议阅读](https://wiki.archlinux.org/title/GRUB)。

```sh
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi分区 --bootloader-id=GRUB
grub-mkconfig -o /efi分区/grub/grub.cfg
```

## 安装并配置 Plasma 桌面与常用软件

可以先重启检查一下能不能启动，也可以直接继续安装。

```sh
pacman -S ark iwd openssh xdg-utils dolphin konsole plasma-meta wget egl-wayland plasma-workspace wireless_tools htop smartmontools wpa_supplicant sddm plasma networkmanager
systemctl enable sddm.service
systemctl enable NetworkManager.service
```

### 安装显卡驱动

仅记录 Intel 核显。其他请参见 [Driver installation - ArchWiki](https://wiki.archlinux.org/title/Xorg#Driver_installation)

```sh
pacman -S intel-media-driver libva-intel-driver mesa vulkan-intel
```

### 安装微码

```sh
pacman -S intel-ucode # or amd-ucode
```

### 让我们说中文！

安装中文字体。[这里](https://wiki.archlinux.org/title/Localization/Simplified_Chinese#Chinese_fonts) 列出了一些软件包。

注：HMCL 使用 wqy 字体，请安装。

{% note orange fa-warning  %}
不建议使用 noto-fonts-cjk，否则会出现![](/images/00/ill-chars.png =50x){style="display:inline"}，[解决方法](https://wiki.archlinux.org/title/Localization/Simplified_Chinese#Chinese_characters_displayed_as_variant_(Japanese)_glyphs)
{% endnote %}

编辑 `/etc/locale.conf`，改成 `LANG=zh_CN.UTF-8`。

安装 `fcitx5` 输入法：
```sh
sudo pacman -S fcitx5 fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-configtool
```
在系统设置中，找到虚拟键盘，选择 Fcitx5。

编辑 `/etc/environment`，添加一行 `XMODIFIERS=@im=fcitx5`，不然包括 VSCode 在内的部分应用无法使用输入法[^2]。

[^2]:[Using Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma)

### 让我们播放声音！

参考[^3]。

```sh
sudo pacman -S sof-firmware dkms
sudo pacman -S pipewire-{jack,alsa,pulse} wireplumber
sudo pacman -S pulseaudio-qt
systemctl --user enable --now pipewire pipewire-pulse pipewire-media-session
```

[^3]:[how to switch to pipewire from pulseaudio](https://bbs.archlinux.org/viewtopic.php?id=273969)



### 蓝牙

```sh
sudo pacman -S bluez bluez-utils
systemctl enable bluetooth.service --now
```

### 代理

先想办法搞到一个 clash for windows。

然后安装 `proxychains` 进行终端代理。

```sh
sudo pacman -S proxychains-ng
```

编辑 `/etc/proxychains.conf`，输入：

```conf
socks5 127.0.0.1 7890
http 127.0.0.1 7890
```

配置 `git` 代理：~~怎么感觉没用？~~

```sh
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy https://127.0.0.1:7890
```

### yay

前往[官网](https://github.com/Jguer/yay)

```sh
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si
```

如果 `go` 下载失败，执行 `proxychains makepkg -si`

还不行，换成 `yay-bin`

### vscode

开源版插件不全，所以这里我们用闭源的 ~~网炸了就 proxychains~~

```sh
yay -S visual-studio-code-bin
```

按 Ctrl+Comma， 打开设置，修改字体，推荐一款 `ttf-fira-code`。

安装插件 `markdown all in one` 和 `math snippets`。

修改设置，添加如下内容[^4]：
```json
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
```

[^4]:[在VSCode中高效编辑markdown的正确方式](https://www.thisfaner.com/p/edit-markdown-efficiently-in-vscode)

### 配置登录界面

sddm 的默认主题简直是清朝文物。这里我们换成自带的 `breeze` 主题。

p.s. 主题文件夹为 `/usr/share/sddm/themes`

以及 sddm 在我的 3072x1920 显示屏上界面太小，需要改大一些。

编辑 `/usr/lib/sddm/sddm.conf.d/default.conf`，找到对应位置改成[^5]：
```conf
[General]
GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192

[Theme]
Current=breeze
```

[^5]:[Specify DPI on Wayland?](https://github.com/sddm/sddm/issues/1704)


### 其他软件

按需安装。

```sh
sudo pacman -S firefox spectacle kolourpaint partitionmanager thunderbird xournalpp texlive
```

Thinkbook 2024 G6+ 系列有个 bug，电脑睡眠后合盖会立刻关机，安装补丁[^6]：
[^6]:[ThinkBook 14+ Gen6 AMD resets when suspending with lid close](https://bbs.archlinux.org/viewtopic.php?pid=2175065#p2175065)


```sh
sudo pacman -S ideapad-laptop-tb2024g6plus-dkms
```