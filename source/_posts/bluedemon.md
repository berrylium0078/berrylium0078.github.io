---
title: BA 抽卡胜率
date: 2025-04-01 22:41:11
tags: Blue Archive
---

你有 $n$ 次招募机会，一共要抽中 $m$ 个限定角色（单发概率 $p=0.7\%$，设 $q=1-p$），一井为 $t=200$ 发，求成功几率。

假设九蓝一金不影响出彩概率，那么最优策略一定是每次在未获得的限定成员处招募一次，直到能井出所有剩余成员。

---

考虑所有成功情况，枚举 $k$ 个角色是抽出来的，$r=m-k$ 个靠吃井，设总共招募 $x$ 次，则有 $x\ge tr,x-1<t(r+1),x\le mt$。

1. 非酋 $k=0,P_0=q^{mt}$
2. $k>0,P_k=\displaystyle\sum_{i=tr}^{tr+t-1}p^{k}q^{i-k}\dbinom{i-1}{k-1}=p^k\sum_{j=0}^{t-1}q^j\dbinom{k+j-1}{k-1}=[X^{t-1}]\cfrac{p^k}{(1-qX)^k}\cdot\frac{1}{1-X}$

所求为 $\displaystyle P=P_0+\sum_{k=1}^m P_k=P_0+[X^{t-1}]\frac{1}{1-X}\sum_{k=1}^m \left( \cfrac{p}{1-qX} \right)^k=P_0+[X^{t-1}]\frac{1}{1-X}\cfrac{p}{1-qX}\cfrac{\left( \cfrac{p}{1-qX} \right)^m-1}{\cfrac{p}{1-qX}-1}=q^{mt}-\cfrac pq[X^{t-1}]\cfrac{\left( \cfrac{p}{1-qX} \right)^m-1}{(1-X)^2}=q^{mt}-\cfrac pq\sum_{i=0}^{t-1}(t-i)\left[[X^i]\left( \cfrac{p}{1-qX} \right)^m-[i=0]\right]=q^{mt}-\cfrac pq\sum_{i=0}^{t-1}(t-i)\left[p^mq^i\dbinom{m-1+i}{m-1}-[i=0]\right]$