## Evolutionary Algorithm {#sec:evolutionaryAlgorithm}

We now already have one more or less functional, basic optimization method &ndash; the hill climber.
Different from the random sampling approach, it makes use of some knowledge gathered during the optimization process, namely the best-so-far point in the search space.
However, only using this point led to the danger of premature convergence, which we tried to battle with two approaches, namely restarts and the search operator `nswap` spanning a larger neighborhood from which we sampled in a non-uniform way.
These concepts can be transfered rather easily to may different kinds of optimization problems.
Now we will look at a third concept to prevent premature convergence: Instead of just remembering and utilizing one single point from the search space during our search, we will work on an array of points!

### Evolutionary Algorithm without Recombination {#sec:evolutionaryAlgorithmWithoutRecombination}

Today, there exists a wide variant of [Evolutionary Algorithms](http://en.wikipedia.org/wiki/Evolutionary_algorithm) (EAs)&nbsp;[@WGOEB; @BFM1997EA; @G1989GA; @DJ2006ECAUA; @M1996GADSEP; @M1998GA; @CWM2012VOEAFRWA; @S2003ITSSAO].
We will begin with a very simple, yet efficient variant: the $(\mu+\lambda)$&nbsp;EA without recombination.[^EA:no:recombination]
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
    d. Sort the array&nbsp;$P$ according to the objective values such that the records with better associated objective value&nbsp;$\obspel$ are located at smaller indices. For minimization problems, this means elements with smaller objective values come first.
    e. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    f. Set the first source index&nbsp;$p=-1$.
    g. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p$ to&nbsp;$p=\modulo{(p+1)}{\mu}$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
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

\text.block{definition}{selectionEA}{The *selection* step in an Evolutionary Algorithm picks the set of points in the search space from which new points should be derived. This usually involves choosing a smaller number&nbsp;$\mu\in\naturalNumbersO$ of points from a larger array&nbsp;$P$.&nbsp;[@WGOEB; @BT1995ACOSSUIGA; @CDC1996AOSAAMCA; @BFM1997EA; @M1998GA]}

*Selection* can be done by sorting the array&nbsp;$P$ (*point&nbsp;d*).
This way, the best&nbsp;$\mu$ solutions end up at the front of the array on the indices from&nbsp;$0$ to&nbsp;$\mu-1$.
The worse&nbsp;$\lambda$ solutions are at index&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$.
These are overwritten by sampling points from the neighborhood of the&nbsp;$\mu$ selected solutions by applying the unary search operator (which, in the context of EAs, is often called *mutation* operator).

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
Here, let us just set&nbsp;$\mu=\lambda$ and test the values 16, 32, 64, 512, 2048, and 4096.
We find that the two fairly large values 2048 and 4096 give the best results, so we will focus on them.
We will call the corresponding setups `ea2048` and `ea4096`, respectively.
As unary search operators, we test again `1swap` and `nswap`.
The results are given in [@tbl:eaNoCrHCJSSP], together with those of our best hill climber with restarts `hcr_256+5%_nswap`.

|$\instance$|$\lowerBound(\objf)$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hcr_256+5%_nswap`|707|733|734|**7**|64s|17'293'038|
|||`ea2048_1swap`|695|719|718|13|**11**s|2'581'614|
|||`ea2048_nswap`|694|714|714|12|18s|4'271'587|
|||`ea4096_1swap`|**688**|716|716|12|19s|4'416'129|
|||`ea4096_nswap`|692|**711**|**710**|10|34s|7'888'233|
|`la24`|935|`hcr_256+5%_nswap`|945|981|984|**9**|57s|29'246'097|
|||`ea2048_1swap`|945|983|983|16|**2**s|927'000|
|||`ea2048_nswap`|943|980|984|15|3s|1'329'883|
|||`ea4096_1swap`|941|980|978|14|5s|1'897'387|
|||`ea4096_nswap`|**938**|**976**|**975**|13|6s|2'512'530|
|`swv15`|2885|`hcr_256+5%_nswap`|3645|3804|3811|**44**|**91**s|14'907'737|
|||`ea2048_1swap`|3395|3535|3530|78|128s|19'290'521|
|||`ea2048_nswap`|**3374**|**3521**|**3517**|70|157s|22'976'339|
|||`ea4096_1swap`|3397|3533|3533|54|171s|25'073'630|
|||`ea4096_nswap`|3421|3543|3539|46|178s|25'678'144|
|`yn4`|929|`hcr_256+5%_nswap`|1081|1117|1119|**14**|55s|11'299'461|
|||`ea2048_1swap`|1032|1082|1082|22|**26**s|4'792'622|
|||`ea2048_nswap`|1034|1074|1073|19|41s|7'514'890|
|||`ea4096_1swap`|**1020**|1076|1074|21|39s|6'907'692|
|||`ea4096_nswap`|1034|**1068**|**1067**|18|56s|9'976'531|

: The results of the Evolutionary Algorithms without crossover in comparison to the best hill climber with restarts setup `hcr_256+5%_nswap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:eaNoCrHCJSSP}

[@tbl:eaNoCrHCJSSP] shows us that we can improve the best, mean, and median solution quality that we can get within three minutes of runtime by at least three percent when using our EA setups instead of the hill climber.
The exception is case `la24`, where the hill climber already came close to the lower bound of the makespan.
Here, the best solution encountered now has a makespan which is only 0.3% longer than what is theoretically possible.
Nevertheless, we find quite a tangible improvement in case `swv15`.

The bigger setting 4096 for&nbsp;$\mu$ and&nbsp;$\lambda$ tends to work better, except for instance&nbsp;`swv15`, where 2048 gives us better results.
It is quite common in optimization that different problem instances may require different setups to achieve the best performance.
The`nswap` operator again works better than `1swap`.

The Gantt charts of the median solutions of `ea4096_nswap` are illustrated in [@fig:jssp_gantt_ea4096_nswap_med].
More interesting are the progress diagrams of `ea4096_nswap`, `ea2048_nswap`, and&nbsp;`hcr_256+5%_nswap` in [@fig:jssp_progress_ea_nocr_hc_log].
Here we find big visual differences between the way the EAs and hill climbers proceed.
The EAs spend the first 100ms to discover some basins of attraction of local optima before speeding up.
The larger the population, the longer it takes them until this happens.
It is interesting to notice that the two problems where the EAs visually outperform the hill climber the most, `swv15` and `yn4`, are also those with the largest search spaces (see [@tbl:jsspSearchSpaceTable]).
`la24`, however, which already can "almost be solved" by the hill climber and where there are the smallest differences in perfomance, is the smallest instance.
The population used by the EA seemingly guards against premature convergence and allows it to keep progressing for a longer time.

![The Gantt charts of the median solutions obtained by the&nbsp;`ea4096_nswap` setup. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_ea4096_nswap_med.svgz}){#fig:jssp_gantt_ea4096_nswap_med width=84%}

![The progress of the&nbsp;`ea4096_nswap`, `ea2048_nswap`, and&nbsp;`hcr_256+5%_nswap` algorithms over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_ea_nocr_hc_log.svgz}){#fig:jssp_progress_ea_nocr_hc_log width=84%}

#### Exploration versus Exploitation {#sec:ea:exploration:exploitation}

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

### Ingredient: Binary Search Operator

On one hand, keeping a population of the&nbsp;$\mu>1$ best solutions as starting points for further exploration helps us to avoid premature convergence.
On the other hand, it also represents more *information*.
The hill climber only used the information in current-best solution as guide for the search (and the hill climber with restarts used, additionally, the number of steps performed since the last improvement).
Now we have a set of&nbsp;$\mu$ selected points from the search space.
These points have, well, been selected.
At least after some time has passed in our optimization process, "being selected" means "being good".
If you compare the Gantt charts of the median solutions of `ea4096_nswap` ([@fig:jssp_gantt_ea4096_nswap_med]) and `hcr_256+5%_nswap` ([@fig:jssp_gantt_hcr_256_5_1swap_med]), you can see some good solutions, which, however, do differ in some details.
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

This can be implemented efficiently keeping indices of the first unmarked element for both&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$, which we do in&nbsp;[@lst:JSSPBinaryOperatorSequence].

\repo.listing{lst:JSSPBinaryOperatorSequence}{An excerpt of the `sequence` recombination operator for the JSSP, an implementation of the binary search operation interface [@lst:IBinarySearchOperator].}{java}{src/main/java/aitoa/examples/jssp/JSSPBinaryOperatorSequence.java}{}{relevant}

As we discussed in [@sec:jsspSearchSpace], our representation mapping processes the elements&nbsp;$\sespel\in\searchSpace$ from the front to the back and assigns the job to machines according to the order in which their IDs appear.
Our binary operator works in a similar way, but it processes *two* points from the search space&nbsp;${\sespel}1$ and&nbsp;${\sespel}2$ from their beginning to the end.
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

We can now utilize this new operator in our EA, which therefore needs to be modified a bit.

#### The Algorithm (with Recombination)

We introduce a new paramter&nbsp;$cr\in[0,1]$, the so-called "crossover rate".
It is used whenever we want to derive a new points in the search space from existing ones.
It denotes the probability that we apply the binary operator (while we will apply the unary operator with probability&nbsp;$1-cr$).
The basic $(\mu+\lambda)$&nbsp;Evolutionary Algorithm with recombination works as follows:

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

This algorithm, implemented in [@lst:EAwithCrossover] only differs from the version in [@sec:evolutionaryAlgorithmWithoutRecombinationAlgo] by choosing whether to use the unary or binary operator to sample new points from the search space (*steps&nbsp;A*, *B*, and&nbsp;*C*).
If&nbsp;$cr$ is the probability to apply the binary operator and we draw a random number&nbsp;$c$ which is uniformly distributed in&nbsp;$[0,1)$, then the probability that $c<cr$ is exactly&nbsp;$cr$ (see *point&nbsp;iii*).

#### Results on the JSSP

We now apply the new algorithm with our binary `sequence` operator to the JSSP.
As unary operator, we only apply `nswap` and for&nbsp;$\mu$ and&nbsp;$\lambda$, we again provide results for the values 2048 and 4096.
As crossover rates&nbsp;$cr$, we use&nbsp;0, 0.05, and&nbsp;0.3.
A crossover rate of&nbsp;0 is exactly equivalent to not applying the binary operator at all, that is, to our EAs from [@sec:evolutionaryAlgorithmWithoutRecombination].
For the non-zero crossover rates, we append $cr*100$ to the setup name, i.e., `ea2048_nswap_30` stands for an $(2048+2048)$&nbsp;EA with the `nswap` unary operator which applies the binary `sequence` operator at a crossover rate (=probability) of 0.3.

|$\instance$|$\lowerBound(\objf)$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`ea2048_nswap`|694|714|714|12|**18**s|4'271'587|
|||`ea2048_nswap_5`|691|710|709|9|19s|4'105'841|
|||`ea2048_nswap_30`|689|710|710|9|24s|3'228'294|
|||`ea4096_nswap`|692|711|710|10|34s|7'888'233|
|||`ea4096_nswap_5`|**685**|**706**|**706**|10|29s|5'933'332|
|||`ea4096_nswap_30`|691|708|**706**|**8**|29s|3'675'335|
|`la24`|935|`ea2048_nswap`|943|980|984|15|**3**s|1'329'883|
|||`ea2048_nswap_5`|941|975|975|15|4s|1'638'907|
|||`ea2048_nswap_30`|946|978|979|**11**|5s|1'214'869|
|||`ea4096_nswap`|**938**|976|975|13|6s|2'512'530|
|||`ea4096_nswap_5`|941|**974**|**971**|13|6s|2'277'833|
|||`ea4096_nswap_30`|947|975|975|12|14s|3'308'665|
|`swv15`|2885|`ea2048_nswap`|3374|**3521**|**3517**|70|157s|22'976'339|
|||`ea2048_nswap_5`|**3372**|3531|3527|70|142s|18'919'277|
|||`ea2048_nswap_30`|3454|3595|3589|69|**119**s|11'980'325|
|||`ea4096_nswap`|3421|3543|3539|**46**|178s|2'567'8144|
|||`ea4096_nswap_5`|3440|3543|3537|51|177s|22'603'785|
|||`ea4096_nswap_30`|3458|3595|3599|63|176s|16'530'328|
|`yn4`|929|`ea2048_nswap`|1034|1074|1073|19|41s|7'514'890|
|||`ea2048_nswap_5`|1027|1067|1066|19|34s|5'523'450|
|||`ea2048_nswap_30`|1035|1070|1069|18|**31**s|3'116'408|
|||`ea4096_nswap`|1034|1068|1067|18|56s|9'976'531|
|||`ea4096_nswap_5`|**1017**|**1058**|**1058**|18|52s|8'248'627|
|||`ea4096_nswap_30`|1030|1061|1060|**17**|50s|4'828'673|

: The results of the Evolutionary Algorithms with crossover rates $0$, $0.05$, and $0.3$. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:eaCrHCJSSP}

The results in [@tbl:eaCrHCJSSP] show that a moderate crossover rate of 0.05 can indeed improve our algorithm's performance &ndash; a little bit.
Only for the JSSP instance `swv15`, setup `ea2048_nswap` without crossover remains best.
Here, the reason is probably hidden in the late median last improvement times, which are already at 157s and 178s for the two algorithm variants with $cr=0$.
Since the total budget is only 180s, there might just not be enough time for any potential benefits of the binary operator to kick in.
This could also be a valuable lesson: it does not help if the algorithm gives better results if it needs too much time.
Any statement about an achieved result quality is only valid if it also contains a statement about the required computational budget.
If we would have let the algorithms longer, maybe the setups using the binary operator would have given more saliently better results &hellip; but these would then be useless in our real-world scenario, since we only have 3 minutes of runtime.  

By the way: It is very important to *always* test the $cr=0$ rate!
Only by doing this, we can find whether our binary operator is designed properly.
It is a common fallacy to assume that an operator which we have designed to combine good characteristics from different solutions *will actually do that*.
If the algorithm setups with $cr=0$ would be better than those that use the binary operator, it is a clear indication that we are doing something wrong.
So we need to carefully analyze whether the small improvements that our binary operator can provide are actually *significant*.

![The Gantt charts of the median solutions obtained by the&nbsp;`ea4096_nswap_5` setup. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_ea4096_nswap_5_med.svgz}){#fig:jssp_gantt_ea4096_nswap_5_med width=84%}

![The progress of the&nbsp;`ea4096_nswap` setup without binary operator compared to those of `ea4096_nswap_5` and&nbsp;`ea4096_nswap_30`, which apply the binary operator in 5% and 30% of the reproduction steps, over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_ea_cr_log.svgz}){#fig:jssp_progress_ea_cr_log width=84%}

Indeed, if we look at the progress of the setups `ea4096_nswap`, `ea4096_nswap_5`, and `ea4096_nswap_30` over time (illustrated in [@fig:jssp_progress_ea_cr_log]), we find that they look quite similar.
Also the schedules of median quality obtained by `ea4096_nswap_5` and plotted in [@fig:jssp_gantt_ea4096_nswap_5_med] do not look very different from those of `ea4096_nswap` shown in [@fig:jssp_gantt_ea4096_nswap_med].
Of course, applying an operator only 5% of the time, which here seems to be the better choice, will probably not change the algorithm behavior very much.
Furthermore, in instance `la24`, we are already very close to lower bound defining the best possible solution quality that can theoretically be reached.

### Testing for Significance {#sec:eaTestForSignificance}

All in all, the changes in both [@tbl:eaCrHCJSSP] and [@fig:jssp_progress_ea_cr_log] achieved by introducing recombination in the EA seem to not be very big.
This could either mean that they are an artifact of the randomness in the algorithm *or*, well, that there are improvements but they are small.

In order to understand the first situation, consider the following thought experiment.
Assume you have a completely unbiased, uniform source of true random real numbers from the interval $[0,1)$.
You draw 500 such numbers, i.e., have a list&nbsp;$A$ containing 500 numbers, each from $[0,1)$.
Now you repeat the experiment and get a list&nbsp;$B$.
Since the numbers stem from a random source, we can expect that $A\neq B$.
If we compute the medians&nbsp;$A$ and&nbsp;$B$, they are likely to be different as well.
Actually, I just did exactly this in the `R` programming language and got `median(A)=0.5101432` and `median(B)=0.5329007`.
Does this mean that the generator producing the numbers in&nbsp;$A$ creates somehow smaller numbers than the generator from which the numbers in&nbsp;$B$ stem?
Obviously not, because we sampled the numbers from the same source.
Also, every time I would repeat this experiment, I would get different results.

Now, our EAs are randomized as well.
On `yn4`, setup `ea4096_nswap_5` has a median end result quality of 1058, while `ea4096_nswap` (without binary operator) achieves 1067, a difference of 0.8%.
If our binary operator would have no impact whatsoever, we could theoretically still this results or any other from [@tbl:eaCrHCJSSP], just because of the randomness in the algorithms.
It is simply not possible to decide, without further investigation, whether results and algorithm behaviors that overlap as much as those in [@fig:jssp_progress_ea_cr_log] are actually different or not.
The "further investigation" which allows us to make this decision is called [significance test](http://en.wikipedia.org/wiki/Statistical_hypothesis_testing) and it is discussed in-depth in [@sec:testForSignificance] as part of our investigation on how to compare algorithms.

In order to see whether two different setups also behave differently, we compare their two sets of 101 end results on each of the problem instances.
For this purpose, we use the [Mann-Whitney U test](http://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test)), as prescribed in [@sec:nonParametricTests] and compare the end results of the two setups `ea4096_nswap` and `ea4096_nswap_5`:

| &nbsp;
| On instance `abz7`, we obtain 0.0016 as $p$-value.
| On instance `la24`, we obtain 0.3275 as $p$-value.
| On instance `swv15`, we obtain 0.8757 as $p$-value.
| On instance `yn4`, we obtain 0.0002 as $p$-value.
| &nbsp;

The $p$-value can roughly be interpreted as the probability of observing the differences that we saw if the two algorithms would produce similar results.
We obtain two very small $p$-values on `abz7` and `yn4`.
There, it would thus be unlikely to see the different outcomes that we saw under the assumption that the binary operator is not useful.
This means we can instead conclude that our binary operator `sequence` instead leads to real, significant improvements on these instances.
The $p$-values bigger than 0.3 on the other two instances indicate that it does probably not make an actual difference there, so while our operator does certain not improve the results on `swv15`, from a statistical point of view, it also does not make them significantly worse.

In summary, although it was not as beneficial as one would have hoped, using the binary operator can be considered as helpful in our case.
Of course, we just tested *one* binary operator on only *four* problem instances &ndash; in any application scenario, we would do more experiments with more settings.
