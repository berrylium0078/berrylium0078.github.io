---
title: 数列极限
tags: 数学分析,笔记
mathjax: 'on'
date: 2024-10-03 21:21:12
---


## 极限定义

$$
a=\lim\limits_{n \to \infty}a_n\iff\forall\varepsilon>0,\exists N,\forall n>N,|a_n-a|<\varepsilon
$$

极限若存在则唯一。反证，取 $\varepsilon=(a_1+a_2)/2$ 即可导出矛盾。

### 例题

#### 例1

$$
a\in(0,1),k\in\mathbb{N},\lim_{n\to \infty} n^ka^n=0
$$

{% folding blue::证明 %}
任取 $\varepsilon>0$，令 $q=\dfrac1a-1$，当 $n>2k$ 时有：

$$
\begin{aligned}
\dfrac{n^k}{(1+q)^n}&\le \dfrac{n^k}{q^{k+1}\binom{n}{k+1}}\\
&=\dfrac{(k+1)!}{q^{k+1}}\dfrac{n^k}{(n-1)\cdots(n-k)}\dfrac1n\\
&\le \dfrac{(k+1)!2^k}{q^{k+1}}\cdot\dfrac1N
\end{aligned}
$$

取 $N=\max\left(2k,\left[\dfrac{(k+1)!2^k}{q^{k+1}\varepsilon}\right]+1\right)$ 即可。
{% endfolding %}

#### 例2

$$
\lim_{n\to \infty} \dfrac{a^n}{n!}=0
$$

{% folding blue::证明 %}
取 $m=[a]+1>a$，则当 $n>m$ 时有 $\dfrac{a^n}{n!}\le\dfrac{a^m}{m!}\cdot\dfrac{a}{n}$

取 $N=\left\lceil\dfrac{a^{m+1}}{m!\varepsilon}\right\rceil$ 即可。
{% endfolding %}

#### 例3

$$
\lim_{n\to \infty} \sqrt[n]{n}=1
$$

{% folding blue::证明 %}
显然 $\sqrt[n]{n}\ge \sqrt[n]1=1$

那么

$$ 
\begin{aligned}
n=(1+\sqrt[n]{n}-1)^n&>\dfrac{n(n-1)}2(\sqrt[n]{n}-1)^2\\
\dfrac2{n-1}&>(\sqrt[n]{n}-1)^2
\end{aligned} 
$$

$\forall\varepsilon>0$ 取 $n=2/\varepsilon^2$，则 $0<\sqrt[n]{n}-1<\sqrt{\dfrac2{n-1}}=\varepsilon$。

{% endfolding %}

## 性质

### 收敛数列有界

$\le N$ 和 $>N$ 分类讨论即可。

### 保序

显然，若 $\exist N,\forall n>N,a_n\le b_n$，则 $a\le b$

注意 $a_n<b_n$ 不能推出 $a<b$。

推论：夹逼原理（Sandwich/Squeeze Theorem）

### 四则运算

加减是显然的。

{% folding blue::乘法 %}
$|a_nb_n-ab|\le |a_n-a|\cdot|b_n|+|b_n-b|\cdot |a|$，设 $|b_n|\le M$，令两项均小于 $\dfrac\varepsilon2$ 即可。
{% endfolding %}

{% folding blue::除法 %}
$|1/a_n-1/a| = \dfrac{|a-a_n|}{|a|\cdot|a_n|}$，$\exist N,\forall n>N,|a_n-a|<\dfrac{|a|}{2}$，则 $|a_n| >\dfrac{ |a| }2$，只需令 $|a-a_n|<\dfrac{a^2\varepsilon}{2}$
{% endfolding %}

## 判据

### 单调有界收敛

#### 例1

$x_{n+1}=\dfrac12\left(x_n+\dfrac A{x_n}\right)$，求 $\displaystyle\lim\limits_{n\to\infty} x_n$

{% folding green::解 %}
$\forall n\ge 2,x_n\ge \sqrt A,x_{n+1}-x_n=\dfrac12\left(\dfrac A{x_n}-x_n\right)<0$，故极限存在，设为 $x$，那么 $x=\dfrac12\left(x+\dfrac Ax\right)$，解得 $x=\sqrt A$。
{% endfolding %}

#### 例2：欧拉数 $\mathrm{e}$

定义 $\mathrm{e}=\displaystyle\lim\limits_{n\to\infty}{\left(1+\dfrac1n\right)}^n$，证明极限存在。

{% folding blue::证明 %}
令 $x_n={\left(1+\dfrac1n\right)}^n,y_n={\left(1+\dfrac1n\right)}^{n+1}$，显然 $y_n>x_n$，容易验证 $x_n$ 单增，$y_n$ 单减，因此 $x_n,y_n$ 收敛于相同的数，记为 $\mathrm{e}$，且 $x_n<\mathrm{e}<y_n$。

p.s. $\dfrac{x_n}{x_{n-1}}=\dfrac{n+1}n{\left(1-\dfrac{1}{n^2}\right)}^{n-1}$，补一项把次数变成 $n$ 比较好算。
{% endfolding %}

#### 例3：欧拉常数 $\gamma$

上式两边取 $\ln$，得 $\dfrac1{n+1}<\ln\dfrac{n+1}{n}<\dfrac1n$，于是 $\displaystyle\ln(n+1)<\sum_{i=1}^n\dfrac 1i<1+\ln n$

考虑 $z_n=H_n-\ln n$，显然 $z_n>0$，且 $z_{n+1}-z_n=\dfrac1{n+1}-\ln\dfrac{n+1}n<0$，$z_n$ 极限存在，为欧拉常数 $\gamma\approx 0.577216\cdots$

#### 例4：欧拉数的另一种表示

$\displaystyle\lim\limits_{n\to\infty}\sum_{k=0}^n \dfrac1{k!}=\mathrm{e}$

{% folding blue::证明 %}
固定 $n$，任取 $m>n$，注意到

$$
\mathrm{e}=\lim\limits_{m\to\infty}y_m\ge\lim\limits_{m\to\infty}\sum_{k=0}^n \dfrac{m^{\underline k}}{m^kk!}\ge\sum_{k=0}^n\dfrac 1{k!}\lim\limits_{m\to\infty}{\left(1-\dfrac km\right)}^k=\sum_{k=0}^n\dfrac1{k!}=s_n
$$

因此 $s_n$ 单增有上界，极限存在。

显然 $\displaystyle x_n=\sum_{k=0}^n\dfrac{n^{\underline{k}}}{n^kk!}\le \sum_{k=0}^n\dfrac1{k!}=s_n$，故只能 $\displaystyle\lim\limits_{n\to\infty} s_n=\mathrm{e}$
{% endfolding %}

### 柯西收敛准则

$x_n$ 收敛当且仅当 $\forall\varepsilon>0,\exist N>0,\forall n,m>N,|x_n-x_m|<\varepsilon$。

#### 例1

证明 $\displaystyle s_n=\sum_{i=1}^n\dfrac{\sin i}{i^2}$ 收敛

{% folding blue::证明 %}
$\displaystyle\forall n<m,|s_m-s_n|\le\sum_{i=n+1}^m\left|\dfrac1{i(i-1)}\right|\le\dfrac1n$，取 $N=\left\lceil \dfrac1\varepsilon \right\rceil$ 即可。
{% endfolding %}

#### 例2

证明极限 $\displaystyle \lim \limits_{n \to \infty}\sum_{k=0}^n\dfrac{t^k}{k!}$ 存在

注意到 $k!>k(k-1)\cdots(k/2)>\sqrt{\dfrac k2}^k$，……

### 上下极限相等

## 上下极限定义

$\displaystyle \varlimsup \limits_{n \to \infty} a_n=\lim_{n\to\infty}\sup_{m\ge n} a_m,\varliminf_{n\to\infty} a_n=\lim_{n\to\infty}\inf_{m\ge n} a_m$

感性理解这两个构成数列趋于无穷时的震荡区间。

## 性质

### 有界数列有上下极限

显然 $\sup\limits_{i\ge n} a_i$ 单调减且有界。

### 四则运算

$$
\varliminf\limits_{n \to \infty} x_n+\varliminf\limits_{n \to \infty} y_n\le \varliminf\limits_{n \to \infty} (x_n+y_n)\le \varliminf\limits_{n \to \infty} x_n+\varlimsup\limits_{n \to \infty} y_n\le \varlimsup\limits_{n \to \infty} (x_n+y_n)\le \varlimsup\limits_{n \to \infty} x_n+\varlimsup\limits_{n \to \infty} y_n
$$

乘除当都是正数时同理。

### 例题

$y_n=kx_n+x_{n+1},k\in(0,1)$，已知 $\left\{ y_n \right\}$ 收敛，证明 $\left\{ x_n \right\}$ 收敛。

{% folding blue::证明 %}

先证 $x_n$ 有界，简单数列练习题。

那么 $\varliminf \limits_{n \to \infty} y_n-k\varlimsup \limits_{n \to \infty}x_n\le \varliminf \limits_{n \to \infty}x_n$，$\varlimsup \limits_{n \to \infty} y_n-k\varliminf \limits_{n \to \infty}x_n\ge \varlimsup \limits_{n \to \infty}x_n$

作差得 $0=\varlimsup \limits_{n \to \infty} y_n-\varliminf \limits_{n \to \infty} y_n\ge(k-1)\left( \varlimsup \limits_{n \to \infty} x_n-\varliminf \limits_{n \to \infty} x_n \right)\ge 0$

{% endfolding %}