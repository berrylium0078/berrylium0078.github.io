---
title: btrfs 踩坑记
date: 2024-10-31 17:03:08
tags: archlinux
---

## 前言

btrfs 是一个支持写时复制、快照、分卷、透明压缩的文件系统。

## 开整！

全过程见[archlinux 安装记录](/2024/11/02/arch-install/)

本文仅记录不同部分。

### 硬盘分区并挂载

```sh
mkfs.btrfs -L 分区名 /dev/nvme0n1p2
mount -t btrfs /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@ # / 根目录

# 以下为不需要和系统一起快照的目录，可按需更改
btrfs su cr /mnt/@opt # /opt
btrfs su cr /mnt/@home # /home
btrfs su cr /mnt/@root # /root
btrfs su cr /mnt/@snapshots # /.snapshots，用来存放快照
btrfs su cr /mnt/@var_cache # /var/cache
btrfs su cr /mnt/@var_log # /var/log
btrfs su cr /mnt/@var_tmp # /var/tmp
btrfs su cr /mnt/@docker # /var/lib/docker

# 关闭一些子卷的 COW 功能（还没搞明白原因，据说能提高性能）
chattr +C /tmp/btrfs-full/@var-cache

umount /mnt
```

然后挂载分区：
```sh
mount -o noatime,nodiratime,compress=zstd,subvol=@ /dev/nvme0n1p2 /mnt
mount -o noatime,nodiratime,compress=zstd,subvol=@opt /dev/nvme0n1p2 /mnt/opt
mount -o noatime,nodiratime,compress=zstd,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o noatime,nodiratime,compress=zstd,subvol=@root /dev/nvme0n1p2 /mnt/root
mount -o noatime,nodiratime,compress=zstd,subvol=@snapshots /dev/nvme0n1p2 /mnt/.snapshots
mount -o noatime,nodiratime,compress=zstd,subvol=@var_log /dev/nvme0n1p2 /mnt/var/log
mount -o noatime,nodiratime,compress=zstd,subvol=@var_tmp /dev/nvme0n1p2 /mnt/var/tmp
mount -o noatime,nodiratime,compress=zstd,subvol=@var_cache /dev/nvme0n1p2 /mnt/var/cache
mount -o noatime,nodiratime,compress=zstd,subvol=@docker /dev/nvme0n1p2 /mnt/var/lib/docker
mount /dev/nvme0n1p1 /mnt/boot
```

### 安装必要软件包

这里需要先装 `btrfs-progs` 包，不然装 `linux` 内核时会报错。

```sh
pacstrap -K /mnt btrfs-progs
```

### 配置系统备份

```sh
sudo pacman -S snapper
sudo umount /.snapshots
sudo snapper -c root create-config /
sudo rm -r /.snapshots
sudo mount -o noatime,nodiratime,compress=zstd,subvol=@snapshots /dev/nvme0n1p2 /.snapshots
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
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

阻止非root用户访问
```sh
sudo chmod 750 /.snapshots
```

### 从快照恢复

用启动盘启动，挂载 btrfs 分区。

```sh
mount /dev/nvme0n1p2 /mnt
cd /mnt
```

把损坏的根子卷挪到别处

```sh
mv @ @-backup
```

列出所有快照及其创建时间

```sh
$ grep -r '<date>'  /mnt/@snapshots/*/info.xml
```

给快照创建一个可读写副本作为新的根子卷

```sh
btrfs subvolume snapshot /mnt/@snapshots/编号/snapshot /mnt/@
```

## 参考资料

[Arch Linux+btrfs配置简明指南](https://blog.azurezeng.com/archlinux-with-btrfs-simple-guide/)

[Snapper - ArchWiki](https://wiki.archlinux.org/title/Snapper)

[Arch Linux 配置 — Btrfs与系统备份](https://xland.cyou/p/arch-linux-configuration-btrfs-and-system-backup/#snapper%E8%87%AA%E5%8A%A8%E5%A4%87%E4%BB%BD)