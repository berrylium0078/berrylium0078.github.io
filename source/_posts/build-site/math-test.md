---
title: Test Page for Math Fomulas
date: 2025-07-20 17:58:18
mathjax: true
tags:
categories: "build site"
description: "This blog uses MathJax v3.2 as math display engine. This page tests macro definition, equation labeling, and the physics extension pack"
---

## Math Engine

$\KaTeX\quad\LaTeX\quad\TeX$

## Showcase

$$
\begin{cases}
\frac{\partial\mathcal{D}}{\partial t} \quad & = \quad \nabla\times\mathcal{H},   & \quad \text{(Loi de Faraday)} \\[5pt]
\frac{\partial\mathcal{B}}{\partial t} \quad & = \quad -\nabla\times\mathcal{E},  & \quad \text{(Loi d'Ampere)}   \\[5pt]
\nabla\cdot\mathcal{B}                 \quad & = \quad 0,                         & \quad \text{(Loi de Gauss)}   \\[5pt]
\nabla\cdot\mathcal{D}                 \quad & = \quad 0.                         & \quad \text{(Loi de Colomb)}
\end{cases}
$$

## Line Breaks

They must appear inside certain environments.

$1\\2$
`$1\\2$`

$\displaylines{1\\2}$
`$\displaylines{1\\2}$`

$\begin{aligned} 1\\2 \end{aligned}$
`$\begin{aligned} 1\\2 \end{aligned}$`

## Defining Macros

{% note orange fa-warning %}
When the characters `{` and `#` appear together, all following content will be discarded due to a [Hexo bug](https://github.com/hexojs/hexo/issues/5301#issuecomment-1735550123)
{% endnote %}

$\newcommand{\water}{H_2O} \def\wate{H_2O}\def\liminfty#1{\lim_{ #1\to\infty}}$
$\water,\wate,\liminfty n$

```markdown
$\newcommand{\water}{H_2O} \def\wate{H_2O}\def\liminfty#1{\lim_{ #1\to\infty}}$
$\water,\wate,\liminfty n$
```

### Equation Labeling

Configuration: `mathjax.tags=ams`

$\ref{a},\ref{b}$
$\begin{equation}1\end{equation}$
$\begin{equation}1\label{a}\end{equation}$
$$2\tag{b}\label{b}$$


```md
$\ref{a},\ref{c}$
$\begin{equation}1\end{equation}$
$\begin{equation}1\label{a}\end{equation}$
$$2\tag{b}\label{b}$$
```

$\ref{a},\ref{b}$

{% note green fa-lightbulb flat %}
The hyper link for labeled equation is `{postURL}#mjx-eqn%3A{label}` --- where spaces inside *label* are replaced with underscores --- according to the [MathJax3.2 Documentation](https://docs.mathjax.org/en/v3.2-latest/input/tex/extensions/tagformat.html)
{% endnote %}

## the *physics* pack

`\eval`:

$$\int_0^1x\dd{x}=\eval{\dfrac{x^2}{2}}_0^1=\dfrac{1}{2}$$

    $$\int_0^1x\dd{x}=\eval{\dfrac{x^2}{2}}_0^1=\dfrac{1}{2}$$
