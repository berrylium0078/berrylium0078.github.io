---
title: 建站踩坑记
date: 2024-09-05 09:04:39
tags: 杂项
mathjax: true
---

## 前言

选择 redefine 主题是因为看到[学弟](http://flamire.github.io/)在用，于是跟风。

用起来感觉确实不错，加载很快，页面美观，功能虽然不是最全的但也够用，然而对数学公式和表情包的支持不好……

加了别的插件解决了问题，所以记录一下搭建过程。

p.s. 学弟不知为何删库跑路了，截至 2024/11/02 仍未回归。

### 安装软件包

```sh
sudo pacman -S nodejs npm
npm install hexo-cli -g
```

### 安装 redefine 主题

参(ban)考(yun)官方教程：[hexo](https://hexo.io/zh-cn/)，[theme redefine](https://redefine-docs.ohevan.com/getting-started)

假设你的博客安装想要在当前目录下的 `blog` 文件夹中，运行命令：

```sh
hexo init blog
cd blog
npm install
npm install hexo-theme-redefine@latest
wget https://raw.githubusercontent.com/EvanNotFound/hexo-theme-redefine/main/_config.yml -O _config.redefine.yml
```

以下默认工作目录为 Hexo 根目录，即上面命令新建的 `blog` 目录

在 `_config.yml` 文件中，将 `theme` 值修改为 `redefine`。

```yml
theme: redefine
```

此时已经可以 `hexo s` 测试并配置博客了。

### 更换插件

为了更好的数学公式和脚注、图片缩放等功能，需要换一下插件：

```sh
npm uninstall hexo-renderer-marked --save
npm uninstall hexo-math --save
npm install hexo-renderer-markdown-it-plus --save
npm install markdown-it-mathjax3 --save
npm install markdown-it-imsize --save
npm install markdown-it-attrs --save
npm install markdown-it-task-lists --save
```

由于 KaTeX 功能不全，且新版 MathJax 做了效率优化，所以这里可以放心选 MathJax。

至于缩写……可以配置 vscode snippets（有个插件 `math-snippets` ）辅助输入，或者在文件头部插入自己定义的宏。

然后在 `_config.yml` 末尾添加：

```yml
markdown_it_plus:
    highlight: true
    html: true
    xhtmlOut: true
    breaks: true
    langPrefix:
    linkify: true
    typographer:
    quotes: “”‘’
    plugins:
        - plugin:
            name: "@iktakahiro/markdown-it-katex"
            enable: false
        - plugin:
            name: markdown-it-mathjax3
            enable: true
        - plugin:
            name: markdown-it-imsize
            enable: true
        - plugin:
            name: markdown-it-attrs
            enable: true
        - plugin:
            name: markdown-it-task-lists
            enable: true
```

[测试链接](/2024/09/16/test)

### 部署到 github pages

配置 deployer

```sh
npm install hexo-deployer-git --save
```

github 上新建名为 *username*.github.io 的**公开**存储库，这里 *username* 是你的 github 用户名

编辑 `_config.yml`，改成（注意用户名改成你自己的）：
```yml
deploy:
  type: git
  repo: https://github.com/username/username.github.io
  branch: main
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

`_config.redefine.yml` 中修改

```yml
info:
    url: https://username.github.io
```

部署方法

```sh
hexo g -d
```