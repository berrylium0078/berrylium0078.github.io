---
title: 函数极限与连续性
tags: 数学分析,笔记
mathjax: 'on'
date: 2024-11-25 14:29:43
---


## 函数极限

定义(左/右)去心邻域 $U_0^-(x,\delta)=(x-\delta ,x),U_0^+(x,\delta)=(x,x+\delta),U_0(x,\delta )=(x-\delta ,x+\delta )\setminus \{x\}$ 

有时可简写 $\exists\delta>0,U_0(x,\delta)$ 为 $U_0(x)$

定义 $A=\displaystyle \lim_{x \to x_0} f(x)$ 满足 $\forall \varepsilon>0,\exists \delta,\forall x\in U_0(x_0,\delta),|f(x)-A|\le \varepsilon$ 

{% notel red warning %}
注意这里是去心邻域，因此函数极限和 $f(x_0)$ 没有任何关系。

$\displaystyle \lim_{x\to x_0}f(x)=y_0,\lim_{y\to y_0}g(y)=z_0$ 不能推出 $\displaystyle \lim_{x\to x_0}g(f(x))=z_0$，需要 $g(y)$ 在 $y_0$ 处连续。
{% endnotel %}

## 函数连续性

定义：$f(x)$ 在 $x_0$ 处连续，当且仅当 $\displaystyle\lim_{x\to x_0}f(x)=f(x_0)$。

同理可定义左右连续。

若 $\forall t\in(a,b),f(x)$ 在 $t$ 处连续，且 $f(x)$ 在 $a$ 处右连续，在 $b$ 处左连续，则称 $f(x)$ 在 $[a,b]$ 上连续，记作 $f(x)\in C[a, b]$

### 定理1（介值定理）

$f(x)\in C[a,b]$

不妨设 $f(a)<f(b)$，$\forall \eta \in [f(a), f(b)],\exists \xi \in[a,b],f(\xi)=\eta$

每次取 $c=\frac{a+b}{2}$，若 $f(c)\ge\eta$ 则递归 $[a,c]$ 否则递归 $[c,b]$。

得到一列区间 $f(a_n)\le\eta\le f(b_n)$，由闭区间套可得其极限 $f(\xi)=\eta$。

### 定理2（有界性）

设 $f(x)\in C[a,b]$，则 $\exists M\ge 0$ 使得 $|f(x)|\le M,\forall x\in [a,b]$

证1 反证
若否，对任意 $n>0\exists x_n\in [a,b],|f(x_n)|\ge n$，$x_n$ 有界，故存在收敛子列 $\displaystyle \lim_{k \to \infty} x_{n_k}=c\in[a,b]$，则 $\displaystyle \lim_{k \to \infty} f(x_{n_k})=f(c)$，与 $f(x_n)$ 无界矛盾。

证2 $\forall \hat{x}\in[a,b],\exists\delta(\hat{x})>0$，当 $x\in U(\hat{x},\delta (\hat{x}))\cap[a,b]$ 时 $\left| f(x)-f(\hat{x}) \right| \le 1$，$|f(x)|\le|f(\hat{x})|+1$

由 $U(\hat{x},\delta (\hat{x}))$ 构成 $[a,b]$ 的开覆盖，因而有有限子覆盖 $\left\{U(\hat{x_k},\delta (\hat{x_k}))\right\}_{k=1}^K$

令 $\displaystyle M=\max_{k=1}^K |f(\hat{x})|+1$ 则 $|f(x)|\le M,\forall x\in[a,b]$

### 定理3（最值定理）

$\displaystyle \exists x_1,x_2\in[a,b]$ 使 $\displaystyle f(x_1)=\sup_{x\in[a,b]}f(x),f(x_2)=\inf_{x\in[a,b]}f(x)$

证明与定理2证1类似，略。

### 定理4（一致连续性）

定义：称 $f(x)$ 在有界区间 $I$ 上一致连续，若 $\forall\varepsilon>0,\exists\delta>0,\forall x_1,x_2\in I,|x_1-x_2|\le \delta,|f(x_1)-f(x_2)|\le \varepsilon$

和连续性区别是这里 $\delta$ 是只关于 $\varepsilon$ 的函数，与 $x_0$ 无关。

若 $f(x)\in C[a,b]$，则 $f(x)$ 在 $[a,b]$ 上一致连续。

{% folding blue::证明1 %}

令 $L_a=U(a,\delta(a))$ 满足 $\forall x,y\in L_a,f(x)-f(y)\le \varepsilon$，取 $\delta$ 为该覆盖的一个 Lebesgue 数即可。

{% endfolding %}

{% folding blue::证明2 %}


反证，$\displaystyle\forall n\in\mathbb{N},\exists u_n,v_n\in[a,b],\left| u_n-v_n \right|  < \dfrac1n,\left| f(u_n)-f(v_n) \right| >\varepsilon$。

$u_n$ 存在收敛子列 $u_{n_k}$，$v_{n_k}$ 存在收敛子列，故存在子列 $n_t$ 使得 $u_{n_t},v_{n_t}$ 均收敛，与 $f(x)$ 连续矛盾。

{% endfolding %}

#### 推论

若开区间（可无界）端点处对应单侧极限存在，则 $f(x)$ 在开区间上一致连续。

证明思路是，对每个 $\varepsilon>0$，先取两端点处小邻域满足极差 $<\varepsilon$，再取一个闭区间和小邻域一起覆盖整个开区间，然后据此构造一个足够小的 $\delta$。

可以不严谨地认为 $[M,+\infty)$ 为 $\infty$ 的左邻域。

#### 一个显然事实

$f(x)$ 一致连续则存在 $k,b$ 使得 $|f(x)|\le k|x|+b$

### 例1

$f(x)=\sqrt[]{x}$ 在 $[0,+\infty)$ 上一致连续。

证1：$\sqrt{x_2}-\sqrt{x_1}\le\sqrt{x_2-x_1}$，取 $\delta=\varepsilon^2$。

证2：$\sqrt{x_2}-\sqrt{x_1}=\dfrac{x_2-x_1}{\sqrt{x_1}+\sqrt{x_2}}\le\dfrac{x_2-x_1}{2}$（$x_1,x_2\ge 1$），
可得在 $[1,\infty)$ 上一致连续。又因为 $f(x)\in C[0,1]$ 可得在 $[0,1]$ 上一致连续。

### 例2（幂平均）

$\displaystyle M_p(a_1,a_2,\dots,a_n)=\left(\frac{1}{n}\sum_{k=1}^n a_k^p \right)^{1/p}$

求 $M_{0+0}$。

$$
\begin{aligned}
\ln\lim_{p\to 0+0}M_p&=\lim_{p\to 0+0}\dfrac{1}{p}\ln\left(\dfrac1n\sum_{k=1}^na_k^p\right)\\
&=\lim_{p\to 0+0}\dfrac{1}{pn}\sum_{k=1}^n\left( a_k^p-1 \right)\\
&=\dfrac1n\sum_{k=1}^n\ln a_k
\end{aligned}
$$

故 $M_{0+0}=\sqrt[n]{a_1a_2\cdots a_n}$

特别地，$M_1$ 为算数平均值，$M_2$ 为方均根，$M_{-1}$ 为调和平均值，$M_{+\infty}=\max$，$M_{-\infty}=\min$。

### 等价无穷小

$\displaystyle \lim_{x \to 0} \dfrac{a^x-1}{x}=\lim_{t \to 0} \dfrac1{\dfrac{1}{t}\log_{a}(1+t)}=\lim_{t \to 0}\dfrac1{\log_a(1+t)^{1/t}}=\ln a$ 

$\displaystyle \lim_{x \to 0} \frac{(1+x)^\mu -1}{x}= \lim_{x \to 0}\dfrac{\exp(\mu\ln(1+x))-1}x=\lim_{x \to 0}\dfrac{\mu\ln(1+x)}{x}=\mu$ 

$\lim \limits_{x \to 0} \dfrac{\sin x}{x}=1$ 

$\lim \limits_{x \to 0} \dfrac{1-\cos x}{x^2}=\dfrac{1}{2}$

无穷小量之间可以互相代换，其本质为乘积的极限。

Tips：更推荐使用「泰勒展开·皮亚诺余项」