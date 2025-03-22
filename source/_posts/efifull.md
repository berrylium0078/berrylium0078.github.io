---
title: EFI 分区满了
date: 2025-02-11 20:29:05
tags: archlinux
---

## 事故描述

EFI 分区被塞爆了！！！

因为预留 EFI 分区时，笔者看了一下上一台电脑的 `/boot` 占用约 180M，俺寻思 260M 绝对够用了，然后用了半年。

昨天在装 nvidia 驱动时炸了，`mkinitcpio` 报错剩余空间不足。重启后不能开机，表现为 grub 还活着，但是启动时报错 Initramfs unpacking failed: ZSTD-compressed data is truncated。

## 修复过程

掏出启动盘，开始扩容分区。但因为 EFI 是第一个分区，而我不敢移动主分区……所以在后方腾出 1G 空间新建分区，并标记为 `EFI Partition`。

接着挂载分区并 chroot：
```
mount -o subvol=@ /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p1 /mnt/boot-old --mkdir
mount /dev/nvme0n1p3 /mnt/boot
arch-chroot /mnt
```

然后俺寻思不就是重新运行 `mkinitcpio` 的事么🤓☝️看我操作
```sh
vim /etc/fstab # 把 /boot 分区从 p1 换成 p3
cp -r /mnt/boot-old/* /mnt/boot
mkinitcpio -P
```
重启，没效果 🤨 把 `/etc/mkinitcpio.conf` 改回去再重试也不行。

感觉有可能是因为忘了把第一个分区取消标记为 EFI 分区，导致固件还是选择的这个分区启动😕，于是给他改成了「Microsoft保留」（🦐选的）。

还是没用 😨。再重装 `grub` 试试 😵‍💫。

```sh
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

然后就好了 😅，又把 `mkinitcpio.conf` 改掉再重新 `mkinitcpio.conf`，还是好的。

原因我猜是 GRUB 直接通过分区 UUID 定位镜像，所以直接复制的话还使用的是第一分区中的损坏镜像。

## 后续

修好一看，EFI 分区占用变成 361MB……

后来又在 wiki 上找到了将 EFI 分区挂载于 `/efi` 的分区方案，确认了一下 GRUB 支持 btrfs。于是又把旧 EFI 分区的挂载点改为 `/efi`，删掉新 EFI 分区，`/boot` 目录和 `/` 放在同一子卷下。