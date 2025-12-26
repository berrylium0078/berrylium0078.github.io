---
title: Plasma 6 桌面使用小记
date: 2025-12-26 12:17:20
tags:
categories:
description:
---

## 安装桌面

```sh
pacman -S sddm plasma
systemctl enable sddm
```
- 音频方面统一选带 `pipewire` 的
- `sddm`：显示管理器
- 可选安装应用全家桶：`kde-applications-meta`

## 让我们说中文！

安装中文字体，请出门右转 [Arch Wiki](https://wiki.archlinux.org/title/Localization/Simplified_Chinese#Chinese_fonts)。

- `noto-fonts-cjk` 可能出现日文汉字 {% inlineImg /images/00/ill-chars.png 16px %}，解决方法记录于上方🔗的 1.2.2.2 章节。

编辑 `/etc/locale.conf`，改成 `LANG=zh_CN.UTF-8`。

安装 `fcitx5` 输入法^[[Fcitx5 - Arch Wiki](https://wiki.archlinux.org/title/Fcitx5)]:
```sh
sudo pacman -S fcitx5 fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-configtool
```
在系统设置中，找到虚拟键盘，选择 Fcitx5。

在 `/etc/environment` 末尾添加如下内容：^[[Using Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma)]
```env
XMODIFIERS=@im=fcitx
QT_IM_MODULE=fcitx
QT_IM_MODULES="wayland;fcitx"
```

可选安装字典：（注：萌娘百科需要 AUR 或 archlinuxcn）
```sh
sudo pacman -S fcitx5-pinyin-{zhwiki,moegirl}
```

## 配置登录界面

SDDM 的默认主题又老又丑，换成 Plasma 自带的 `breeze` 主题。（p.s. 主题位于 `/usr/share/sddm/themes`）

以及登陆界面在 2K 显示器上界面太小，需要改大一些。

创建文件 `/etc/sddm.conf.d/wayland.conf`，写入（DPI/CursorSize 仅供参考）：
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

## 使用 pipewire 播放声音 ^[[Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=273969)]

Update: 服务 `pipewire-media-session` 已经不存在了。

```sh
sudo pacman -S pipewire-{jack,alsa,pulse} wireplumber sof-firmware
systemctl --user enable --now pipewire{,-pulse}
```

## 其他软件推荐

### 终端美化 oh-my-zsh

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

按需安装。分别是：邮箱，笔记，压缩包管理器，截图工具，画图，[蒸汽学]{.heimu title="你知道的太多了"}。

```sh
sudo pacman -S thunderbird xournalpp ark spectacle kolourpaint steam
```

### VSCode

开源版插件不全，所以用闭源的。由于 vscode 通过最近文件打开文件夹会变成文件管理器打开，所以再装个补丁。

也可以换成 Insiders 版本，AUR 包名为 `visual-studio-code-insiders-bin`。

```sh
yay -S visual-studio-code-bin vscode-xdg-patch-hook
```

#### 配置
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

### Neovide

neovim 的一款图形界面，参考配置[见此](https://github.com/berrylium0078/nvim-config/blob/main/lua/config/neovide.lua)。

~~对着 LazyVim 的插件列表自己装着玩的~~

### 办公套装

推荐 WPS Office，AUR 包名 `wps-office-365{,fonts}`，学生认证可以用 `wps-office-365-edu{,fonts}`。

搬运置顶评论（2025/10/31):
> If you cannot open it after installation, it's because there's an error when WPS parse configuration file.
> You can edit or create $HOME/.config/Kingsoft/Office.conf with:
> ```conf
> [6.0]
> wpsoffice\Application%20Settings\AppComponentMode=prome_independ
> ```

### KOrganizer 日历

```sh
pacman -S korganizer
```

(2025/12/26) Korganizer 报错后台服务不是可选服务。

这是因为 KOrganizer 依赖 Akonadi 框架，而 Akonadi 需要一个数据库后端（Arch Linux 默认 MariaDB），而 MariaDB 最近有破坏性更新。

解决方法是编辑 `~/.config/akonadi/akonadiserverrc`，将 Executable 改成 `/usr/bin/mariadbd`（加个 `d`）。

### 配置代理

图形界面可以安装 `clash-verge-rev`，但是新版不知道在抽什么风（截至2025.12.25）目前本人在用 `2.3.1-1`。

### Thinkbook 补丁

Thinkbook 2024 系列似乎普遍有个 bug，电脑（电池供电？）睡眠后合盖会导致关机，安装 AUR 补丁 `ideapad-laptop-tb-dkms`。
