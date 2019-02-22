### Performance Indicators

Unfortunately, many optimization problems are computationally hard.
If we want to guarantee that we can solve them to optimality, this would often incur an unacceptably long runtime.
Assume that an algorithm&nbsp;$\mathcal{A}$ can solve a problem instance in one million years while algorithm&nbsp;$\mathcal{B}$ only needs fifty.
In a practical scenario, usually neither is useful nor acceptable and the fact that&nbsp;$\mathcal{B}$ is better than&nbsp;$\mathcal{A}$ would not matter.^[From a research perspective, it does matter, though.]

As mentioned in [@sec:approximationOfTheOptimum], heuristic and metaheuristic optimization algorithms offer a trade-off between runtime and solution quality.
This means we can define two types of performance indicators.

1. The solution quality we can get within a pre-defined time.
2. The time we need to get reach a pre-defined solution quality.

With *solution quality*, we of course mean the objective value of the best solution discovered, and *time* is used in the sense of the time measure we have chosen.
