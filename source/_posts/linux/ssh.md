---
title: ssh 使用小记
date: 2025-09-10 17:00:00
tags: ["ssh", "linux"]
categories: "linux"
description: ""
---

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

为了方便，可以编辑本地机器的 `~/.ssh/config` 文件，写入如下内容：

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

### 我们需要更多 ssh

#### 复制文件

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

#### ssh 文件系统

```sh
sshfs [user@]host:[dir] mountpoint
```

貌似不好用，网络异常之后会死机。

#### sftp

以 Dolphin（KDE 默认文件管理器）为例，在地址栏输入 `sftp://username@host` 即可。

如果已经配置了 `~/.ssh/config`，只输 `sftp://host` 也行。

还有一个古老的 `fish` 协议，`fish://user@host` 不知为何必须在此手动指定用户名。

#### 端口转发

即让 `localhost:port` 指向 `host:hostport`：

```ssh
ssh -L port:host:hostport user@host
```
