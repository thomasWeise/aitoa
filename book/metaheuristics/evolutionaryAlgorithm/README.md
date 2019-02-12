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
In each step, it derives&nbsp;$\lambda\in\naturalNumbersO$ new points from them by applying the unary search operator.
The algorithm works as follows:

[^EA:no:recombination]: For now, we will discuss them in a form without recombination. Wait for the recombination operator until [@sec:evolutionaryAlgorithmWithRecombination].

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.
    b. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
    c. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    d. Sort the array&nbsp;$P$ according to the objective values such that the records with better associated objective value&nbsp;$\obspel$ are located at smaller indices. For minimization problems, this means elements with smaller objective values come first.
    e. Set the first source index&nbsp;$p=-1$.
    f. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    g. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p$ to&nbsp;$p=(p+1)\bmod \mu$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
        ii. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_1(\elementOf{\arrayIndex{P}{p}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the unary search operator to the point stored at index&nbsp;$p$.
        iii. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
        iv. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.

\repo.listing{lst:EAwithoutCrossover}{An excerpt of the implementation of the Evolutionary Algorithm algorithm without crossover.}{java}{src/main/java/aitoa/algorithms/EA.java}{}{relevant,withoutcrossover}

This algorithm is implemented in [@lst:EAwithoutCrossover].
Basically, it starts out by creating&nbsp;$\mu+\lambda$ random candidate solutions.
In each step, the&nbsp;$\mu$ best ones are retained and the other&nbsp;$\lambda$ solutions are overwritten.
This is done by first sorting the array&nbsp;$P$.
We therefore sample points from the neighborhood of the&nbsp;$\mu$ selected solutions by applying the unary search operator.

The index&nbsp;$p$ identifies the point to be used as basis for sampling new solutions.
It is used to try to make sure that each of the selected points is used approximately equally often to create new solutions.
This is done by incrementing&nbsp;$p$ for each application of the search operator and then performing a modulo division with&nbsp;$\mu$, which makes sure that&nbsp;$p$ will be in&nbsp;$0\dots(\mu-1)$.
The other measure to ensure fairness is to randomly shuffle the selection points in each iteration of the main loop (*point&nbsp;f*).

### Evolutionary Algorithm with Recombination {#sec:evolutionaryAlgorithmWithRecombination}
