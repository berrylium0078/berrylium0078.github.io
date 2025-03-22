---
title: 建站记录
date: 2024-09-05 09:04:39
tags: 杂项
mathjax: true
---

## 前言

选择 redefine 主题是因为看到[学弟](http://flamire.github.io/)在用，于是跟风。

用起来感觉确实不错，加载很快，页面美观，功能虽然不是最全的但也够用，然而对数学公式和表情包的支持不好……

加了别的插件解决了问题，所以记录一下搭建过程。

功能测试[*戳我*](/2024/11/04/test/)


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

可以尝试一些[其他插件](https://github.com/TenviLi/awesome-hexo-plugins)。

由于 KaTeX 支持的功能不如 MathJax 多，且后者做了效率优化，所以这里选 MathJax。

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

### 更改字体

可以去 [Google Fonts](https://fonts.google.com) 上找字体。以下为示例：

编辑 `_config.redefine.yml`，找到 `global > fonts > chinese`：
```yml
enable: true # Whether to enable custom chinese fonts
family: "Noto Sans SC" # Font family
url: "https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@100..900&family=Noto+Serif+SC:wght@200..900&display=swap" # Font URL to CSS file
```

### 部署到 github pages

配置 deployer

```sh
npm install hexo-deployer-git --save
```

github 上新建名为 用户名.github.io 的公开仓库。

编辑 `_config.yml`，改成：
```yml
deploy:
  type: git
  repo: https://github.com/用户名/用户名.github.io
  branch: public
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

`_config.redefine.yml` 中修改

```yml
info:
    url: https://用户名.github.io
```

部署方法

```sh
hexo g -d
```

### 添加自定义 CSS

作为示例，添加一个萌娘百科的黑框。[参考资料](https://wangquanlikun.github.io/2023/03/18/css-moegirl)，但是修改主题文件属于非法操作，事实上我们可以使用 injector 注入 CSS。

编辑 `_config.redefine.yml`，对应位置改成：
```yml
inject:
  enable: true
  head:
    - <link rel="stylesheet" href="/css/heimu.css">
```

新建文件 `/source/css/heimu.css`：
```css
.heimu,
.heimu rt {
 background-color:#252525;
}
.heimu,
.heimu a,
a .heimu,
a.new .heimu,
span.heimu a.new,
span.heimu a.external,
span.heimu a.external:visited,
span.heimu a.extiw,
span.heimu a.extiw:visited,
span.heimu a.mw-disambig,
span.heimu a.mw-redirect {
 transition:color 0.13s linear;
 color:#252525;
 text-shadow:none
}
span.heimu:hover,
span.heimu:active {
 color:white
}
span.heimu:hover a,
a:hover span.heimu {
 color:lightblue
}
span.heimu:hover a:visited,
a:visited:hover span.heimu {
 color:#C5CAE9
}
span.heimu:hover a.new,
a.new:hover span.heimu {
 color:#FCC
}
span.heimu a.new:hover:visited,
a.new:hover:visited span.heimu {
 color:#EF9A9A
}
span.heimu:hover a.extiw:visited,
a.extiw:visited:hover span.heimu {
 color:#D1C4E9
}
```

上述代码是从萌娘百科”借“来的 <span title="你知道的太多了" class="heimu">读书人的事，能算偷么？</span>

以 Firefox 为例：
- 按下 Ctrl+Shift+C，选择需要查看的元素。
- 在左侧查看 HTML 代码，例如 `<span title="你知道的太多了" class="heimu">虚构的故事</span>`
- 看到 `class="heimu"` 在右侧搜索 `heimu`，定位到 `load.php`。
- 复制所有相关代码。
