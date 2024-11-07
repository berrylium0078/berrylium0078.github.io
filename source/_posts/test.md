---
title: 测试页面
mathjax: true
---

## 数学公式测试

$\KaTeX\quad\LaTeX\quad\TeX$

### 自定义宏

$\newcommand{\water}{H_2O} \def\wate{H_2O}\def\liminfty#1{\lim_{ #1\to\infty}}$
$\water,\wate,\liminfty n$

```markdown
$\newcommand{\water}{H_2O} \def\wate{H_2O}\def\liminfty#1{\lim_{ #1\to\infty}}$
$\water,\wate,\liminfty n$
```

{% notel orange fa-warning "注意 bug 出没" %}
[链接](https://github.com/hexojs/hexo/issues/5301#issuecomment-1735550123)

注意用空格隔开 `{` 和 `#`，不然会触发 bug，导致文章内容被截断。
{% endnotel %}

### 换行

需要用 `\displaylines{}` 或者 `\begin{aligned}\end{aligned}` 等环境括起来。~~强迫你养成等号对齐的好习惯~~

无：
$$
1\\2
$$

displaylines：
$$
\displaylines{
    1=1\\
    2+2=4\\
}\quad 3
$$

aligned：
$$
\begin{aligned}
\frac{\partial\mathcal{D}}{\partial t} \quad & = \quad \nabla\times\mathcal{H},   & \quad \text{(Loi de Faraday)} \\[5pt]
\frac{\partial\mathcal{B}}{\partial t} \quad & = \quad -\nabla\times\mathcal{E},  & \quad \text{(Loi d'Ampere)}   \\[5pt]
\nabla\cdot\mathcal{B}                 \quad & = \quad 0,                         & \quad \text{(Loi de Gauss)}   \\[5pt]
\nabla\cdot\mathcal{D}                 \quad & = \quad 0.                         & \quad \text{(Loi de Colomb)}
\end{aligned}
$$

```markdown
无：
$$
1\\2
$$

displaylines：
$$
\displaylines{
    1=1\\
    2+2=4\\
}\quad 3
$$

aligned：
$$
\begin{aligned}
\frac{\partial\mathcal{D}}{\partial t} \quad & = \quad \nabla\times\mathcal{H},   & \quad \text{(Loi de Faraday)} \\[5pt]
\frac{\partial\mathcal{B}}{\partial t} \quad & = \quad -\nabla\times\mathcal{E},  & \quad \text{(Loi d'Ampere)}   \\[5pt]
\nabla\cdot\mathcal{B}                 \quad & = \quad 0,                         & \quad \text{(Loi de Gauss)}   \\[5pt]
\nabla\cdot\mathcal{D}                 \quad & = \quad 0.                         & \quad \text{(Loi de Colomb)}
\end{aligned}
$$
```

### 公式标签、编号

公式需要 `\tag` 和 `\label` 同时用，不然无法生成链接。

$$
(x+y)(x-y)=\\ x^2-y^2\tag{2}\label{label1}
$$
$$
(x+y)(x+y)=\\ x^2+2xy+y^2\tag{1}\label{label2}
$$

可以使用 `\tag,\label,\ref`，但是好像需要先 `\tag` 才能 `\label`？

$\ref{label1},\ref{label2}$，[label1tag2](#mjx-eqn%3Alabel1)

# Markdown 测试

[参考资料](https://markdown.com.cn)

### 换行测试

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

### 强调语法测试

~~删除线~~
**粗体**
*斜体*
***粗斜体***
==高亮==
^上^标
~下~标
++下划线++

```markdown
~~删除线~~
**粗体**
*斜体*
***粗斜体***
==高亮==
^上^标
~下~标
++下划线++
```

### 引用测试

> 第一段
> 
> 第二段
>> 嵌套！

### 列表测试

无序列表
- Alice
- Bob
- Eve

有序列表
1. Kerbin
2. Mun
3. Minmus

任务列表
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

### 链接测试

[百度，悬停有惊喜](https://www.baidu.com "百度一下，你就知道")
[主页](/)

似乎标题链接必须英文小写，空格替换为 `-`
[markdown-测试（可）](#markdown-测试)
[Markdown-测试（寄）](#Markdown-测试)


```markdown
[百度，悬停有惊喜](https://www.baidu.com "百度一下，你就知道")
[主页](/)
[markdown-测试（可）](#markdown-测试)
[Markdown-测试（寄）](#Markdown-测试)
```

图片链接会因为放大图功能而卡 bug：

[![](/images/wallhaven-wqery6-light.webp =500x)](/ "惊不惊喜")

### 图片测试

![](/images/wallhaven-wqery6-light.webp)

![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}

![](/images/wallhaven-wqery6-light.webp =100x)

```markdown

![](/images/wallhaven-wqery6-light.webp)

![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}![](/images/wallhaven-wqery6-light.webp =100x){style="display:inline"}

![](/images/wallhaven-wqery6-light.webp =100x)
```

### 表格测试

| Syntax      | Description | Test Text     |
| :---        |    :----:   |          ---: |
| Header      | Title       | Here's this   |
| Paragraph   | Text        | And more      |

### 脚注测试

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

### 分割线测试

下划线分割线
___
不需要换行

```markdown
下划线分割线
___
不需要换行
```

### emoji 测试

更多 emoji [参见](https://gist.github.com/rxaviers/7360908)

:tent: :) :(

`:tent: :) :(`

### 代码高亮测试

```cpp
#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 10; i++)
        cout << "Hello World!\n";
}
```

### 标题测试

#### 四级标题
##### 五级标题
###### 六级标题

## redefine 写作模块测试

搬运自 [官方文档](https://redefine-docs.ohevan.com/zh/modules)

### 笔记

{% notel [颜色] [可选: 自定义图标] [标题] %}
内容
支持换行
{% endnotel %}

{% notel default fa-info 信息 %}
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