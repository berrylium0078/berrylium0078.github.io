---
title: ssh 使用小记
date: 2025-09-10 17:00:00
tags: ["ssh", "linux", "tailscale", "内网穿透", "screen", "终端复用"]
categories: "linux"
description: "以 ssh 为核心的远程连接相关工具大杂烩"
---

## 传统 ssh

### 创建密钥对

由于远程主机需要确认所要执行的命令确实发自你，需要进行签名，详见 [Digital signature - Wikipedia](https://en.wikipedia.org/wiki/Digital_signature)

```sh
ssh-keygen [-t ed25519 | rsa] [-C comment] [-f keyfile]
```

其中 `-t` 参数指定加密算法，常见的有 `ed25519` 和 `rsa`，更推荐前者因为可以用更短的密钥长度获得相同加密强度。

个人习惯将密钥对存放在 `~/.ssh`，命名 `id_${algorithm}-${hostname}`。

例如，在 `~/.ssh` 目录下创建 `keyfile` 和 `keyfile.pub` 文件，分别对应私钥和公钥，可以通过命令：

```sh
ssh-keygen -t ed25519 -f ~/.ssh/keyfile
```

在创建过程中会让你输入 passphrase（可选），这个是用来加密私钥的，可以多一层防护。

将公钥 `keyfile.pub` 追加到远程主机 `hostname` 的 `~/.ssh/authorized_keys` 文件（或者，云服务器管理面板应该有导入密钥界面）。

`hostname` 一般为 IPv4，不过如果有域名的话当然也可以用域名。

### 连接到远程主机

```sh
ssh user@hostname -i private_key_file
```

如果没有域名，为方便可编辑本地机器的 `~/.ssh/config` 文件，追加如下条目：

```
Host host
  HostName hostname
  User user
  IdentityFile private_key_file
```

这样以后 `ssh` 就只需：

```sh
ssh host
```

### 连接复用

对相同主机及用户的多个 `ssh` 连接可以共用套接字，以避免重复建立加密通道的开销。

新建`~/.ssh/sockets` 目录（其实其他目录也行，看你喜好了）

```
Host host
    ......
    ControlMaster auto
    ControlPersist 10m
    ControlPath ~/.ssh/sockets/socket-%r@%h:%p
```

各参数的功能见 [ssh_config(5)](https://man.archlinux.org/man/ssh_config.5)

## tailscale 内网穿透

如果你的服务端运行在本地，但是需要在公网访问，可以在服务端和客户端都安装 tailscale，组建虚拟局域网。

在服务端运行 `sudo tailscale set --ssh` 启用 `ssh` 服务。

在客户端运行 `tailscale ssh host` 即可直接 `ssh` 到 `host`。

在开启 MagicDNS 的情况下，无需额外配置即可 `ssh host`。

### DNS fight

`tailscale` 默认开启 MagicDNS，但是这个功能会和 `dhcpcd` 竞争 `/etc/resolv.conf`，所以我给 MagicDNS 关了。

Tailscale 的虚拟 IP 仍会工作，但是不再能通过主机名解析对应的 IP。

如果想配置 `ssh`，可以像上面一样编辑 `~/.ssh/config` 文件，`HostName` 添 tailscale 的虚拟 IP。

## 更多 ssh

需要先按照上述方法创建一个 ssh 连接。

### 复制文件

一种方法是 `scp` 命令。

```sh
scp [OPTION] source... target
```

其中 `source` 和 `target` 可以是本地路径，或者远程路径形如 `[user@]host:[path]` 或 `scp://[user@]host[:port][/path]`

另一种方法是 `rsync` 命令（`rsync` 默认使用 ssh ^[
For remote transfers, a modern rsync uses ssh for its communications, but it may have been configured to use a different remote shell by default, such as rsh or remsh.]）
```sh
rsync [OPTION]... SRC [SRC]... [USER@]HOST:DEST
```

常用的参数为：
- `-a`, `--archive` archive mode is -rlptgoD (no -A,-X,-U,-N,-H)
- `-v`, `--verbose` increase verbosity
- `-z`, `--compress` compress file data during the transfer
- `--del`, `--delete-during` delete extraneous files from dest dirs

### ssh 文件系统

```sh
sshfs [user@]host:[dir] mountpoint
```

貌似不好用，网络异常之后会死机。

### sftp

以 Dolphin（KDE 默认文件管理器）为例，在地址栏输入 `sftp://user@host` 即可。

如果已经配置了 `~/.ssh/config`，只输 `sftp://host` 也行。

### 端口转发

即让 `localhost:port` 指向 `host:hostport`：

```ssh
ssh -L port:host:hostport user@host
```

## 终端复用

当在远程主机上运行耗时较长的命令时，将终端会话和 SSH 连接解绑是个好主意，这样即使出现网络错误也不会丢失进度。

一般有两个选择：[GNU Screen](https://wiki.archlinux.org/title/GNU_Screen) 和 [Tmux](https://wiki.archlinux.org/title/Tmux)，后者对窗口管理的支持更好（类似 Vim ?），但说实话我不理解，我觉得 Konsole 挺好用的，所以下文仅介绍 Screen。

### Screen

```sh
screen -S mysession # 创建一个命名会话
screen ls           # 列出会话
screen -r mysession # 连接到会话
```

常用快捷键：
- `Ctrl+A ?` 查看帮助
- `Ctrl+A D` 从当前会话分离
