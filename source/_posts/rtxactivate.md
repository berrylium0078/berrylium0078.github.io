---
title: rtx启动！
date: 2025-02-11 20:50:43
tags: archlinux
---

## 前言

记录了给 archlinux 安装 nvidia 显卡驱动的过程，使用借来的 RTX4090 测试。

电脑配置是 Thinkbook 14+ G6 IMH，TGX 接口外接联想官方的显卡扩展坞。

## 安装驱动

跟着[教程](https://github.com/korvahannu/arch-nvidia-drivers-installation-guide?tab=readme-ov-file#add-early-loading-of-nvidia-modules)做的，执行完前两步后重启试了一下~~没读教程开头警告，好孩子不要学~~发现 SD webui 已经能用了。

p.s. 我怀疑第三步是使用显卡的图形功能用的，AI 计算并不需要。开头不能中间重启的警告大概是给没核显的人看的。

~~但是游戏还是要玩的，练AI什么的只是借口~~，于是去执行第三步，中途发生些[*小插曲*](/2025/02/11/efifull/)。

## 测试

### Stable Diffusion

从[汤姆的硬件](https://www.tomshardware.com/pc-components/gpus/stable-diffusion-benchmarks#:~:text=We've%20tested%20all%20the%20modern%20graphics%20cards%20in%20Stable%20Diffusion,)上抄的天梯图：

![](https://cdn.mos.cms.futurecdn.net/RtAnnCQxaVJNYgA4LbBhuJ-1200-80.png =300x){style="display:inline"}

以下测试统一采样步数为 50，图像尺寸 512x512

**测试1**
采样方法：DPM++ SD Karras，75x1 图用时 ~5min30s。

**测试2**
采样方法：DPM++ SD Karras，15x5 图用时 ~4min30s。

怎么还打不过 4060？急急急

**测试3**

采样方法：DPM++ 3M SDE，10x8 图用时 2min25s。

蚌:sweaty_smile:，采样方法对速度影响很大，测评网站居然不把这么重要的参数列出来，真不专业。

假装天梯图用的测试3参数好了，那么在外接情形下也有相当甚至略好于 RTX4070 的实力。

~~换言之高于这个配置可能外接的损耗成为效率主要决定因素~~

### MC 开光影

启动器要开启 Vulkan，不然 OpenGL 不能识别外接显卡。3920x2560 分辨率下帧率 90+。快速移动时会有神秘黑色三角形闪现。

### BeamNG.Drive

分辨率 1920x1200，帧率 90+，不是非常稳定，加载地图时偶有闪烁。