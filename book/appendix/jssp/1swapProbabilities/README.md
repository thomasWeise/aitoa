### Probabilities for the `1swap` Operator {#sec:appendix:jssp:1swapProb}

Every point in the search space contains&nbsp;$\jsspMachines*\jsspJobs$ integer values.
If we swap two of them, we have&nbsp;$\jsspMachines*\jsspJobs*\jsspMachines*(\jsspJobs-1)=\jsspMachines^2 \jsspJobs^2-\jsspJobs$ choices for the indices, half of which would be redundant (like swapping the jobs at index $(10,5)$ and $(5,10)$).
In total, this yields&nbsp;$T=0.5*\jsspMachines^2*\jsspJobs*(\jsspJobs-1)$ possible different outcomes for a given point from the search space, and our `1swap` operator produces each of them with the same probability.

If $0<k\leq T$ of outcomes would be an improvement, then the number&nbsp;$A$ of times we need to apply the operator to obtain one of these improvements would follow a [geometric distribution](http://en.wikipedia.org/wiki/Geometric_distribution) and have expected value&nbsp;${\expectedValue}A$:

$$ {\expectedValue}A = \frac{1}{\frac{k}{T}} = \frac{T}{k} $$

We could instead enumerate all possible outcomes and stop as soon as we arrive at an improving move.
Again assume that we have $k$&nbsp;improving moves within the set of $T$&nbsp;possible outcomes.
Let&nbsp;$B$ be the number of steps we need to perform until we haven an improvement.
$B$&nbsp;follows the [negative hypergeometric distribution](http://en.wikipedia.org/wiki/Negative_hypergeometric_distribution), with "successes" and "failures" swapped, with one trial added (for drawing the improving move).
The expected value&nbsp;${\expectedValue}B$ becomes:

$$ {\expectedValue}B = 1+\frac{(T-k)}{T-(T-k)+1} = 1+\frac{T-k}{k+1}=\frac{T-k+k+1}{k+1}=\frac{T+1}{k+1} $$ 

It holds that ${\expectedValue}B \leq {\expectedValue}A$ since $\frac{T}{k}-\frac{T+1}{k+1}=\frac{T(k+1)-(T+1)k}{k(k+1)} = \frac{Tk+T-Tk-k}{k(k+1)}=\frac{T-k}{k(k+1)}$ is positive or zero.
This makes sense, as no point would be produced twice during an exhaustive enumeration, whereas random sampling might sample some points multiple times.

This means that enumerating all possible outcomes of the `1swap` operator should also normally yield an improving move faster than randomly sampling them!
