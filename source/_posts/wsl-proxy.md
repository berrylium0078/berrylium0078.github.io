---
title: wsl-proxy
date: 2024-11-02 17:36:51
tags: wsl
---

WSL2 可以通过配置走 Windows 的代理。

创建并编辑主目录（`C:\Users\用户名`）下 `.wslconfig` 文件：

```
[wsl2]
dnsTunneling=false
networkingMode=mirrored
autoProxy=true
```

然后重启 WSL

```powershell
wsl --shutdown
wsl
```

测试代理。在 WSL 中，输入：

```sh
curl -i www.google.com
```

如果一切顺利，应该输出一段 html 代码。