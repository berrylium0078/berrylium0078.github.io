---
title: 博客测试页面
date: 2024-11-04 17:01:34
categories: 博客搭建
excerpt: 我是测试界面！
---

想获得同款博客？[*戳我*](/2024/09/05/build-site/)

## 字体测试

关复门liLI1|oO0() `关复门liLI1|oO0()<=>`

## 数学公式测试

$\KaTeX\quad\LaTeX\quad\TeX$

$$
\begin{cases}
\frac{\partial\mathcal{D}}{\partial t} \quad & = \quad \nabla\times\mathcal{H},   & \quad \text{(Loi de Faraday)} \\[5pt]
\frac{\partial\mathcal{B}}{\partial t} \quad & = \quad -\nabla\times\mathcal{E},  & \quad \text{(Loi d'Ampere)}   \\[5pt]
\nabla\cdot\mathcal{B}                 \quad & = \quad 0,                         & \quad \text{(Loi de Gauss)}   \\[5pt]
\nabla\cdot\mathcal{D}                 \quad & = \quad 0.                         & \quad \text{(Loi de Colomb)}
\end{cases}
$$

### physics 宏包测试

$\eval{\sin x}_0^\pi$

### 自定义宏

$\newcommand{\water}{H_2O} \def\wate{H_2O}\def\liminfty#1{\lim_{ #1\to\infty}}$
$\water,\wate,\liminfty n$

```markdown
$\newcommand{\water}{H_2O} \def\wate{H_2O}\def\liminfty#1{\lim_{ #1\to\infty}}$
$\water,\wate,\liminfty n$
```

### 公式标签、编号

$$
1\tag{a}\label{l1}
$$
$$
2\tag{b}\label{l2}
$$

$\ref{l1},\ref{l2}$

```md
$$
1\tag{a}\label{label1}
$$
$$
2\tag{b}\label{label2}
$$

$\ref{label1},\ref{label2}$
```

### 压力测试

四次方程求根公式。[*链接*](/2025/03/28/stress-test)

## Markdown 测试

### 换行

此行行末有两个空格。  
此行行末有 HTML tag。<br>
此行行末啥也没有。
此行中间插入了 HTML tag，<br> 这是 tag 后的内容。

```markdown
此行行末有两个空格。  
此行行末有 HTML tag。<br>
此行行末啥也没有。
此行中间插入了 HTML tag，<br> 这是 tag 后的内容。
```

### 强调语法

~~删除线~~**粗体***斜体****粗斜体***==高亮==^上^标~下~标++下划线++

`~~删除线~~**粗体***斜体****粗斜体***==高亮==^上^标~下~标++下划线++`

### 引用

> 第一段
> 
> 第二段
> 
> > 嵌套！

### 列表

- Alice
  - Bob
- Eve
  1. Kerbin
     - [x] Write the press release
  2. Mun
     - [ ] Update the website
     - [ ] Contact the media
  3. Minmus

### 链接

[百度，悬停有惊喜](https://www.baidu.com "百度一下，你就知道")
[主页](/)
[markdown-测试（可）](#markdown-测试)
[Markdown-测试（寄）](#Markdown-测试)


```markdown
[百度，悬停有惊喜](https://www.baidu.com "百度一下，你就知道")
[主页](/)
[markdown-测试（可）](#markdown-测试)
[Markdown-测试（寄）](#Markdown-测试)
```

### 图片

![aa](/images/wallhaven-wqery6-light.webp)

![bb](/images/wallhaven-wqery6-light.webp =100x)

```markdown
![aa](/images/wallhaven-wqery6-light.webp)

![bb](/images/wallhaven-wqery6-light.webp =100x)
```

### 表格

| Syntax      | Description | Test Text     |
| :---        |    :----:   |          ---: |
| Header      | Title       | Here's this   |
| Paragraph   | Text        | And more      |

### 脚注

脚注[^1]

脚注[^1]

脚注[^2]

[^1]: 这是一个脚注
[^2]: 这是第二个脚注

```markdown
脚注[^1]

脚注[^1]

脚注[^2]

[^1]: 这是一个脚注
[^2]: 这是第二个脚注
```

### 分割线
---
### emoji

[为什么不用输入法？]{.heimu title="你知道的太多了"}

[emoji cheat list](https://gist.github.com/rxaviers/7360908)

:tent: :) :( `:tent: :) :(`

### 代码块


```cpp hello.cpp /2024/11/04/blog-test 戳我
#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 10; i++)
        cout << "Hello World!\n";
}
```

```markdown
```cpp hello.cpp /2024/11/04/blog-test 戳我
```

### 标题测试

#### 四级标题
##### 五级标题
###### 六级标题

## markdown-it-attrs

和附属 `bracketed-spans` 搭配使用，可以规避部分 html。[搁这搁这呢]{.heimu title="你知道的太多了"}

### 萌娘黑幕

[看到这行字的是猪]{.heimu title="开玩笑的😜"}

```markdown
[■■■■■■■■]{.heimu title="😜"}
```
```html
<span title="😜" class="heimu">■■■■■■■■</span>
```

### 文字居中

#### 静夜思 {style="text-align:center"}
**(唐)李白**
床前明月光，疑是地上霜。
举头望明月，低头思故乡。
{style="text-align:center"}

```markdown
#### 静夜思 {style="text-align:center"}
**(唐)李白**
床前明月光，疑是地上霜。
举头望明月，低头思故乡。
{style="text-align:center"}
```

### 文字颜色

[R]{style="color:red"}[G]{style="color:green"}[B]{style="color:blue"}
[tairitsu]{style="color:#1f1e33"}

```markdown
[R]{style="color:red"}[G]{style="color:green"}[B]{style="color:blue"}
[tairitsu]{style="color:#1f1e33"}
```

### 内联图片

![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}

`![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}`

### 特殊链接

[新标签页打开主页](/){target=_blank rel=noopener}

[下载 `/source/css/heimu.css`](/css/heimu.css){download}

```markdown
[新标签页打开主页](/){target=_blank rel=noopener}
[下载 `/source/css/heimu.css`](/css/heimu.css){download}
```

## hexo 标签测试

好难用，感觉不如 html。

### 代码块

{% codeblock _.compact http://underscorejs.org/#compact Underscore.js %}
_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
{% endcodeblock %}

### iframe

{% iframe https://redefine.ohevan.com/ 900 540 %}

`{% iframe https://redefine.ohevan.com/ 900 540 %}`

### 包含帖子

{% post_link blog-test insert title here %}

`{% post_path blog-test %}`
`{% post_link blog-test insert title here %}`

## redefine 写作模块测试

搬运自 [官方文档](https://redefine-docs.ohevan.com/zh/modules)

### 笔记

{% notel [颜色] [可选: 自定义图标] [标题] %}
内容
支持换行
{% endnotel %}

{% notel default "fa-regular fa-circle-info" 信息 %}
换行测试
换行测试
换行测试
{% endnotel %}
 
{% notel blue 提示 %}
换行测试
换行测试
换行测试
{% endnotel %}
 
{% notel red 自定义标题 %}
换行测试
换行测试
换行测试
{% endnotel %}

### 按钮

Buttons with no arguments {% btn Button:: / %} fits well in the paragraph.
 
regular button fits better when outside of the paragraph
 
{% btn regular::Example::https://www.ohevan.com::fa-solid fa-play-circle %}
 
{% btn regular::Example::https://www.ohevan.com::fa-solid fa-play-circle %}

please use large with center:
 
{% btn center large::Get started::https://redefine-docs.ohevan.com::fa-solid fa-download %}

### 折叠

{% folding blue::Folding 测试： 点击查看更多 %}
 
啊啊啊啊啊
 
{% note danger  %}
danger 提示块标签
{% endnote %}
 
{% note tip  %}
tip 提示块标签
{% endnote %}
 
{% endfolding %}

可用颜色：`yellow, blue, green, red, orange, pink, cyan, white, black, gray`

### 分栏

{% tabs First unique name %}
<!-- tab First Tab-->
**This is Tab 1.**
<!-- endtab -->
 
<!-- tab Second Tab-->
**This is Tab 2.**
 
This is Tab 2.
<!-- endtab -->
 
<!-- tab Third Tab-->
**This is Tab 3.**
 
This is Tab 3.
 
This is Tab 3.
<!-- endtab -->
{% endtabs %}

## 已知问题

- 萌娘百科黑幕不能放 emoji，因为是通过将文字前景色改黑实现的。
- `{` 和 `#` 连在一起将导致文章内容截断，注意用空格隔开，[链接](https://github.com/hexojs/hexo/issues/5301#issuecomment-1735550123)。
- 数学公式换行需要使用 `\displaylines{}` 或者 `aligned` 等环境。
- 图片链接点击后会因为放大功能触发 bug，页面将卡死，需要刷新。（改用 btns？）