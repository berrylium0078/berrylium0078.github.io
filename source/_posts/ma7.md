### 隐函数求导

$F(x, y)=0(*),\forall x\in(a, b),\exists!y\ s.t. (*)$，$y=f(x)$ 不能被初等函数表示。

$y-\varepsilon\sin y=x$ Kepler 方程

$y'(x)-\varepsilon\cos y\cdot y'(x)=1$

$y'(x)=\dfrac1{1-\varepsilon\cos y}$

#### ?

$$
\begin{aligned}
y'&= y+x^2\\
e^{-x}(y'-y)&=e^{-x}x^2\\
(e^{-x}y(x))'&=e^{-x}x^2\\
\end{aligned}
$$

$$
\begin{aligned}
\int e^{-x}x^2\mathrm{d}x&=-\int x^2\mathrm{d}(e^{-x})\\
&=-x^2e^{-x}+\int e^{-x}\mathrm{d}(x^2)\\
&=-x^2e^{-x}-2\int x\mathrm{d}(e^{-x})\\
&=-x^2e^{-x}-2xe^{-x}+2\int e^{-x}\mathrm{d}x\\
&=-(x^2+2x+2)e^{-x}+C
\end{aligned}
$$

故 $y(x)=-(x^2+2x+2)+C\cdot e^x$

#### ??

$y'=y^2+x^2$ 刘维尔定理？不能表达为初等函数？

$\displaystyle\int e^{x^2}\mathrm{d} x$

$\displaystyle \int_{}^{}e^{x^2}\mathrm{d} x$ 

### 曲线参数表示

$$
\begin{cases}
x=x(t)\\
y=y(t)   
\end{cases}\quad t\in[\alpha,\beta]
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

$y'(x)=y'(t)t'(x)=\dfrac{y'(t)}{x'(t)}$

### 极坐标

$$
\begin{cases}
x=r(\theta)\cos\theta\\
y=r(\theta)\sin\theta
\end{cases} 
$$

$$
\begin{aligned}
k&=\dfrac{r'\sin\theta+r\cos\theta}{r'\cos\theta-r\sin\theta}\\
\dfrac{r}{r'}&=\dfrac{k\cos\theta-\sin\theta}{\cos\theta+k\sin\theta}=\dfrac{k-\tan\theta}{1+k\tan\theta}

\end{aligned} 
$$

### 微分

*定义* 称 $f(x)$ 在 $x_0$ 可微

若 $\exists A\in\R,$ 使 $f(x_0+\Delta x)-f(x_0)=A\Delta x+o(\Delta x)$

$\iff \exists f'(x_0),A=f'(x_0)$


*定义* $\Delta x\mapsto A\Delta x$ 称为 $f(x)$ 在 $x_0$ 的微分映射

*定义* $\mathrm{d} y=f'(x_0)\mathrm{d}x$ 称为 $f(x)$ 在 $x_0$ 的微分

多元函数微分和微分映射不同？

$(\sin x)^{(n)}=\sin \left(x+n\dfrac\pi2\right)$