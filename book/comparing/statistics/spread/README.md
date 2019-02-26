### Spread: Standard Deviation vs. Quantiles

The average gives us a good impression about the central value or location of a distribution.
It does not tell us much about the range of the data.
We do not know whether the data we have measured is very similar to the median or whether it may differ very much from the mean.
For this, we can compute a measure of [dispersion](http://en.wikipedia.org/wiki/Statistical_dispersion), i.e., a value that tells us whether the observations are stretched and spread far or squeezed tight around the center.

\text.block{definition}{variance}{The [variance](http://en.wikipedia.org/wiki/Variance) is the expectation of the squared deviation of a random variable from its mean. The variance&nbsp;$\variance(A)$ of a data sample&nbsp;$A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ with $n$&nbsp;observations can be estimated as:}

$$ \variance(A) = \frac{1}{n-1} \sum_{i=0}^{n-1} \left(\arrayIndex{a}{i} - \mean(A)\right)^2 $$

\text.block{definition}{standardDeviation}{The statistical estimate&nbsp;$\stddev(A)$ of the [standard deviation](http://en.wikipedia.org/wiki/Standard_deviation) of a data sample&nbsp;$A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1}$ with $n$&nbsp;observations is the square root of the estimated variance&nbsp;$\variance(A)$.}

$$ \stddev(A) = \sqrt{\variance(A)} $$

Bigger standard deviations mean that the data tends to be spread farther from the mean.
Smaller standard deviations mean that the data tends to be similar to the mean.

Small standard deviations of the result quality and runtimes are good features of optimization algorithms, as they indicate reliable performance.
A big standard deviation of the result quality may be exploited by restarting the algorithm, if the algorithms converge early enough so sufficient computational budget is left over to run them a couple of times.
We made use of this in [@sec:stochasticHillClimbingWithRestarts] when developing the hill climber with restarts.
Big standard deviations of the result quality together with long runtimes are bad, as they mean that the algorithms perform unreliable.

A problem with using standard deviations as measure of dispersion becomes visible when we notice that they are derived from and thus depend on the arithmetic mean.
We already found that the mean is not a robust statistic and the median should be prefered over it whenever possible.
Hence, we would like to see robust measures of dispersion as well. 

\text.block{definition}{quantiles}{The $q$-quantiles are the cut points that divide a sorted* data sample $A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ where $\arrayIndex{a}{i-1}\leq \arrayIndex{a}{i} \; \forall i \in 1\dots (n-1)$ into $q$-equally sized parts.}

$\quantile{k}{q}$ be the $k$^th^ $q$-quantile, with $k\in 1\dots (q-n)$, i.e., there are $q-1$ $q$-quantiles.
The idea is that the probability&nbsp;$\probability\left[z < \quantile{k}{q}\right]$ to make an observation&nbsp;$z$ which is smaller than the $k$^th^ $q$-quantile should be less or equal than $k/q$.
The probability to encounter a sample which is less or equal to the quantile should be greater or equal to $k/q$:

$$ \probability\left[z < \quantile{k}{q}\right] \leq \frac{k}{q} \leq \probability\left[z \leq \quantile{k}{q}\right] $$

Quantiles are a generalization of the concept of the median, in that $\quantile{1}{2}=\median=\quantile{i}{2i}\forall i>0$.
There are actually several approaches to estimate quantiles from data.
The `R`&nbsp;programming language widely used in statistics applies [@eq:quantiles] as default&nbsp;[@BCW1988TNSLAPEFDAAG;@HF1996SQISP].
In an ideally-sized data sample, the number of elements minus 1, i.e., $n-1$, would be a multiple of $q$.
In this case, the $k$^th^ cut point would directly be located at index&nbsp;$h=(n-1)\frac{k}{q}$.
Both in [@eq:quantiles] and in the formula for the median [@eq:median], this is included the first of the two alternative options.
Otherwise, both [@eq:median] and [@eu:quantiles] [interpolate linearly](http://en.wikipedia.org/wiki/Linear_interpolation) between the elements at the two closest indices, namely $\lfloor h\rfloor$ and $\lfloor h\rfloor + 1$.   

$$\begin{array}{rcl}
h&=&(n-1)\frac{k}{q}\\ 
\quantile{k}{q} &=& \left\{\begin{array}{ll}
\arrayIndex{a}{h}&\textnormal{if~}h\textnormal{~is integer}\\
\arrayIndex{a}{\lfloor h\rfloor}+\left(h-\lfloor h\rfloor\right)*\left(\arrayIndex{a}{\lfloor h\rfloor+1}-\arrayIndex{a}{\lfloor h\rfloor}\right)&\textnormal{otherwise}
\end{array}\right.\end{array} $$ {#eq:quantiles}

Quantiles are more robust against skewed distributions and outliers.

If we do not assume that the data sample is distributed symmetrically, it makes sense to describe the spreads both left and right from the median.
A good impression can be obtained by using $\quantile{1}{4}$ and $\quantile{3}{4}$, which are usually called the first and third quartile (while $\median=\quantile{2}{4}$).


Let us look again at our previous example with the two data samples

- $A=(1, 3, 4, 4, 4, 5, 6, 6, 6, 6, 7, 7, 9, 9, 9, 10, 11, 12, 14)$
- $B=(1, 3, 4, 4, 4, 5, 6, 6, 6, 6, 7, 7, 9, 9, 9, 10, 11, 12, 10008)$

We find that:

- $\variance(A)=\frac{1}{19-1} \sum_{i=0}^{n-1} \left(\arrayIndex{a}{i} - 7\right)^2 = \frac{198}{18}=11$ and
- $\variance(B)=\frac{1}{19-1} \sum_{i=0}^{n-1} \left(\arrayIndex{b}{i} - 533\right)^2 = \frac{94763306}{18}\approx 5264628.1$, meaning
- $\stddev(A)=\sqrt{\variance(A)} \approx 3.317$ and
- $\stddev(B)=\sqrt{\variance(B)} \approx 2294.5$, while on the other hand
- $\quantile{1}{4}(A)=\quantile{1}{4}{B}=4.5$ and
- $\quantile{3}{4}(A)=\quantile{3}{4}{B}=9$.
