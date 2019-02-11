## Evolutionary Algorithm {#sec:evolutionaryAlgorithm}

We now already have one more or less functional, basic optimization method &ndash; the hill climber.
Different from the random sampling approach, it makes use of some knowledge gathered during the optimization process, namely the best-so-far point in the search space.
However, only using this point led to the danger of premature convergence, which we tried to battle with two approaches, namely restarts and the search operator `nswap` spanning a larger neighborhood from which we sampled in a non-uniform way.
These concepts can be transfered rather easily to may different kinds of optimization problems.
Now we will look at a third concept to prevent premature convergence: Instead of just remembering and utilizing one single point from the search space during our search, we will work on a set of points!

### Evolutionary Algorithm without Recombination

Today, there exists a wide variant of Evolutionary Algorithms (EAs)&nbsp;[@WGOEB; @BFM1997EA; @G1989GA; @DJ2006ECAUA; @M1996GADSEP].
We will begin with a very simple, yet efficient variant: the $(\mu+\lambda)$&nbsp;EA.[^EA:no:recombination]
This algorithm always remembers the best&nbsp;$\mu\in\naturalNumbersO$ points in the search space found so far.
In each step, it derives&nbsp;$\lambda\in\naturalNumbersO$ new points from them (by applying the unary search operator[^EA:no:recombination]).

[^EA:no:recombination]: For now, we will discuss them in a form without recombination. Wait for the recombination operator until [@sec:evolutionaryAlgorithmWithRecombination].


### Evolutionary Algorithm with Recombination {#sec:evolutionaryAlgorithmWithRecombination}
