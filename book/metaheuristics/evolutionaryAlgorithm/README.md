## Evolutionary Algorithm {#sec:evolutionaryAlgorithm}

We now already have one more or less functional, basic optimization method &ndash; the hill climber.
Different from the random sampling approach, it makes use of some knowledge gathered during the optimization process, namely the best-so-far point in the search space.
However, only using this point led to the danger of premature convergence, which we tried to battle with two approaches, namely restarts and the search operator `nswap` spanning a larger neighborhood from which we sampled in a non-uniform way.
These concepts can be transfered rather easily to may different kinds of optimization problems.
Now we will look at a third concept to prevent premature convergence: Instead of just remembering and utilizing one single point from the search space during our search, we will work on an array of points!

### Evolutionary Algorithm without Recombination

Today, there exists a wide variant of Evolutionary Algorithms (EAs)&nbsp;[@WGOEB; @BFM1997EA; @G1989GA; @DJ2006ECAUA; @M1996GADSEP; @M1998GA].
We will begin with a very simple, yet efficient variant: the $(\mu+\lambda)$&nbsp;EA without recombination.[^EA:no:recombination]
This algorithm always remembers the best&nbsp;$\mu\in\naturalNumbersO$ points in the search space found so far.
In each step, it derives&nbsp;$\lambda\in\naturalNumbersO$ new points from them by applying the unary search operator.

[^EA:no:recombination]: For now, we will discuss them in a form without recombination. Wait for the recombination operator until [@sec:evolutionaryAlgorithmWithRecombination].

#### The Algorithm
The basic $(\mu+\lambda)$&nbsp;Evolutionary Algorithm works as follows:

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.
    b. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
    c. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    d. Sort the array&nbsp;$P$ according to the objective values such that the records with better associated objective value&nbsp;$\obspel$ are located at smaller indices. For minimization problems, this means elements with smaller objective values come first.
    e. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    f. Set the first source index&nbsp;$p=-1$.
    g. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p$ to&nbsp;$p=(p+1)\bmod \mu$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
        ii. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_1(\elementOf{\arrayIndex{P}{p}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the unary search operator to the point stored at index&nbsp;$p$.
        iii. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
        iv. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.

\repo.listing{lst:EAwithoutCrossover}{An excerpt of the implementation of the Evolutionary Algorithm algorithm **without** crossover.}{java}{src/main/java/aitoa/algorithms/EA.java}{}{relevant,withoutcrossover}

This algorithm is implemented in [@lst:EAwithoutCrossover].
Basically, it starts out by creating and evaluating&nbsp;$\mu+\lambda$ random candidate solutions (*point&nbsp;3*).

\text.block{definition}{generationEA}{Each iteration of the main loop of an Evolutionary Algorithm is called a *generation*.}

\text.block{definition}{populationEA}{The array of solutions under investigation in an EA is called *population*.}

In each generation, the&nbsp;$\mu$ best points in the population&nbsp;$P$ are retained and the other&nbsp;$\lambda$ solutions are overwritten.

\text.block{definition}{selectionEA}{The *selection* step in an Evolutionary Algorithm picks the set of points in the search space from which new points should be derived. This usually involves choosing a smaller number&nbsp;$\mu\in\naturalNumbersO$ of points from a larger array&nbsp;$P$.&nbsp;[@WGOEB; @BT1995EA; @CDC1996AOSAAMCA; @BFM1997EA; @M1998GA]}

*Selection* can be done by sorting the array&nbsp;$P$ (*point&nbsp;d*).
This way, the best&nbsp;$\mu$ solutions end up at the front of the array on the indices from&nbsp;$0$ to&nbsp;$\mu-1$.
The worse&nbsp;$\lambda$ solutions are at index&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$.
These are overwritten by sampling points from the neighborhood of the&nbsp;$\mu$ selected solutions by applying the unary search operator.

\text.block{definition}{reproductionEA}{The *reproduction* step in an Evolutionary Algorithm uses the selected&nbsp;$\mu\in\naturalNumbersO$ points from the search space to derive&nbsp;$\lambda\in\naturalNumbersO$ new points.}

For each new point to be created during the reproduction step, we apply a search operator to one of the selected&nbsp;$\mu$ points.
Therefore, the index&nbsp;$p$ identifies the point to be used as source for sampling the next new solution.
By incrementing&nbsp;$p$ before each application of the search operator, we try to make sure that each of the selected points is used approximately equally often to create new solutions.
Of course, $\mu$ and&nbsp;$\lambda$ can be different (often&nbsp;$\lambda>\mu$), so if we would just keep increasing&nbsp;$p$ for&nbsp;$\lambda$ times, it could exceed&nbsp;$\mu$.
We thus performing a [modulo division](http://en.wikipedia.org/wiki/Modulo_operation) with&nbsp;$\mu$, i.e., set&nbsp;$p$ to the remainder of the division with&nbsp;$\mu$, which makes sure that&nbsp;$p$ will be in&nbsp;$0\dots(\mu-1)$.

If $\mu\neq\lambda$, then the best solutions in&nbsp;$P$ tend to be used more often, since they may "survive" selection several times and often be at the front of&nbsp;$P$.
This means that, in our algorithm, they would be used more often as input to the search operator.
To make our algorithm more fair, we randomly shuffle the selected&nbsp;$\mu$ points (*point&nbsp;f*) &ndash; their actual order does not matter, as they have already been selected.

#### Results on the JSSP

After implementing the $(\mu+\lambda)$&nbsp;EA as discussed above, we already have all the ingredients ready to apply to the JSSP.
We need to decide which values for&nbsp;$\mu$ and&nbsp;$\lambda$ we want to use.
The configuration of EAs is a whole research area itself.
Here, let us just set&nbsp;$\mu=\lambda$ and test the two fairly large values 2048 and 4096.
We will call the corresponding setups `ea2048` and `ea4096`, respectively.
As unary search operators, we test again `1swap` and `nswap`.
The results are given in [@tbl:eaNoCrHCJSSP], together with those of our best hill climber with restarts `hcr_256+5%_nswap`.

|$\instance$|$\lowerBound{\objf}$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hcr_256+5%_nswap`|707|733|734|**7**|64s|17293038|
|||`ea2048_1swap`|695|719|718|13|**11**s|2581614|
|||`ea2048_nswap`|694|714|714|12|18s|4271587|
|||`ea4096_1swap`|**688**|716|716|12|19s|4416129|
|||`ea4096_nswap`|692|**711**|**710**|10|34s|7888233|
|`la24`|935|`hcr_256+5%_nswap`|945|981|984|**9**|57s|29246097|
|||`ea2048_1swap`|945|983|983|16|**2**s|927000|
|||`ea2048_nswap`|943|980|984|15|3s|1329883|
|||`ea4096_1swap`|941|980|978|14|5s|1897387|
|||`ea4096_nswap`|**938**|**976**|**975**|13|6s|2512530|
|`swv15`|2885|`hcr_256+5%_nswap`|3645|3804|3811|**44**|**91**s|14907737|
|||`ea2048_1swap`|3395|3535|3530|78|128s|19290521|
|||`ea2048_nswap`|**3374**|**3521**|**3517**|70|157s|22976339|
|||`ea4096_1swap`|3397|3533|3533|54|171s|25073630|
|||`ea4096_nswap`|3421|3543|3539|46|178s|25678144|
|`yn4`|929|`hcr_256+5%_nswap`|1081|1117|1119|**14**|55s|11299461|
|||`ea2048_1swap`|1032|1082|1082|22|**26**s|4792622|
|||`ea2048_nswap`|1034|1074|1073|19|41s|7514890|
|||`ea4096_1swap`|**1020**|1076|1074|21|39s|6907692|
|||`ea4096_nswap`|1034|**1068**|**1067**|18|56s|9976531|

: The results of the evolutionary algorithms without crossover in comparision to the best hill climber with restarts setup `hcr_256+5%_nswap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:eaNoCrHCJSSP}

[@tbl:eaNoCrHCJSSP] shows us that we can improve the best, mean, and median solution quality that we can get within three minutes of runtime by at least three percent when using our EA setups instead of the hill climber.
The exception is case `la24`, where the hill climber already came close to the lower bound of the makespan.
Here, the best solution encountered now has a makespan which is only 0.3% longer than what is theoretically possible.
Nethertheless, we find quite a tangible improvement in case `swv15`.

The bigger setting 4096 for&nbsp;$\mu$ and&nbsp;$\lambda$ tends to work better, except for instance&nbsp;`swv15`, where 2048 gives us better results.
It is quite common in optimization that different problem instances may require different setups to achieve the best performance.
The`nswap` operator again works better than `1swap`.

![The Gantt charts of the median solutions obtained by the&nbsp;`ea4096_nswap` setup. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_ea4096_nswap_med.svgz}){#fig:jssp_gantt_ea4096_nswap_med width=84%}

![The progress of the&nbsp;`ea4096_nswap`, `ea2048_nswap`, and&nbsp;`hcr_256+5%_nswap` algorithms over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_ea_nocr_hc_log.svgz}){#fig:jssp_progress_ea_nocr_hc_log width=84%}

The Gantt charts of the median solutions of `ea4096_nswap` are illustrated in [@fig:jssp_gantt_ea4096_nswap_med].
More interesting are the progress diagrams of `ea4096_nswap`, `ea2048_nswap`, and&nbsp;`hcr_256+5%_nswap` in [@fig:jssp_progress_ea_nocr_hc_log].
Here we find big visual differences between the way the EAs and hill climbers proceed.
The EAs spend the first 100ms to discover some basins of attraction of local optima before speeding up.
The larger the population, the longer it takes them until this happens.
It is interesting to notice that the two problems where the EAs visually outperform the hill climber the most, `swv15` and `yn4`, are also those with the largest search spaces (see [@tbl:jsspSearchSpaceTable]).
`la24`, however, which already can "almost be solved" by the hill climber and where there are the smallest differences in perfomance, is the smallest instance.
The population used by the EA seemingly guards against premature convergence and allows it to keep progressing for a longer time.

#### Exploration versus Exploitation

Naturally, we may ask why the population is helpful in the search.
First of all, we can consider it as a "generalized" version of the Hill Climber.
If we would set&nbsp;$\mu=1$ and&nbsp;$\lambda=1$, then we would always remember the best solution we had so far and, in each generation, derive one new solution from it.
This is the hill climber.

Now imagine what would happen if we would set&nbsp;$\mu$ to infinity.
We then would remember each and every point in the search space we would have ever visited during the search.
We would not perform any actual selection, as we would always select all points.
Our search would not be steered in any direction, there would not be any *bias* or preference for better solutions.
Due to the fairness of our algorithm when it comes to selecting "parent" points for sampling, each of the past solutions would have the same chance to be the input to the unary search operator to produce the next point to visit.
In other words, the EA would be some wierd version of random sampling.

The parameter&nbsp;$\mu$ basically allows us to "tune" between these two behaviors&nbsp;[@WWCTL2016GVLSTIOPSOEAP]!
If we pick it small, our algorithm becomes more "greedy".
It will investigate (*exploit*) the neighborhood current best solutions more eagerly, which means that it will trace down local optima faster but be trapped more easily in local optima as well.
If we set&nbsp;$\mu$ to a larger value, we will keep more not-that-great solutions in its population.
The algorithm spends more time *exploring* the neighborhoods of solutions which do not look that good, but from which we might eventually reach better results.
The convergence is slower, but we are less likely to get trapped in a local optimum.

This is dilemma of "Exploration versus Exploitation"&nbsp;[@ES1998EA; @WCT2012EOPABT; @WZCN2009WIOD; @WGOEB].


### Evolutionary Algorithm with Recombination {#sec:evolutionaryAlgorithmWithRecombination}
