---
title: 实数完备性
tags: 数学分析,笔记
mathjax: on
date: 2024-09-14 14:51:43
---

### 1. Dedekind 分割

以有理数的分划定义实数。

定理：$A\cap B=\varnothing,A\cup B=\mathbb{R},\forall a\in A, b\in B,a<b$，则要么 $A$ 有最大值，要么 $B$ 有最小值

{% folding blue::证明 %}
反证，令 $C=\bigcup_{a\in A}\{x<a|x\in \mathbb{Q}\},D=\bigcup_{b\in B}\{x>b|x\in \mathbb{Q}\}$，显然 $C<D$

那么存在 $x\in \mathbb{R}$ 使得 $C<x<D$

注意到 $\forall a\in A, \exists a'\in A,a'>a$，于是 $\exists c\in C\cap (a,a')$，那么 $x>c>a$

另一边同理，得到 $A<x<B$，与 $A\cup B=\mathbb{R}$ 矛盾。
{% endfolding %}

### 2. 确界存在定理

定义上确界 $\displaystyle\sup A=\min\{m|\forall \varepsilon>0,\exists a\in A,a>m-\varepsilon\}$，下确界 $\inf$ 同理。

有界集合必有确界。

和 1. 等价。

### 3. 单调收敛原理

单调有界数列必然收敛。

不妨设单增，容易证明收敛于其上确界。

### 4. 闭区间套定理

$[a_{n+1},b_{n+1}]\subset[a_n,b_n],\displaystyle\lim_ nb_n-a_n=0$，则存在 $\displaystyle\{c\}=\bigcap_{n=1}^\infty [a_n,b_n]$

由 3. 得 $a,b$ 均收敛，而 $a_n-b_n\to 0$，设收敛于 $c$，由极限定义易得。

### 5. 有限覆盖定理

若闭区间 $[a,b]$ 可被一簇开区间 $\{E_\lambda\}_{\lambda\in\Lambda}$ 覆盖，则存在有限个开区间使得 $\displaystyle[a,b]\subset\bigcap_{i=1}^nE_{\lambda_i}$

p.s. 这个和拓扑学有关

注意：

$(a,b)$ 不能为开区间，反例：$(a,b) = (0, 1),E_n=(1/n,1)$

$E_\lambda$ 不能为闭区间，反例：$[a,b]=[-1,1],E_0=[-1,0],E_n=[2^{-n},2^{1-n}]$

{% folding blue::证明 %}
反证，令 $m=(a+b)/2$，则 $[a,m]$ 和 $[m,b]$ 至少一个不能被有限覆盖。递归下去，得到 $\forall n\in \mathbb{N}^+$，$[a_n,b_n]$ 都不能被有限覆盖，由闭区间套定理知存在 $x\in\bigcap [a_n,b_n]$，$\exists x\in E_\lambda=(c,d)$，显然 $\exists n,b_n-a_n<\min\{x-c,d-x\},[a_n,b_n]\subset(c,d)$ 被有限覆盖，矛盾。
{% endfolding %}

### 6. 聚点原理

设去心邻域 $U_0(x,\delta)=(x-\delta,x)\cup(x,x+\delta)$

定义 $A\subset\mathbb{R}$ 的聚点 $x$ 满足 $\forall\delta>0,U_0(x,\delta)\cap A\neq \varnothing$

对 $\mathbb{R}$ 的任意有界无穷子集 $A$，存在聚点。

证明：每次往有无穷多个元素的一侧二分即可找到聚点。

### 7. Bolzano-Weierstrass 定理

有界序列必有收敛子序列。

证明：

任找一个聚点 $x$，注意到 $U(x,2^{-n})$ 有无穷多个数列中的元素，故总能按顺序取出下一项。

### 互推时间！

#### 7 推 3

根据极限定义，显然单调序列的极限等于任意子列的极限。

#### 5 推 2

构造 $A=\{a|\exists s\in S,a<s\},B=\{b|\forall s\in S, b\ge s\}$

显然 $A\cap B=\varnothing,A\cup B=\mathbb{R}$，$A$ 无最大元

假设 $B$ 无最小元，任取 $a\in A, b\in B$，构造开区间 $L_x=U(x,\delta_x)$ 覆盖 $[a,b]$，满足：

$x\in A\to L_x\subset A,x\in B\to L_x\subset B$

取一个有限覆盖，设 $a\in(l_1,r_1),r_1\in (l_2,r_2),\cdots$，则 $(l_i,r_i)\subset A$，不能盖住 $b$，矛盾。