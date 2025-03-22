---
title: 导数应用
tags: 数学分析,笔记
mathjax: 'on'
date: 2024-12-22 17:51:25
---


## 微分中值定理

设 $f(x)\in C[a,b],\forall x\in(a,b),f'(x)\exists$

### 定理1（Rolle）

若 $f(a)=f(b)$，则 $\exists \xi \in (a,b)$，使得 $f'(\xi)=0$

{% folding blue::证明 %}

常函数显然。否则不妨设 $f(x_0)=\max f(x)>f(a)$，则 $x_0\in(a, b),f'(x_0)\exists$，必然有 $f'(x_0)=0$。

{% endfolding %}

### 定理2（Lagrange）

$\exists \xi \in (a,b)$，使得 $f'(\xi)=\dfrac{f(b)-f(a)}{b-a}$

### 定理3（Cauchy）

设 $f(x),g(x)\in C[a,b],\forall x\in(a,b),f'(x),g'(x)\exists,g'(x)\neq 0$

则 $\exists \xi \in (a,b)$，使得 $\dfrac{f'(\xi)}{g'(\xi)}=\dfrac{f(b)-f(a)}{g(b)-g(a)}$

{% folding blue::证明 %}

构造 $h(x)=f(x)-\dfrac{f(b)-f(a)}{g(b)-g(a)}\left( g(x)-g(a) \right)$，则 $h(a)=h(b)=f(a)$

$\exists \xi\in(a,b),h'(\xi)=f'(\xi)-\dfrac{f(b)-f(a)}{g(b)-g(a)}g'(\xi)=0$ 

{% endfolding %}

### Darboux

不妨设 $f'(a)<f'(b)$，则 $\forall \eta \in (f'(a),f'(b)),\exists\xi\in(a,b),f'(\xi)=\eta$

{% folding blue::证明 %}
将 $g(x)=f(x)-\eta x$ 代入 Rolle 定理即可。
{% endfolding %}

## 例题

### 例1

$f'(x)=0$ 则 $f(x)=c$。

### 例2

$|f'(x)|\le M$ 则 $f(x)$ 一致连续。

### 例3

$\dfrac{x}{1+x}<\ln(1+x)\lt x,\forall x>-1,x\neq 0$ 

{% folding blue::证明 %}

$\ln(1+x)-\ln 1=\dfrac{x}{1+\xi},\xi(\xi-x)<0$，分类讨论即可。

{% endfolding %}

### 例4

设 $0<a<b$，则 $(1+a)\ln (1+a)+(1+b)\ln (1+b)<(1+a+b)\ln (1+a+b)$

{% folding blue::证明1 %}

令 $f(x)=(1+x)\ln(1+x)$，则 $f(a+b)-f(b)=af'(\xi)=a(\ln(1+\xi )+1)>a\ln(1+a)+a\ge f(a)$
{% endfolding %}

{% folding blue::证明2 %}

令 $g(x)=f(a+x)-f(x)$，则 $(f(a+b)-f(b))-(f(a)-f(0))=g(b)-g(0)=bg'(\xi)=b
\ln\dfrac{a+\xi+1}{\xi+1}>0$
{% endfolding %}

## 洛必达（L' Hospital）法则

形如 $\dfrac{0}{0},\dfrac{\infty }{\infty }$ 的函数极限转化为导数之比的极限。

### Case1

设 $f(x),g(x)$ 在 $(a,a+\delta_0)$ 上可导，且：

1. $\lim \limits_{x \to a+0} f(x)=\lim \limits_{x \to a+0} g(x)=0$
2. $g'(x)\neq 0$
3. $\lim \limits_{x \to a+0} \dfrac{f'(x)}{g'(x)}=L$（可为 $\infty$）

则 $\lim \limits_{x \to a+0} \dfrac{f(x)}{g(x)}=L$

{% folding blue::证明 %}

补充定义 $f(a)=g(a)=0$，则 $f,g\in C[a,x]$ 且在 $(a,x)$ 上可导，$\forall x\in(a,a+\delta_0)$

则 $\dfrac{f(x)}{g(x)}=\dfrac{f(x)-f(a)}{g(x)-g(a)}=\dfrac{f'(\xi)}{g'(\xi )},\xi\in(a,x)$

{% endfolding %}

### Case2

$\lim \limits_{x \to a+0} f(x)=\infty,\lim \limits_{x \to a+0} g(x)=\infty$


{% folding blue::证明 %}
感性理解一下，转化为 $\dfrac{f(t)-f(x)}{g(t)-g(x)}$，先令 $x\to a$ 再令 $t\to a$ 就证完了。

对 $\forall0<\varepsilon<L,\exists \delta_1 >0,\forall x \in (a,a+\delta _1),\left|\dfrac{f'(x)}{g'(x)}-L\right|\le \dfrac{\varepsilon }{2}$

任取 $a<x<x_1<a+\delta_1$，设 $h(x,x_1)=\dfrac{1-\dfrac{g(x_1)}{g(x)}}{1-\dfrac{f(x_1)}{f(x)}}$，则 $\dfrac{f(x)}{g(x)}=h(x,x_1)\dfrac{f'(\xi)}{g'(\xi)}$，由 $\lim \limits_{x \to a+0} h(x,x_1)=1$ 知 $\exists 0<\delta_2<x_1,\forall x<a+\delta_2,|h(x,x_1)-1|\le \dfrac{\varepsilon }{2|L|+\varepsilon}$，故

$\left| \dfrac{f(x)}{g(x)}-L \right| \le \left| L(h(x,x_1)-1)\right|+ \left| h(x,x_1)(f'(\xi)/g'(\xi)-L) \right|\le \dfrac{\varepsilon}{2|L|+\varepsilon}\left( |L|+\dfrac{\varepsilon }2 \right) +\dfrac{\varepsilon }{2}=\varepsilon$

{% endfolding %}

### Case3

$\lim \limits_{x \to +\infty} \dfrac{f(x)}{g(x)}=\lim \limits_{t \to 0+0} \dfrac{f(1/t)}{g(1/t)}=\lim \limits_{t \to 0+0} \dfrac{-\dfrac{1}{t^2}f'(1/t)}{-\dfrac{1}{t^2}g'(1/t)}=\lim \limits_{x \to +\infty} \dfrac{f'(x)}{g'(x)}$

### 例1

$\lim \limits_{x \to 0} \dfrac{e^x-1-x}{x^2}=\lim \limits_{x \to 0} \dfrac{e^x-1}{2x}=\lim \limits_{x \to 0} \dfrac{e^x}{2}=\dfrac{1}{2}$

### 例2（洛不出来）

$\lim \limits_{x \to 0} \dfrac{x^2\sin\dfrac{1}{x}}{x}=1$

$\lim \limits_{x \to 0} \dfrac{2x\sin\dfrac{1}{x}-\cos\dfrac{1}{x}}{1}$ 不存在。

### 例3

$\lim \limits_{x \to 0} \dfrac{e^{-x^2}}{x^k}=\lim \limits_{t \to \infty} \dfrac{t^k}{e^{t^2}}=\lim \limits_{t \to \infty} \dfrac{kt^{k-2}}{2e^{t^2}}=0$ 

## Taylor 公式

$\displaystyle f(x)=\sum \limits_{k=0}^{n}a_k(x-x_0)^k+o\left( (x-x_0)^n \right)$

当 $f^{(n)}(x_0)$ 存在时，有 $a_k=\dfrac{f^{(k)}(x_0)}{k!}$

#### 常见泰勒展开

$\displaystyle \mathrm{e}^x=\sum_{k\ge0}\dfrac{x^k}{k!}$ 

$\displaystyle \sin x=\sum_{k\ge 0}\dfrac{x^{2k+1}(-1)^k}{(2k+1)!}$

$\displaystyle \cos x=\sum_{k\ge 0}\dfrac{x^{2k}(-1)^k}{(2k)!}$

$\displaystyle \ln(1+x)=\sum_{k\ge 1}\dfrac{x^k(-1)^{k-1}}{k}$ 

$\displaystyle (1+x)^\alpha=\sum_{k\ge0}\dbinom{\alpha}{k}x^k,\dbinom{\alpha}{k}=\dfrac{\alpha(\alpha-1)\cdots(\alpha-k+1)}{k!}$

#### 例1

求 $\left.\left( \sin x^2 \right) ^{(102)}\right\vert_{x=0}$

{% folding blue::解 %}

$\displaystyle\sin x^2=\sum_{k\ge0}\dfrac{\left( x^2 \right)^{(2k+1)}(-1)^k}{(2k+1)!}$

取 $k=25$，则答案为 $-\dfrac{102!}{51!}$

{% endfolding %}

#### 例2

求  $\arcsin x$ 泰勒展开

{% folding blue::解 %}

$\displaystyle(\arcsin x)'=\left(1-x^2\right)^{-1/2}=\sum_{k\ge0}\dfrac{x^{2k}(2k-1)!!}{(2k)!!}$

$\displaystyle \arcsin x=\sum_{k\ge0}\dfrac{(2k-1)!!}{(2k)!!}\cdot\dfrac{x^{2k+1}}{2k+1}$

{% endfolding %}

### Lagrange 余项

$$ f^{(n+1)}\exists,f(x)=\sum \limits_{k=0}^{n}\dfrac{f^{(k)}(x_0)}{k!}(x-x_0)^k+\dfrac{f^{(n+1)}(\xi)}{(n+1)!}(x-x_0)^{n+1}$$

$\xi=x_0+\theta(x-x_0),\theta\in(0,1)$

{% folding blue::证明 %}

$$ F(t)=f(x)-\sum \limits_{k=0}^{n}\dfrac{f^{(k)}(t)}{k!}(x-t)^k,G(t)=(x-t)^{n+1} $$

则 $\dfrac{F(x_0)}{G(x_0)}=\dfrac{F(x_0)-F(x)}{G(x_0)-G(x)}=\dfrac{F'(\xi)}{G'(\xi)}=\dfrac{-\dfrac{f^{(n+1)}(\xi)}{n!}(x-\xi)^n}{-(n+1)(x-\xi)^n}=\dfrac{f^{(n+1)}(\xi)}{(n+1)!}$

{% endfolding %}