## Memetic Algorithms: Hybrids of Global and Local Search {#sec:memeticAlgorithms}

Let remember two of the algorithms we have already seen:

1. The hill climbers are local search methods, which can refine and improve one solution quickly but may get stuck at local optima.
2. Evolutionary Algorithms are global optimization methods, which try to preserve a diverse set of solutions and are less likely to end up in local optima, but pay for it by slower optimization speed.

It is a natural idea to combine both types of algorithms, to obtain a hybrid algorithm which unites the best from both worlds.
Such algorithms are today often called *Memetic Algorithms* (MAs)&nbsp;[@M1989MA; @HSK2005RAIMA; @NCM2012HOMA] (sometimes also Lamarkian Evolution&nbsp;[@WGM1994LETBEAFO]).

### Idea: Combining Local Search and Global Search

The idea is as follows:
In an Evolutionary Algorithm, the population guards against premature convergence to a local optimum.
In each generation of the EA, new points in the search space are derived from the ones that have been selected in the previous step.
From the perspective of a single point in the population, each generation of the EA is somewhat similar to one iteration of a hill climber.
However, there are $\mu$&nbsp;points in the surviving population, not just one.
As a result, the overall progress made towards a good solution is much slower compared to the hill climber.

Also, we introduced a binary search operator which combines traits from two points in the population to form a new, hopefully better solution.
The idea is that the points that have survived selection should be good, hence they should include good components, and we hope to combine these.
However, during the early stages of the search, the population contains first random and then slightly refined points (see above).
They will not contain many good components yet.

Memetic Algorithms try to mitigate both issues with one simple idea:
Let each new point, before it enters the population, become the starting point of a local search.
The result of this local search then enters the population instead.

### Algorithm: EA Hybridized with Neighborhood-Enumerating Hill Climber

We could choose any type of local search for this purpose, but here we will use the iterative neighborhood enumeration as done by our revisited hill climber in [@sec:hillClimbing2Algo].
As a result, the first generation of the MA behaves exactly the same as our neighborhood-iterating hill climber with restarts (until it has done $\mu+\lambda$ restarts).
The inputs of the binary search operator will then not just be selected points, they will be local optima (with respect to the neighborhood spanned by the unary operator). 

In the reproduction phase, an Evolutionary Algorithm applies either a unary or a binary operator.
In an MA, it obviously makes no sense to use the same unary operator as in the local search here.
We could therefore either use an unary operator that always makes different moves or only use the binary search operator.
Here, we will follow the latter choice, simply to spare us the necessity to define yet another operator here (`nswap` would not be suitable, as it most often does single swaps like `1swap`.)

The basic $(\mu+\lambda)$&nbsp;Memetic Algorithm is given below and implemented in [@lst:MA].

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ of instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Create a random point from the search space using the nullary search operator and store it in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.  
4. Repeat until the termination criterion is met:
		b. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
		   i. If $\arrayIndex{P}{i}$ is already a fully-evaluated solution and a local optimum, continue with the next iteration value of the *loop&nbsp;4b*.
			 i.  Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
       ii Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.       
       iii. *Local Search:* For each point&nbsp;$\sespel'$ in the search space neighboring to $\elementOf{\arrayIndex{P}{i}}{\sespel}$ according to the unary search operator do:
            A. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
            B. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
            C. If the termination criterion has been met, jump directly to step&nbsp;5.
            D. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\sespel'$&nbsp;in&nbsp;&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}$, store&nbsp;$\obspel'$&nbsp;in&nbsp;$\elementOf{\arrayIndex{P}{i}}{\obspel}$, stop the enumeration, and go back to *step&nbsp;4b.iii*.    
    c. Sort the array&nbsp;$P$ in ascending order according to the objective values, i.e., such that the records&nbsp;$r$ with better associated objective value&nbsp;$\elementOf{r}{\obspel}$ are located at smaller indices.
    d. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    e. Set the first source index&nbsp;$p1=-1$.
    f. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        iv. Set the first source index&nbsp;$p1$ to&nbsp;$p1=\modulo{(p1+1)}{\mu}$.
        v. Randomly choose another index&nbsp;$p2$ from $0\dots(\mu-1)$ such that&nbsp;$p2\neq p$.
        vi. Apply binary search operator to the points stored at index&nbsp;$p1$ and&nbsp;$p2$ and store result at index&nbsp;$i$, i.e., set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_2(\elementOf{\arrayIndex{P}{p1}}{\sespel}, \elementOf{\arrayIndex{P}{p2}}{\sespel})$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.

The condition in *step&nbsp;4b.i* allows that in the first iteration, all members of the population are refined by local search, whereas in the latter steps, only the&nbsp;$\lambda$ new offsprings are refined.
This makes sense because the&nbsp;$\mu$ parents have already been subject to local search and are local optima.
Trying to refine them again would just lead to one useless enumeration of the entire neighborhood during which no improvement could be found.

\repo.listing{lst:MA}{An excerpt of the implementation of the Memetic Algorithm algorithm.}{java}{src/main/java/aitoa/algorithms/MA.java}{}{relevant}

### The Right Setup

We can now evaluate the performance of our Memetic Algorithm variant.
As unary operator with enumerable neighborhood, we use the `1swapU` operator.
As binary search operator, we apply the `sequence` crossover operator defined in [@sec:ea:sequence:crossover] for the EA.

Since we always apply this operator in the reproduction step of our MA (i.e., $cr=1$), the only parameter we need to worry about is the population size.
While a large population size was good for EAs, we need to remember that our budget is limited to 180&nbsp;seconds and that every individual in the population will be refined using the `hc2r_1swapU`-style local search.
This means that the limit for the total population size $\mu+\lambda$ would be the number of restarts that `hc2r_1swapU` can make within three minutes.
Any larger size would mean that the first generation would not be completed.

\relative.input{jssp_hc2_convergence.md}

: The median runtime that the neighborhood-enumerating hill climber would consume *without* restarts, i.e., the median time until arriving in a local optimum, as well as how many restarts we could do within our three-minute budget. {#tbl:jssp_hc2_convergence}

In [@tbl:jssp_hc2_convergence], we apply `hc2r_1swapU`, but instead of restarting, we terminate the algorithm when it has arrived in a local optimum.
We find that it needs between 47&nbsp;ms (on&nbsp;`la24`) and 1'729&nbsp;ms (on&nbsp;`swv15`) to do so.
This means that within the 180&nbsp;s, we can refine between 3'830 and 104 individuals with the local search.
If we want to be able to do several generations of the MA, then $\mu+\lambda \ll 104$.

I did some small, preliminary experiments where I found that a population size of $\mu=\lambda=8$ works well for our three minute budget on all instances except&nbsp;`swv15`.
We will call this setup `ma_8_1swapU` and investigate it in the following text.

### Results on the JSSP

\relative.input{jssp_ma_results.md}

: The results of the Memetic Algorithm `ma_8_1swapU` in comparison to the two EAs `ea_8192_5%_nswap` and `eac_4_5%_nswap` as well as the hill climber `hc2r_1swapU`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_ma_results}

\relative.input{jssp_ma_comparison.md}

: A statistical comparison of the end results of `ma_8_1swapU`, `ea_8192_5%_nswap`, and `hc2r_1swapU`, using the Mann-Whitney U test with Bonferroni correction and significance level&nbsp;$\alpha=0.02$ on the four JSSP instances. The columns indicate the $p$-values and the verdict (`?` for insignificant). {#tbl:jssp_ma_comparison}

In [@tbl:jssp_ma_results], we find that `ma_8_1swapU` performs clearly better than the plain EA and the hill climber on all four instances, which is confirmed by a statistical test in [@tbl:jssp_ma_comparison].
Except on `swv15`, it also always has the best mean and median result quality.
The differences to `eac_4_5%_nswap` are very small and therefore not interesting &ndash; except on `swv15`, where the Memetic Algorithm clearly loses.
This must be the result of the very low number of individuals that can be refined on `swv15` using the local search within the three minute budget.

![The median of the progress of the&nbsp;`ma_8_1swapU`, `eac_4_5%_nswap`, and `hc2r_1swapU` algorithms over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_ma_log.svgz}){#fig:jssp_progress_ma_log width=84%}

From [@fig:jssp_progress_ma_log], we can see that the `ma_8_1swapU` behaves almost identical to `hc2r_1swapU` during the first approximately ten seconds of the runs.
This must be the time when the first $\mu+\lambda$ individuals undergo the local search.
From then on, the algorithm makes better progress than `hc2r_1swapU`.
It seems that our binary `sequence` operator can combine different good traits of candidate solutions after all!
The fact that the `ma_8_1swapU` can improve beyond the hill climber means that `sequence` is able to combine two local optima to a new point in the search space, which then can be refined by local search to another local optimum.

### Summary

With Memetic Algorithms, we learned about a family of hybrid optimization methods that combine local and global search.
Of course, here we just scratched the surface of this concept.

For example, we again only considered one simple implementation of this idea.
Instead of `hc2r`-style local search, we could as well have used our stochastic hill climber or even Simulated Annealing for a fixed number of iterations as refinement procedure.
Indeed, instead of doing a full local search until reaching a local optimum, we could also limit it to only a fixed number&nbsp;$S$ of steps (and indeed the Java implementation [@lst:MA] has this feature).

Our MA did neither outperformed the EA with clearing nor Simulated Annealing.  
Regarding the former, we could also apply clearing in the MA.
I actually tried that, but it did not really lead to a big improvement in my preliminary experiments, so I did not discuss it here.
The reason is most likely that the MA performs too few generations for it to really kick in.

The computational budget of only three minutes may have prevented us from finding better results.
If we had a larger budget, we could have used a larger population.
In a different application scenario, the comparison of an MA with the EA with clearing and SA algorithms might have turned out more favorable.
On the plus side, the MA did perform significantly better than a pure EA with recombination and than the neighborhood-enumerating hill climber &nbsp; the two algorithms it is composed of!
