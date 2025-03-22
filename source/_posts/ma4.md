---
title: 导数
tags: 数学分析,笔记
mathjax: 'on'
date: 2024-12-18 08:47:37
---


### 定义

若 $\displaystyle \lim_{\Delta x \to 0}\dfrac{f(x+\Delta x)-f(x)}{\Delta x}$ 存在，记为 $f'(x)$ 或 $\dfrac{\mathrm{d}}{\mathrm{d}x}f(x)$

### 运算法则

#### 四则运算

$(f\pm g)'=f'\pm g'$

$(fg)'=f'g+fg'$

$\left( \dfrac{f}{g} \right)' =\dfrac{f'g-g'f}{g^2}$

#### 函数复合

$(g(f(x)))'=g'(f(x))f'(x)$

证明：设 $y=f(x)$

令 $h(\Delta y)=\dfrac{g(y+\Delta y)-g(y)}{\Delta y},h(0)=g'(y)

则 (g(y+\Delta y)-g(y))=h(\Delta y)\Delta y$

则 $\dfrac{g(f(x+\Delta x))-g(f(x))}{\Delta x}$

#### 反函数

$g=f^{-1},g'(y)=1/f'(x)=1/f'(g(y))$

### 常见导数

$(x^a)'=ax^{a-1}$

$(\ln x)'=1/x$

$(e^x)'=e^x,(a^x)'=a^x\ln a$

$(\sin x)'=\cos x,(\cos x)'=-\sin x,(\tan x)'=\dfrac{1}{\cos^2x}$

$(\arcsin x)'=\dfrac{1}{\sqrt{1-x^2}},(\arccos x)'=-\dfrac{1}{\sqrt{1-x^2}},(\arctan x)'=\dfrac1{1+x^2}$

$(\sin x)^{(n)}=\sin \left(x+n\dfrac\pi2\right)$

### 隐函数求导

$F(x, y)=0(*),\forall x\in(a, b),\exists!y\ s.t. (*)$，$y=f(x)$ 不能被初等函数表示。

#### 例1 Kepler 方程

$y-\varepsilon\sin y=x$

$y'(x)-\varepsilon\cos y\cdot y'(x)=1$

$y'(x)=\dfrac1{1-\varepsilon\cos y}$

#### 例2 微分方程

$$
\begin{aligned}
y'&= y+x^2\\
(e^{-x}y(x))'&=e^{-x}(y'-y)=e^{-x}x^2\\
e^{-x}y(x)&=\int e^{-x}x^2\mathrm{d}x+C\\
&=-(x^2+2x+2)e^{-x}+C
\end{aligned}
$$


### 曲线参数表示

$$
\begin{cases}
x=x(t)\\
y=y(t)   
\end{cases}\quad t\in[\alpha,\beta]
$$

$$
y'(x)=y'(t)t'(x)=\dfrac{y'(t)}{x'(t)}
$$

圆

$$
x^2+y^2=R^2\quad
\begin{cases}
x=R\cos\theta\\
y=R\sin\theta
\end{cases}\quad t\in[0,2\pi]
$$

椭圆

$$
\dfrac{x^2}{a^2}+\dfrac{y^2}{b^2}=1\quad
\begin{cases}
x=a\cos\theta\\
y=b\sin\theta
\end{cases}\quad t\in[0,2\pi]
$$

旋轮线

$$
\begin{cases}
x=tR-R\sin t\\
y=R(1-\cos t)
\end{cases}\quad t\in[0,2\pi]
$$

### 极坐标

$$
\begin{cases}
x=r(\theta)\cos\theta\\
y=r(\theta)\sin\theta
\end{cases} 
$$

问题：过一点的切线和与原点的连线夹角？

根据物理直觉，夹角的正切是 $\dfrac{r\mathrm{d}\theta}{\mathrm{d}r}$

引入复数，$(r(\theta)e^{i \theta})'=(ir+r')e^{i \theta}$，故 $\tan \phi =\dfrac{r}{r'}$

### 微分

**定义** 称 $f(x)$ 在 $x_0$ 可微，若 $\exists A\in\mathbb{R}$ 使 $f(x_0+\Delta x)-f(x_0)=A\Delta x+o(\Delta x)\iff A=f'(x_0)\exists$

**定义** $\Delta x\mapsto A\Delta x$ 称为 $f(x)$ 在 $x_0$ 的微分映射

**定义** $\mathrm{d} y=f'(x_0)\mathrm{d}x$ 称为 $f(x)$ 在 $x_0$ 的微分