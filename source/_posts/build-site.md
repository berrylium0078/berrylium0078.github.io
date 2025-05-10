---
title: 建站记录
date: 2024-09-05 09:04:39
excerpt: 小破站的搭建&魔改历程
category: 博客搭建
---

## 前言

选择 redefine 主题是因为看到[学弟](http://flamire.github.io/)在用，于是跟风。

用起来感觉确实不错，页面美观，功能也够用。

然后我自己又魔改了一番，记录一下过程。

{% post_link blog-test 戳我前往功能演示页面 %}

{% folding green::克隆本博客 %}
安装依赖：
```sh
sudo pacman -S git nodejs npm
npm install hexo-cli -g
```

然后

```sh
git clone https://github.com/berrylium0078/berrylium0078.github.io
cd berrylium0078.github.io
npm install
```
{% endfolding %}

## 安装 hexo 与 redefine 主题

{参考|搬运}官方教程[^1]

[^1]: [hexo](https://hexo.io/zh-cn/)，[theme redefine](https://redefine-docs.ohevan.com/getting-started)

安装依赖：
```sh
sudo pacman -S git nodejs npm
npm install hexo-cli -g
```

假设你的博客想要安装在 `blog` 目录中，运行命令：

```sh
hexo init blog
cd blog
npm install
npm install hexo-theme-redefine@latest
wget https://raw.githubusercontent.com/EvanNotFound/hexo-theme-redefine/main/_config.yml -O _config.redefine.yml
```

之后默认工作目录为 Hexo 根目录，即上面命令新建的 `blog` 目录。

在 `_config.yml` 文件中更改主题：

```yml _config.yml
theme: redefine
```

现在已经可以 `hexo s` （server）测试博客了。

## 配置

### 更改字体

可以去 [Google Fonts](https://fonts.google.com) 上找字体。示例：

在 `_config.redefine.yml` 中修改 `global.fonts.chinese`：
```yml _config.redefine.yml
enable: true # Whether to enable custom chinese fonts
family: "Noto Sans SC" # Font family
url: "https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@100..900&family=Noto+Serif+SC:wght@200..900&display=swap" # Font URL to CSS file
```

### 部署到 github pages

配置 deployer

```sh
npm install hexo-deployer-git --save
```

github 上新建名为 `用户名.github.io` 的公开仓库，向 `_config.yml` 末尾添加：
```yml _config.yml
deploy:
  type: git
  repo: https://github.com/用户名/用户名.github.io
  branch: public
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

`_config.redefine.yml` 中修改 `info.url` 为 `https://用户名.github.io`

部署运行 `hexo generate --deploy`（缩写 `hexo g -d`）

## 魔改

### 安装 npm 包并配置

```sh
npm uninstall hexo-renderer-marked hexo-math --save
npm install hexo-renderer-markdown-it-plus markdown-it-{mathjax3,imsize,attrs,bracketed-spans,task-lists,ruby} --save
```

[你问我为什么不用 hexo-renderer-pandoc？我最开始看的教程没告诉我要本地装 pandoc，萌新的我被报错劝退，然后看到隔壁 markdown-it 有丰富的插件，就润了]{.heimu title="你知道的太多了"}

<span title="你知道的太多了" class="heimu">其实找插件可能不如让AI生成js/css代码方便？</span>

由于 KaTeX 支持范围不如 MathJax，所以选后者。

在 `_config.yml` 末尾添加：

```yml _config.yml
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
        # 其他插件也同理启用
```

### 启用其他 LaTeX 宏包

[好像只有 physics 是默认不启用的]{.heimu title="你知道的太多了"}

{% folding red::非法操作 %}
直接编辑 `node_modules/markdown-it-mathjax3/index.js`。

将 `AllPackages_js_1.AllPackages` 替换为 `AllPackages_js_1.AllPackages.concat(["physics"])`
{% endfolding %}

我简单 fork 了一下这个包，运行 `npm install https://github.com/berrylium0078/markdown-it-mathjax3` 安装 fork。

然后 `_config.yml` 对应位置改成：
```yml _config.yml
- plugin:
    name: markdown-it-mathjax3
    enable: true
    options:
        packages: ['physics']
```

### 添加自定义 CSS

作为示例，添加一个萌娘百科的黑框[^2]。
[^2]: [使用CSS实现隐藏汉字黑框](https://wangquanlikun.github.io/2023/03/18/css-moegirl)

修改 `_config.redefine.yml`：
```yml _config.redefine.yml
inject:
  enable: true
  head:
    - <link rel="stylesheet" href="/css/heimu.css">
```

然后创建文件 <a class="button" download="" href="/css/heimu.css"><i class="fa-solid fa-download"></i>`/source/css/heimu.css`</a>

接下来介绍如何向萌娘“借”来上述代码。以 Firefox 为例：
- 按下 <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>C</kbd>，鼠标选择需要查看的元素。
- 在左侧查看 HTML 代码。
- 在右侧搜索 `heimu`，定位到 `load.php`。
- 复制相关代码。

## 配置 VSCode

因为我的博客是用 VSCode 写的。

安装插件 「Math Snippets」（含有默认 LaTeX 代码片段）和 「Markdown All in One」（包含快捷键和预览功能）。

可以创建文件 `/path/to/blog/.vscode/blog.code-snippets`，用来存放博客专用代码模板。<a class="button" download="" href="/download/blog.code-snippets"><i class="fa-solid fa-download"></i>示例</a>

编辑 `settings.json`，添加如下内容[^3]。如果你不知道在哪，可以按 <kbd>Ctrl</kbd>+<kbd>,</kbd>，点右上角 `Open Settings(JSON)`。

[^3]: [在VSCode中高效编辑markdown的正确方式](https://www.thisfaner.com/p/edit-markdown-efficiently-in-vscode#vscode-本身对-markdown-的支持)
```json
"[markdown]": {
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