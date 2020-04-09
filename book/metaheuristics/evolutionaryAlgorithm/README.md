## Evolutionary Algorithm {#sec:evolutionaryAlgorithm}

We now already have one functional, basic optimization method &ndash; the hill climber.
Different from the random sampling approach, it makes use of some knowledge gathered during the optimization process, namely the best-so-far point in the search space.
However, only using this single point led to the danger of premature convergence, which we tried to battle with two approaches, namely restarts and the search operator `nswap`, spanning a larger neighborhood from which we sampled in a non-uniform way.
These concepts can be transfered rather easily to many different kinds of optimization problems.
Now we will look at a third concept to prevent premature convergence:
Instead of just remembering and utilizing only one single point from the search space in each iteration of our algorithm, we will now work on an array of points!

### Evolutionary Algorithm without Recombination {#sec:evolutionaryAlgorithmWithoutRecombination}

Today, there exists a wide variety of different Evolutionary Algorithms (EAs)&nbsp;[@WGOEB; @BFM1997EA; @G1989GA; @DJ2006ECAUA; @M1996GADSEP; @M1998GA; @CWM2012VOEAFRWA; @S2003ITSSAO].
We will here discuss a simple yet efficient variant: the $(\mu+\lambda)$&nbsp;EA without recombination.[^EA:no:recombination]
This algorithm always remembers the best&nbsp;$\mu\in\naturalNumbersO$ points in the search space found so far.
In each step, it derives&nbsp;$\lambda\in\naturalNumbersO$ new points from them by applying the unary search operator.

[^EA:no:recombination]: For now, we will discuss EAs in a form without recombination. Wait for the binary recombination operator until [@sec:evolutionaryAlgorithmWithRecombination].

#### The Algorithm (without Recombination) {#sec:evolutionaryAlgorithmWithoutRecombinationAlgo}

The basic $(\mu+\lambda)$&nbsp;Evolutionary Algorithm works as follows:

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.
    b. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
    c. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    d. Sort the array&nbsp;$P$ according to the objective values such that the records&nbsp;$r$ with better associated objective value&nbsp;$\elementOf{r}{\obspel}$ are located at smaller indices. This means that elements with better objective values come first.
    e. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    f. Set the first source index&nbsp;$p=-1$.
    g. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p$ to&nbsp;$p=\modulo{(p+1)}{\mu}$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
        ii. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_1(\elementOf{\arrayIndex{P}{p}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the unary search operator to the point stored at index&nbsp;$p$.
        iii. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
        iv. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ (i.e., the best-ever encountered solution) to the user.

\repo.listing{lst:EAwithoutCrossover}{An excerpt of the implementation of the Evolutionary Algorithm algorithm **without** crossover.}{java}{src/main/java/aitoa/algorithms/EA.java}{}{relevant,withoutcrossover}

This algorithm is implemented in [@lst:EAwithoutCrossover].
Basically, it starts out by creating and evaluating&nbsp;$\mu+\lambda$ random candidate solutions (*point&nbsp;3*).

\text.block{definition}{generationEA}{Each iteration of the main loop of an Evolutionary Algorithm is called a *generation*.}

\text.block{definition}{populationEA}{The array of solutions under investigation in an EA is called *population*.}

In each generation, the&nbsp;$\mu$ best points in the population&nbsp;$P$ are retained and the other&nbsp;$\lambda$ solutions are overwritten with newly sampled points.

\text.block{definition}{selectionEA}{The *selection* step in an Evolutionary Algorithm picks the set of points in the search space from which new points should be derived. This usually involves choosing a smaller number&nbsp;$\mu\in\naturalNumbersO$ of points from a larger array&nbsp;$P$.&nbsp;[@WGOEB; @BT1995ACOSSUIGA; @CDC1996AOSAAMCA; @BFM1997EA; @M1998GA]}

*Selection* can be done by sorting the array&nbsp;$P$ (*point&nbsp;d*).
This way, the best&nbsp;$\mu$ solutions end up at the front of the array on the indices from&nbsp;$0$ to&nbsp;$\mu-1$.
The worse&nbsp;$\lambda$ solutions are at index&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$.
These are overwritten by sampling points from the neighborhood of the&nbsp;$\mu$ selected solutions by applying the unary search operator (which, in the context of EAs, is often called *mutation* operator).

\text.block{definition}{parentsEA}{The selected points in an Evolutionary Algorithm are called *parents*.}

\text.block{definition}{offspringEA}{The points in an Evolutionary Algorithm that are sampled from the neighborhood of the parents by applying search operators are called *offspring*.}

\text.block{definition}{reproductionEA}{The *reproduction* step in an Evolutionary Algorithm uses the selected&nbsp;$\mu\in\naturalNumbersO$ points from the search space to derive&nbsp;$\lambda\in\naturalNumbersO$ new points.}

For each new point to be created during the reproduction step, we apply a search operator to one of the selected&nbsp;$\mu$ points.
Therefore, the index&nbsp;$p$ identifies the point to be used as source for sampling the next new solution.
By incrementing&nbsp;$p$ before each application of the search operator, we try to make sure that each of the selected points is used approximately equally often to create new solutions.
Of course, $\mu$ and&nbsp;$\lambda$ can be different (often&nbsp;$\lambda>\mu$), so if we would just keep increasing&nbsp;$p$ for&nbsp;$\lambda$ times, it could exceed&nbsp;$\mu$.
We thus perform a modulo division with&nbsp;$\mu$, i.e., set&nbsp;$p$ to the remainder of the division with&nbsp;$\mu$, which makes sure that&nbsp;$p$ will be in&nbsp;$0\dots(\mu-1)$.

If $\mu\neq\lambda$, then the best solutions in&nbsp;$P$ tend to be used more often, since they may "survive" selection several times and often be at the front of&nbsp;$P$.
This means that, in our algorithm, they would be used more often as input to the search operator.
To make our algorithm more fair, we randomly shuffle the selected&nbsp;$\mu$ points (*point&nbsp;f*).
This does not change the fact that they have been selected.

#### The Right Setup {#sec:eaNoCrSetup}

After implementing the $(\mu+\lambda)$&nbsp;EA as discussed above, we already have all the ingredients ready to apply to the JSSP.
We need to decide which values for&nbsp;$\mu$ and&nbsp;$\lambda$ we want to use.
The configuration of EAs is a whole research area itself.
The question arises which values for $\mu$ and $\lambda$ are reasonable.
Without investigating whether this is the best idea, let us set $\mu=\lambda$ here, so we only have two parameters to worry about: $\mu$ and the unary search operator.
We already have two unary search operators.
Let us call our algorithms of this type `ea_mu_unary`, where `mu` will stand for the value of&nbsp;$\mu$ and&nbsp;$\lambda$ and `unary` can be either `1swap` or `nswap`.
We no therefore do a similar experiment as in [@sec:hillClimberWithRestartSetup] in order to find the right parameters. 

![The median result quality of the&nbsp;`ea_mu_unary` algorithm, divided by the lower bound $\lowerBound(\objf)^{\star}$ from [@tbl:jsspLowerBoundsTable] over different values of the population size parameter&nbsp;$\mu=\lambda$ and the two unary search operators `1swap` and `nswap`. The best values of&nbsp;$\mu$ for each operator and instance are marked with bold symbols.](\relative.path{jssp_ea_nocr_med_over_mu.svgz}){#fig:jssp_ea_nocr_med_over_mu width=84%}

In [@fig:jssp_ea_nocr_med_over_mu], we illustrate this experiment.
Regarding $\mu$ and $\lambda$, we observe the same situation as with the restarts parameters hill climber.
There is a "sweet spot" somewhere between small and large population sizes.
For small values of $\mu$, the algorithm may land in a local optimum too quickly, whereas for large values, it may not be able to perform sufficiently many generations to arrive at a good solution.
The setting $\mu=\lambda=16'384$ seems to work well for instances `abz7`, `la25`, and `yn4`.
Interestingly, instance `swv15` behaves different: here, a $\mu=\lambda=1024$ works best.
It is quite common in optimization that different problem instances may require different setups to achieve the best performance &ndash; but here we see it very pronounced

Regarding the choice of the unary search operator:
With the exception of problem `swv15`, both operators provide the same median result quality.
In the other setups, if one of the two is better, it is most of the time `nswap`.

Therefore, we will consider the two setups `ea_16384_nswap` and `ea_1024_nswap` when evaluating the performance of our Evolutionary Algorithms.

#### Results on the JSSP

Let us now compare the results of the best two EA setups with those that we obtained with the hill climber.

\relative.input{jssp_ea_nocr_results.md}

: The results of the Evolutionary Algorithm `ea_mu_nswap` without recombination in comparison with the best hill climber `hc_nswap` and the best hill climber with restarts `hcr_65536_nswap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_ea_nocr_results}

[@tbl:jssp_ea_nocr_results] shows us that we can improve the best, mean, and median solution quality that we can get within three minutes of runtime when using our either of the two EA setups instead of the hill climber.
The exception is case `la24`, where the hill climber already came close to the lower bound of the makespan and has a better best solution than `ea_16384_nswap`.
Here, the best solution encountered now has a makespan which is only 0.7% longer than what is theoretically possible.
Nevertheless, we find quite a tangible improvement in case `swv15` on `ea_1024_nswap`.

Our `ea_16384_nswap` outperforms the four Evolutionary Algorithms from&nbsp;[@JPDS2014CAODRIGAFJSSP] both in terms of mean and best result quality on `abz7` and `la24`.
It does the same for HIMGA-Mutation, the worst of the four HIMGA variants introduced in&nbsp;[@K2015ANHIMGAFJSSP], for `abz7`, `la24`, and `yn4`.
It obtains better results than the PABC from&nbsp;[@SMM2018PABCPFJSSP] on `swv15`.
On `la24`, both in terms of mean and best result, it outperforms also all six EAs from&nbsp;[@A2010RIGAFTJSPACS], both variants of the EA in&nbsp;[@ODP2010STJSPWARKGAWIP], and the LSGA from&nbsp;[@OV2004LSGAFTJSSP]. 
The best solution quality for `abz7` delivered by `ea_16384_nswap` is better than the best result found by the old Fast Simulated Annealing algorithm which was improved in&nbsp;[@AKZ2016FSAHWQFSJSSP].

The Gantt charts of the median solutions of `ea_16384_nswap` are illustrated in [@fig:jssp_gantt_ea_16384_nocr_nswap_med].
They appear only a bit denser than those in [@fig:jssp_gantt_hcr_16384_1swap_med].

More interesting are the progress diagrams of the `ea_16384_nswap`, `ea_1024_nswap`, `hcr_65536_nswap`, and&nbsp;`hc_nswap` algorithms given in [@fig:jssp_progress_ea_nocr_nswap_log].
Here we find big visual differences between the way the EAs and hill climbers proceed.
The EAs spend the first 10 to 1000&nbsp;ms to discover some basins of attraction of local optima before speeding up.
The larger the population, the longer it takes them until this happens:
The difference between `ea_16384_nswap`, is very obvious `ea_1024_nswap` in this respect.
It is interesting to notice that the two problems where the EAs visually outperform the hill climber the most, `swv15` and `yn4`, are also those with the largest search spaces (see [@tbl:jsspSearchSpaceTable]).
`la24`, however, which already can "almost be solved" by the hill climber and where there are the smallest differences in performance, is the smallest instance.
The population used by the EA seemingly guards against premature convergence and allows it to keep progressing for a longer time.

We also notice that &ndash; for the first time in our endeavor to solve the JSSP &ndash; runtime is the limiting factor.
If we would have 20&nbsp;minutes instead of three, then we could not expect much improvement from the hill climbers.
Even with restarts, they already improve very slowly towards the end of the computational budget.
Tuning their parameter, e.g., increasing the time until a restart is performance, would probably not help then either.
However, we can clearly see that `ea_16384_nswap` has not fully converged on neither `abz7`, `swv15`, nor on `yn4` after the three minutes.
Its median curve is still clearly pointing downwards.
And even if it had converged:
If we had a larger computational budget, we could increase the population size.
The reason why the performance for larger populations in [@fig:jssp_ea_nocr_med_over_mu] gets worse is very likely the limited time budget.

![The Gantt charts of the median solutions obtained by the&nbsp;`ea_16384_nswap` setup. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_ea_16384_nocr_nswap_med.svgz}){#fig:jssp_gantt_ea_16384_nocr_nswap_med width=84%}

![The median of the progress of the&nbsp;`ea_16384_nswap`, `ea_1024_nswap`, `hcr_65536_nswap`, and&nbsp;`hc_nswap` algorithms over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_ea_nocr_nswap_log.svgz}){#fig:jssp_progress_ea_nocr_nswap_log width=84%}

#### Exploration versus Exploitation {#sec:ea:exploration:exploitation}

Naturally, when discussing EAs, we may ask why the population is helpful in the search.
While we now have some anecdotal evidence that this is the case, we may also think about this more philosophically.
Let us therefore do a thought experiment.
If we would set&nbsp;$\mu=1$ and&nbsp;$\lambda=1$, then the EA would always remember the best solution we had so far and, in each generation, derive one new solution from it.
If it is better, it will replace the remembered solution.
Such an EA is actually a hill climber.

Now imagine what would happen if we would set&nbsp;$\mu$ to infinity instead.
We would not even complete one single generation.
Instead, if $\mu\rightarrow\infty$, it would also take infinitely long to finish creating the first population of random solutions.
This does not even require infinity&nbsp;$\mu$ &ndash; $\mu$ just needs to be large enough so that the complete computational budget (in our case, three minutes) is consumed before creating the initial, random candidate solutions is completed.
In other words, the EA would then equal random sampling.

The parameter&nbsp;$\mu$ basically allows us to "tune" between these two behaviors&nbsp;[@WWCTL2016GVLSTIOPSOEAP]!
If we pick it small, our algorithm becomes more "greedy".
It will spend more time investigating (*exploiting*) the neighborhood of the current best solutions.
It will trace down local optima faster but be trapped more easily in local optima as well.

If we set&nbsp;$\mu$ to a larger value, we will keep more not-that-great solutions in its population.
The algorithm spends more time *exploring* the neighborhoods of solutions which do not look that good, but from which we might eventually reach better results.
The convergence is slower, but we are less likely to get trapped in a local optimum.

The question on which of the two to focus is known as the dilemma of "Exploration versus Exploitation"&nbsp;[@ES1998EA; @CLM2013EAEIEAAS; @WCT2012EOPABT; @WZCN2009WIOD; @WGOEB].
To make matters worse, theorists have proofed that there are scenarios where only a small population can perform well, while there are other scenarios where only a large population works well&nbsp;[@W2003ROCFTB].
In other words, if we apply an EA, we always need to do at least some rudimentary tuning of&nbsp;$\mu$ and&nbsp;$\lambda$.

### Ingredient: Binary Search Operator

On one hand, keeping a population of the&nbsp;$\mu>1$ best solutions as starting points for further exploration helps us to avoid premature convergence.
On the other hand, it also represents more *information*.
The hill climber only used the information in current-best solution as guide for the search (and the hill climber with restarts used, additionally, the number of steps performed since the last improvement).
Now we have a set of&nbsp;$\mu$ selected points from the search space.
These points have, well, been selected.
At least after some time has passed in our optimization process, "being selected" means "being good".
If you compare the Gantt charts of the median solutions of `ea_16384_nswap` ([@fig:jssp_gantt_ea_16384_nocr_nswap_med]) and `hcr_16384_1swap` ([@fig:jssp_gantt_hcr_16384_1swap_med]), you can see some good solutions for the same problem instances.
These solutions differ in some details.
Wouldn't it be nice if we could take two good solutions and derive a solution "in between," a new solution which is similar to both of its "parents"?

This is the idea of the binary search operator (also often referred to as *recombination* or *crossover* operator).
By defining such an operator, we hope that we can merge the "good characteristics" of two selected solutions to obtain one new (ideally better) solution&nbsp;[@H1975GA; @DJ1975GA].
If we are lucky and that works, then ideally such good characteristics could aggregate over time&nbsp;[@G1989GA; @MFH1991RRGAFLGAP].

How can we define a binary search operator for our JSSP representation?
*One possible* idea would be to create a new encoded solution&nbsp;$\sespel'$ by processing both input points&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$ from front to back and "schedule" their not-yet scheduled job IDs into&nbsp;$\sespel'$ similar to what we do in our representation mapping.

1. Allocate a data structure&nbsp;$\sespel'$ to hold the new point in the search space that we want to sample.
2. Set the index&nbsp;$i$ where the next sub-job should be stored in&nbsp;$\sespel'$ to $i=0$.
3. Repeat
    a. Randomly choose of the input points&nbsp;${\sespel}1$ or&nbsp;${\sespel}2$ with equal probability as source&nbsp;$\sespel$.
    b. Select the first (at the lowest index) sub-job in&nbsp;$\sespel$ that is not marked yet and store it in variable&nbsp;$J$.
    c. Set $\arrayIndex{\sespel'}{i}=J$.
    d. Increase&nbsp;$i$ by one ($i=i+1$).
    e. If&nbsp;$i=\jsspJobs*\jsspMachines$, then all sub-jobs have been assigned. We exit and returning&nbsp;$\sespel'$.
    f. Mark the first unmarked occurrence of&nbsp;$J$ as "already assigned" in ${\sespel}1$.
    g. Mark the first unmarked occurrence of&nbsp;$J$ as "already assigned" in ${\sespel}2$.

This can be implemented efficiently by keeping indices of the first unmarked element for both&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$, which we do in&nbsp;[@lst:JSSPBinaryOperatorSequence].

\repo.listing{lst:JSSPBinaryOperatorSequence}{An excerpt of the `sequence` recombination operator for the JSSP, an implementation of the binary search operation interface [@lst:IBinarySearchOperator].}{java}{src/main/java/aitoa/examples/jssp/JSSPBinaryOperatorSequence.java}{}{relevant}

As we discussed in [@sec:jsspSearchSpace], our representation mapping processes the elements&nbsp;$\sespel\in\searchSpace$ from the front to the back and assigns the jobs to machines according to the order in which their IDs appear.
It is a natural idea to design a binary operator that works in a similar way.
Our `sequence` recombination processes *two* points from the search space&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$ from their beginning to the end.
At each step randomly picks one of them to extract the next sub-job, which is  is then stored in the output&nbsp;$\sespel'$ and marked as "done" in both&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$.

If it would, by chance, always choose&nbsp;${\sespel}1$ as source, then it would produce exactly&nbsp;${\sespel}1$ as output.
If it would always pick&nbsp;${\sespel}2$ as source, then it would also return&nbsp;${\sespel}2$.
If it would pick&nbsp;${\sespel}1$ for the first half of the times and then always pick&nbsp;${\sespel}2$, it would basically copy the first half of&nbsp;${\sespel}1$ and then assign the rest of the sub-jobs in exactly the order in which they appear in&nbsp;${\sespel}2$.

![An example application of our sequence recombination operator to two points&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$ in the search space of the `demo` instance, resulting in a new point $\sespel'$. We mark the selected job IDs with pink and cyan color, while crossing out those IDs which were not chosen because of their received marks in the source points. The corresponding candidate solutions&nbsp;${\solspel}1$, ${\solspel}2$, and&nbsp;$\solspel'$ are illustrated as well.](\relative.path{jssp_sequence_recombination.svgz}){#fig:jssp_sequence_recombination width=90%}

For illustration purposes, one example application of this operator is sketched in [@fig:jssp_sequence_recombination].
As input, we chose to points&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$ from the search space for our `demo` instance.
They encode two different corresponding Gantt charts, ${\solspel}1$ and&nbsp;${\solspel}2$, with makespans of 202 and 182 time units, respectively.

Our operator begins by randomly choosing&nbsp;${\sespel}1$ as the source of the first sub-job for the new point&nbsp;$\sespel'$.
The first job ID in&nbsp;${\sespel}1$ is&nbsp;2, which is placed as first sub-job into&nbsp;$\sespel'$.
We also mark the first occurrence of&nbsp;2 in&nbsp;${\sespel}2$, which happens to be at position&nbsp;4, as "already scheduled."
Then, the operator again randomly picks&nbsp;${\sespel}1$ as source for the next sub-job.
The first not-yet marked element in&nbsp;${\sespel}1$ is now at the second&nbsp;0, so it is placed into&nbsp;$\sespel'$ and marked as scheduled in&nbsp;${\sespel}2$, where the fifth element is thus crossed out.
As next source, the operator, again, chooses&bsnp;${\sespel}1$.
The first unmarked sub-job in&nbsp;${\sespel}1$ is&nbsp;3 at position&nbsp;3, which is added to&nbsp;$\sespel'$ and leads to the first element of&nbsp;${\sespel}2$ being marked.
Finally, for picking the next sub-job, ${\sespel}2$ is chosen.
The first unmarked sub-job there has ID&nbsp;1 and is located at index&nbsp;2.
It is inserted at index&nbsp;4 into&nbsp;$\sespel'$.
It also occurs at index&nbsp;4 in&nbsp;${\sespel}1$, which is thus marked.
This process is repeated again and again, until&nbsp;$\sespel'$ is constructed completely, at which point all the elements of&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$ are marked.

The application of our binary operator yields a new point&nbsp;$\sespel'$ which corresponds to the Gantt chart&nbsp;$\solspel'$ with makespan 192.
This new candidate solution clearly "inherits" some characteristics from either of its parents.

### Evolutionary Algorithm with Recombination {#sec:evolutionaryAlgorithmWithRecombination}

We now want to utilize this new operator in our EA.
The algorithm now has two ways to create new offspring solutions: either via the unary operator (mutation, in EA-speak) or via the binary operator (recombination in EA-speak).
We modify the original EA as follows.

#### The Algorithm (with Recombination) {#sec:evolutionaryAlgorithmWithRecombinationImpl}

We introduce a new paramerter&nbsp;$cr\in[0,1]$, the so-called "crossover rate".
It is used whenever we want to derive a new points in the search space from existing ones.
It denotes the probability that we apply the binary operator (while we will otherwise apply the unary operator, i.e., with probability&nbsp;$1-cr$).
The basic $(\mu+\lambda)$&nbsp;Evolutionary Algorithm with recombination works as follows:

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.
    b. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
    c. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    d. Sort the array&nbsp;$P$ according to the objective values such that the records&nbsp;$r$ with better associated objective value&nbsp;$\elementOf{r}{\obspel}$ are located at smaller indices. This means that elements with better objective values come first.
    e. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    f. Set the first source index&nbsp;$p=-1$.
    g. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p$ to&nbsp;$p=\modulo{(p+1)}{\mu}$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
        ii. Draw a random number&nbsp;$c$ uniformly distributed in&nbsp;$[0,1)$.
        iii. If&nbsp;$c$ is less than the crossover rate&nbsp;$cr$, then we apply the binary operator:
             A. Randomly choose another index&nbsp;$p2$ from $0\dots(\mu-1)$ such that&nbsp;$p2\neq p$.
             B. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_2(\elementOf{\arrayIndex{P}{p}}{\sespel}, \elementOf{\arrayIndex{P}{p2}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the binary search operator to the points stored at index&nbsp;$p$ and&nbsp;$p2$.
        iv. else, i.e., $c\geq cr$, then we apply the unary operator:
            C. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_1(\elementOf{\arrayIndex{P}{p}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the unary search operator to the point stored at index&nbsp;$p$.
        v. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
        vi. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.

\repo.listing{lst:EAwithCrossover}{An excerpt of the implementation of the Evolutionary Algorithm algorithm **with** crossover.}{java}{src/main/java/aitoa/algorithms/EA.java}{}{relevant,withcrossover}

This algorithm, implemented in [@lst:EAwithCrossover] only differs from the variant in [@sec:evolutionaryAlgorithmWithoutRecombinationAlgo] by choosing whether to use the unary or binary operator to sample new points from the search space (*steps&nbsp;A*, *B*, and&nbsp;*C*).
If&nbsp;$cr$ is the probability to apply the binary operator and we draw a random number&nbsp;$c$ which is uniformly distributed in&nbsp;$[0,1)$, then the probability that $c<cr$ is exactly&nbsp;$cr$ (see *point&nbsp;iii*).

#### The Right Setup {#sec:eaCrSetup}

Unfortunately, with&nbsp;$cr\in[0,1]$, a new algorithm parameter has emerged.
It is not really clear whether a large or a small crossover rate is good.
We already tested $cr=0$: The EA without recombination.
Similar to our other small tuning experiments, let us compare the performance of different settings of&nbsp;$cr$.
We investigate the crossover rates $cr\in\{0, 0.05, 0.3, 0.98\}$.
We will stick with `nswap` as unary operator and keep $\mu=\lambda$.

![The median result quality of the&nbsp;`ea_mu_cr_nswap` algorithm, divided by the lower bound $\lowerBound(\objf)^{\star}$ from [@tbl:jsspLowerBoundsTable] over different values of the population size parameter&nbsp;$\mu=\lambda$ and the crossover rates in&nbsp;$\{0, 0.05, 0.3, 0.98\}$. The best values of&nbsp;$\mu$ for each crossover rate and instance are marked with bold symbols.](\relative.path{jssp_ea_cr_med_over_cr.svgz}){#fig:jssp_ea_cr_med_over_cr width=84%}

From [@fig:jssp_ea_cr_med_over_cr], we immediately find that the large crossover rate&nbsp;$cr=0.98$ is performing much worse than using no crossover at all ($cr=0$) on all instances.
Smaller rates $cr\in\{0.05,0.3\}$ tend to be sometimes better and sometimes worse than&nbsp;$cr=0$, but there is no big improvement.
On instance `swv15`, the binary operator does not really help.
On instance `la24`, $cr=0.05$ performs best on mid-sized populations, while there is no distinguishable difference between $cr=0.05$ and $cr=0$ for large populations.
On `abz7` and `yn4`, $cr=0.05$ always seems to be a good choice.
On these three instances, the population size $\mu=\lambda=8192$ in combination with $cr=0.05$ looks promising.
We will call this setup `ea_8192_5%_nswap` in the following, where 5% stands for the crossover rate of 0.05 using the binary `sequence` operator. 

#### Results on the JSSP

We can now investigate whether our results have somewhat improved.

\relative.input{jssp_ea_cr_results.md}

: The results of the Evolutionary Algorithm `ea_8192_5%_nswap` in comparison two the same population size without recombination (`ea_8192_nswap`) and the two EAs from [@tbl:jssp_ea_nocr_results]. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_ea_cr_results}

The results in [@tbl:jssp_ea_cr_results] show that a moderate crossover rate of 0.05 can indeed improve our algorithm's performance &ndash; a little bit.
For `swv15`, we already know that recombination was not helpful and this is confirmed in the table.
On the three other instances, `ea_8192_5%_nswap` has better mean and median results than `ea_1024_nswap`, `ea_8192_nswap`, and `ea_16384_nswap`.
On `abz7`, it can also slightly improve on the best result we got so far.

Interestingly, on `swv15`, the `ea_1024_nswap` stops improving in median after about 87 seconds, whereas all other EAs keep finding improvements even very close to the end of the 180 seconds budget.
This probably means that they would also perform better than `ea_1024_nswap` if only we had more time.
There might just not be enough time for any potential benefits of the binary operator to kick in.
This could also be a valuable lesson: it does not help if the algorithm gives better results if it needs too much time.
Any statement about an achieved result quality is only valid if it also contains a statement about the required computational budget.
If we would have let the algorithms longer, maybe the setups using the binary operator would have given more saliently better results &hellip; but these would then be useless in our real-world scenario, since we only have 3 minutes of runtime.

By the way: It is very important to *always* test the $cr=0$ rate!
Only by doing this, we can find whether our binary operator is designed properly.
It is a common fallacy to assume that an operator which we have designed to combine good characteristics from different solutions *will actually do that*.
If the algorithm setups with $cr=0$ would be better than those that use the binary operator, it would be a clear indication that we are doing something wrong.
So we need to carefully analyze whether the small improvements that our binary operator can provide are actually *significant*.
We therefore apply the same statistical approach as already used in [@sec:hcTestForSignificance] and later discussed in detail in [@sec:testForSignificance].

\relative.input{jssp_ea_cr_comparison_8192.md}

: The end results of `ea_8192_nswap` and `ea_8192_5%_nswap` compared with a Mann-Whitney U test with Bonferroni correction and significance level&nbsp;$\alpha=0.02$ on the four JSSP instances. The columns indicate the $p$-values and the verdict (`?` for insignificant). {#tbl:jssp_ea_cr_comparison_8192}

In [@tbl:jssp_ea_cr_comparison_8192], we find that that EA using the binary `sequence` operator to generate 5% of the offspring solutions leads to significantly better results on `abz7`.
It never performs significantly worse, not even on `swv15 `, and the $p$-values are below $\alpha$ but above $\alpha'$ on the other two instances.
Overall, this is not a very convincing result.
Not enough for us to claim that our particular recombination operator is a very good invention &ndash; but enough to convince us that using it may sometimes be good and won't hurt too much otherwise.

![The median of the progress of the&nbsp;`ea_8192_5%_nswap`, `ea_8192_nswap`, and&nbsp;`ea_16384_nswap` algorithms over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_ea_cr_nswap_log.svgz}){#fig:jssp_progress_ea_cr_nswap_log width=84%}

If we look at [@fig:jssp_progress_ea_cr_nswap_log], we can confirm that using the binary `sequence` operator at the low 5% rate does make some visible difference in how the median solution quality over time changes.
On `abz7`, it clearly improves faster in the setup with recombination.
On `la24` and `yn4`, there also is a small advantage during the phase when the algorithm improves the fastest.
On `swv15`, the opposite is the case.
In all four scenarios, there is not a huge difference in the end results, but in case of `abz7`, `la24`, and `yn4`, a slight advantage at the end of the runs of 
`ea_8192_5%_nswap` is visible.  

In summary, it seems that using our binary operator is reasonable.
Different from what we may have hoped for (and which would have been very nice for this book&hellip;), it does not improve the results by much.
We could try to design a different recombination operator in the hope to get better results, similar to what we did with the unary operator by moving from `1swap` to `nswap`.
We will not do this here &ndash; the interested reader is invited to do that by herself as an exercise.

As the end of this section, let me point out that binary search operators are a hot and important research topic right now.
On one of the most well-known classical optimization problems, the Traveling Salesman Problem mentioned already back in the introduction in [@sec:intro:logistics], they are part of the most efficient algorithms&nbsp;[@TWO2014GAPCGFTAT;@NK2013APGAUEACFTTSP;@W2016BNMDPCADIM;@SWT2017BABHFTTSPCEACAPC].
It also has theoretically been proven that a binary operator can speed-up optimization on some problems&nbsp;[@DHK2008CCPBUIEC].

### Ingredient: Diversity Preservation

In [@sec:ea:exploration:exploitation], we asked why a population is helpful for optimization.
Our answer was that there are two opposing goals in metaheuristic optimization:
On the one hand, we want to get results *quickly* and, hence, want that the algorithms quickly trace down to the bottom of the basins around optima.
On the other hand, we want to get *good* results, i.e., better local optima, preferably global optima.
A smaller population is good for the former and forsters exploitation.
A larger population is good for the latter, as it invests more time on exploration.

Well.
Not necessarily.
Imagine we discover a good local optimum, a solution better than everything else we have in the population.
Great.
It will survive selection and we will derive offspring solutions from it.
Since it is a local optimum, these will probably be worse.
They might also encode the same solution as the parent, which is entirely possible in our JSSP scenario.
But even if they are worse, they maybe just good enough to survive the next round of selection.
Then, their (better) parent will also survive.
We will thus get more offspring from this parent.
But also offsprings from its surviving offsprings.
And some of these may again be the same as the parent.
If this process keeps continuing, the population may slowly be filling with copies of that very good local optimum.
The larger our population, the longer it will take, of course.
But unless we somehow encounter a different, similarly good or even better solution, it will probably happen eventually.

What does this mean?
Recombination of two identical points in the search space should yield the very same point as output, i.e., the binary operator will become useless.
This would leave only the unary operator as possible source of randomness.
We then practical have one point in the search space to which only the unary operator is applied.
Our EA has become a weird hill climber. 

If we would want that, then we would have implemented a hill climber, i.e., a local search, instead.
In order to enable global exploration and to allow for the binary search operators to work, it makes sense to try to preserve the *diversity* in the population&nbsp;[@S2018TBOPDIEAASORRA].

Now there exist quite a few ideas how to do that&nbsp;[@S2012NIEA; @CLM2013EAEIEAAS; @ST2016DOCAPCASOMFPDIEO].
Many of them are focused on penalizing candidate solutions which are too similar to others in the selection step.
Similarity could be measured via computing the distance in the search space, the distance in the solution space, the difference of the objective values.
The penalty could be achieved by using a so-called *fitness* as basis for selection instead of the objective value.
In our original EA, the fitness would be the same as the objective value.
In a diversity-preserving EA, we could add a penalty value to this base fitness for each solution based on the distance to the other solutions.

### Evolutionary Algorithm with Clearing in the Objective Space

Let us now test whether a diversity preserving strategy can be helpful in an EA.
We will only investigate one very simple approach:
Avoiding objective value duplicates&nbsp;[@S2012NIEA; @FHN2007RAOSDM].
In the rest of this section, we will call this method *clearing*, as it can be viewed as the strictest possible variant of the clearing&nbsp;[@P1996ACPAANMFGA] applied in the objective space.

Put simply, we will ensure that all individuals that "survive" selection have different objective values.
If two good solutions have the same objective value, we will discard one of them.
This way, we will ensure that our population remains diverse.
No single candidate solution can take over the population.  


#### The Algorithm (with Recombination and Clearing)

We can easily extend our $(\mu+\lambda)$&nbsp;EA with recombination from [@sec:evolutionaryAlgorithmWithRecombinationImpl] to remove duplicates of the objective value.
We need to consider that a full population of $\mu+\lambda$ individuals may contain less than $\mu$ different objective values.
Thus, in the selection step, we may obtain $1\leq u \leq \mu$ elements, where $u$ can be different in each generation.
If $u=1$, we cannot apply the binary operator regardless of the crossover rate&nbsp;$cr$.

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.
    b. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
    c. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    d. Sort the array&nbsp;$P$ according to the objective values such that the records&nbsp;$r$ with better associated objective value&nbsp;$\elementOf{r}{\obspel}$ are located at smaller indices. This means that elements with better objective values come first.
    e. Process&nbsp;$P$ from front to end and delete all records with already-visited objective value. The number of remaining records be&nbsp;$w$. Set the number&nbsp;$u$ of selected records to $u=\min\{w,\mu\}$.     
    f. Shuffle the **first&nbsp;$u$** elements of&nbsp;$P$ randomly.
    g. Set the first source index&nbsp;$p=-1$.
    h. For index&nbsp;$i$ ranging **from&nbsp;$u$** to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p$ **to&nbsp;$p=\modulo{(p+1)}{u}$**, i.e., make sure that every one of **the&nbsp;$u$ selected** points is used approximately the same number of times.
        ii. Draw a random number&nbsp;$c$ uniformly distributed in&nbsp;$[0,1)$.
        iii. **If&nbsp;$u>1$** and&nbsp;$c$ is less than the crossover rate&nbsp;$cr$, then we apply the binary operator:
             A. Randomly choose another index&nbsp;$p2$ **from $0\dots(u-1)$** such that&nbsp;$p2\neq p$.
             B. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_2(\elementOf{\arrayIndex{P}{p}}{\sespel}, \elementOf{\arrayIndex{P}{p2}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the binary search operator to the points stored at index&nbsp;$p$ and&nbsp;$p2$.
        iv. else, i.e., $c\geq cr$, then we apply the unary operator:
            C. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_1(\elementOf{\arrayIndex{P}{p}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the unary search operator to the point stored at index&nbsp;$p$.
        v. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
        vi. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.

\repo.listing{lst:EAWithClearing}{An excerpt of the implementation of the Evolutionary Algorithm algorithm with crossover and clearing.}{java}{src/main/java/aitoa/algorithms/EAWithClearing.java}{}{relevant}

This algorithm, implemented in [@lst:EAWithClearing] differs from the variant in [@sec:evolutionaryAlgorithmWithRecombinationImpl] mainly in *step&nbsp;e*.
There, the sorted population&nbsp;$P$ is processed from beginning to end.
Whenever an objective value is found in a record which has already been encountered, the record is removed.
Since $P$ is sorted, this means that the record at (zero-based) index&nbsp;$k$ is deleted if and only if $k>0$ and $\elementOf{\arrayIndex{P}{k}}{\obspel}=\elementOf{\arrayIndex{P}{k-1}}{\obspel}$.
As a result, the number&nbsp;$u$ of records with unique objective value may be less than&nbsp;$\mu$ (while always being greater or equal to&nbsp;1).
Therefore, we need to adjust the parts of the algorithm where parent solutions are selected for generating offsprings.
Also, we generate $\mu+\lambda-u$ offspring, to again obtain a total of $\mu+\lambda$ elements.
All such changes are marked with **bold face** in the pseudo-code above.  

In the actual implementation in [@lst:EAWithClearing], we do not delete the records but move them to the end of the list, so we can re-use them later.
We also stop processing&nbsp;$P$ as soon as we have&nbsp;$\mu$ unique records, as it does not really matter whether un-selected records are unique.
This is slightly more efficient, but would be harder to write in pseudo-code.

We will name setups of this algorithm in the same manner as those of the original EA, except that we start the names with the prefix `eac_` instead of `ea_`.

#### The Right Setup

With the simple diversity-preservation mechanism in place, we may wonder which population sizes are good.
It is easy to see that findings from [@sec:eaNoCrSetup], where we found that $\mu=\lambda=16'384$ is reasonable, may longer hold:
We know from [@sec:jssp:lowerBounds] of the makespan for any solution on the JSSP instance `abz7` is&nbsp;656.
It can be doubted whether it is even possible to generate $16'384$ schedules with different makespans.
If not, then the number&nbsp;$u$ of selected records would always be less than&nbsp;$\mu$, which would make choosing a large&nbsp;$\mu$ useless.

![The median result quality of the&nbsp;`ea[c]_mu_5%_nswap` algorithm, divided by the lower bound $\lowerBound(\objf)^{\star}$ from [@tbl:jsspLowerBoundsTable] over different values of the population size parameter&nbsp;$\mu=\lambda$, with and without clearing. The best values of&nbsp;$\mu$ for each operator and instance are marked with bold symbols.](\relative.path{jssp_eac_med_over_mu.svgz}){#fig:jssp_eac_med_over_mu width=84%}

Since this time smaller population sizes may be interesting, we investigate all powers of&nbsp;2 for $\mu=\lambda$ from&nbsp;4 to&nbsp;65'536.
In [@fig:jssp_eac_med_over_mu], we find that the `eac_mu_5%_nswap` behave entirely different from those of `ea_mu_5%_nswap`.
Interestingly, $\mu=\lambda=4$ seems to be the right choice.
It leads to the best performance on `abz7` and `swv15`, while being only a tiny bit worse than the best choices on `la24` and `yn4`.
This very small population size means that an EA with clearing in the objective space should be configured quite similar to a hill climber!   

#### Results on the JSSP

We can now investigate whether our results have somewhat improved.

\relative.input{jssp_eac_results.md}

: The results of the Evolutionary Algorithm `ea_4_5%_nswap` in comparison to `ea_8192_5%_nswap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_eac_results}

[@tbl:jssp_eac_results] shows that our EA with recombination and clearing in the objective space outperforms the EA without clearing on every single instance in terms of best, mean, and median result quality!

