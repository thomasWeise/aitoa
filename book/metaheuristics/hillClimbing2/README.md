## Hill Climbing Revisited {#sec:hillClimbing2}

Until now, we have entirely relied on randomness to produce new points in the search space.
The results of our nullary, unary, and binary operators are all random.
In case of the unary and binary operator, they of course depend on the input points in the search space fed to the operators, but still, the results are unpredictable and random.
This is, in general, not a bad property.
In the absence of knowledge about what is best, doing an arbitrary thing might have a better expected outcome than doing a fixed, pre-determined thing.

However, it also has some drawbacks.
For example, there is no guarantee to not test the same `1swap` move several times in the `hc_1swap` algorithm.
In our hill climber, we never know whether or when we have tested the complete neighborhood around the current best point&nbsp;$\sespel$ in the search space.
Thus, we also never know whether&nbsp;$\sespel$ is a (local) optimum or not.
We instead need to guess this and in [@sec:stochasticHillClimbingWithRestarts] we therefore design an algorithm that restarts if it did not encounter an improvement for a certain number&nbsp;$L$ of steps.
Thus, the restart might be too early, as there may still be undiscovered solutions in the neighborhood of&nbsp;$\sespel$.
It also might happen too late and we may have already investigated the complete neighborhood several times.

Let us take one step back, to the simple hill climber and the original unary search operator `1swap` for the JSSP from [@sec:hillClimbingJssp1Swap].
This operator tries to perform a single swap, i.e., exchange the order of two job IDs in a point from the search space.
We already discussed in [@sec:hillClimbingWithDifferentUnaryOperator] that the size of this neighborhood is&nbsp;$0.5*\jsspMachines^2*\jsspJobs*(\jsspJobs-1)$ for each point in the search space.

### Idea: Enumerating Neighborhoods {#sec:hc2EnumNeighbors}

Instead of randomly sampling elements from this neighborhood, we could simple iteratively and exhaustively enumerate over them.
As soon as we encounter an improvement, we can stop and accept the better point.
If we have finished enumerating all possible `1swap` neighbors and none of them corresponds to a candidate solution with better objective value (e.g., a Gantt chart with shorter makespan), we *know* that we have arrived in a local optimum.
This way, we do no longer need to *guess* if we have converged or not, we know it directly.
Also, as detailed in [@sec:appendix:jssp:1swapProb], we should be able to find an improving move faster in average, because we will never redundantly sample the same point in the search space again when investigating the neighborhood of the current best solution.

Implementing this concept is a little bit more complicated than creating the simple unary operator that just returns one single new point in the search space as a result.
Instead, such an enumerating unary operator for a black-box metaheuristic may create any number of points.
Moreover, if one of the new points already maps to a candidate solutions which can improve upon the current best solution, then maybe we wish to terminate the enumeration process at that point.

Such behavior can be realized by following a visitor design pattern.
An enumerating unary operator will receive a point&nbsp;$\sespel$ in the search space and a call-back function from the optimization process.
Every time it creates a neighbor&nbsp;$\sespel'$ of&nbsp;$\sespel$, it will invoke the call-back function and pass&nbsp;$\sespel'$ to it.
If the function returns, say `true`, then the enumeration will be terminated, while it is continued for `false`.

The call-back function could internally apply the representation mapping&nbsp;$\repMap$ to&nbsp;$\sespel'$ and compute the objective value&nbsp;$\objf(\solspel')$ of the resulting candidate solution&nbsp;$\solspel'=\repMap(\sespel')$.
If that solution is better than what we get for&nbsp;$\sespel$, the call-back function could store it and return `true`.
This would stop the enumeration process and would return the control back to the main loop of the optimization algorithm.
Otherwise, the call-back function would return `false` and be fed with the next neighbor, until the neighborhood was exhaustively enumerated. 

This idea can be implemented by extending our original interface `IUnarySearchOperator` for unary search operations given in [@lst:IUnarySearchOperator]. 

\repo.listing{lst:IUnarySearchOperatorEnum}{A the generic interface for unary search operators, now able to enumerate neighborhoods.}{java}{src/main/java/aitoa/structure/IUnarySearchOperator.java}{}{relevant,enumerate}

The extension, presented in [@lst:IUnarySearchOperatorEnum], is a single new function, `enumerate`, which should realize the neighborhood enumeration.
This function receives an existing point&nbsp;`x`in the search space as input, as well as a destination data structure&nbsp;`dest` where, iteratively, the neighboring points of&nbsp;`x` should be stored.
Additionally, a call-back function&nbsp;`visitor` is provided as implementation of the Java&nbsp;8-interface [`Predicate`](http://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html).
The [`test` function](http://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html#test-T-) of this interface will, upon each call, receive the next neighbor of `x` (stored in `dest`).
It returns `true` when the enumeration should be stopped (maybe because a better solution was discovered) and `false` to continue. 
`enumerate` itself will return `true` if and only if `test` ever returned `true` and `false` otherwise.

Of course, we cannot implement a neighborhood enumeration for all possible unary operators:
In the case of the `nswap`, operator, for instance, all other points in the search space could potentially be reached from the current one.
Enumerating this neighborhood would include the complete search space and would take way too long.
Hence, the [`default`](http://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html) implementation of the new method should just create an error.
It will only be overwritten by operators with a neighborhood sufficiently small for efficient enumeration.
A reasonable limit is neighborhood whose size grows quadratically with the problem scale or at most with the third power of the problem scale.

### Ingredient: Neighborhood Enumerating `1swap` Operators for the JSSP {#sec:hillClimbingJssp1SwapEnum}

Let us now consider how such an exhaustive enumeration of the neighborhood spanned by the `1swap` operator can be implemented.

#### Enumerating in Deterministic Order

The easiest idea is to just enumerate all index pairs&nbsp;$(i,j)$.
If the jobs at two indices&nbsp;$i$ and&nbsp;$j$ are different, we swap them, invoke the call-back function, then swap them back to the original order.
Since swapping jobs at indices&nbsp;$i=j$ makes no sense and swapping the jobs at indices&nbsp;$(i,j)$ is the same as swapping at indices&nbsp;$(j,i)$, we only need to investigate $\jsspMachines*\jsspJobs*(\jsspMachines*\jsspJobs-1)/2$ pairs. 

1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. For index $i$ from $1$ to $\jsspMachines*\jsspJobs-1$ do:
    a. Store the job at index $i$ in $\sespel'$ in variable $job_i$. 
		b. For index $j$ from $0$ to $i-1$ do:
		   i. Store the job at index $j$ in $\sespel'$ in variable $job_j$.
		   ii. If $job_i\neq job_j$ then:
		       A. Store $job_i$ at index $j$ in $\sespel'$.
		       B. Store $job_j$ at index $i$ in $\sespel'$.
		       C. Pass $\sespel'$ to a call-back function of the optimization process.
		          If the function indicates that it wishes to terminate the enumeration, then quit.
		          Otherwise continue with the next step.
		       D. Store $job_i$ at index $i$ in $\sespel'$.
		       E. Store $job_j$ at index $j$ in $\sespel'$.

This simple algorithm is implemented in [@lst:JSSPUnaryOperator1SwapEnum], which only shows the new function that was added to our class `JSSPUnaryOperator1Swap` that we had already back in [@sec:hillClimbingJssp1Swap].

\repo.listing{lst:JSSPUnaryOperator1SwapEnum}{An excerpt of the `1swap` operator for the JSSP, namely the implementation of the `enumerate` function from the interface `IUnarySearchOpertor`&nbsp;([@lst:IUnarySearchOperatorEnum]).}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1Swap.java}{}{enumerate}

#### Random Enumeration Order

Our enumerating `1swap` operator has one drawback:
The order in which it processes the indices is always the same.
We always check swapping jobs at the lower indices first.
Swap moves involving two jobs near the end of the arrays&nbsp;$\sespel$ are only checked if all other moves closer to the beginning have been checked.
This introduces a bias in the way we search.
We should remember an old concept in metaheuristic optimization:
If you do not know the best choice out of several options, pick a random one.
In other words, we now design an operator `1swapU` which enumerates the same neighborhood as `1swap`, but does so in a random order.

0. Let $S$ be the list of all index pairs&nbsp;$(i,j)$ with $0<i<\jsspMachines*\jsspJobs$ and $0\leq j<i$. It has the length&nbsp;$|S|=(\jsspMachines*\jsspJobs)(\jsspMachines*\jsspJobs-1)/2$.
1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. For index&nbsp;$u$ from&nbsp;$0$ to&nbsp;$|S|-1$ do:
    a. Choose an index&nbsp;$v$ from&nbsp;$u\dots|S|-1$ uniform at random.
    b. Swap the index pairs at indices&nbsp;$u$ and&nbsp;$v$ in&nbsp;$S$.
    c. Pick index pair $(i,j)=S[u]$.
    d. Store the job at index $i$ in $\sespel'$ in variable $job_i$.
    e. Store the job at index $j$ in $\sespel'$ in variable $job_j$.
    f. If $job_i\neq job_j$ then:
        i. Store $job_i$ at index $j$ in $\sespel'$.
        ii. Store $job_j$ at index $i$ in $\sespel'$.
        iii. Pass $\sespel'$ to a call-back function of the optimization process.
             If the function indicates that it wishes to terminate the enumeration, then quit.
             Otherwise continue with the next step.
        iv. Store $job_i$ at index $i$ in $\sespel'$.
        v. Store $job_j$ at index $j$ in $\sespel'$.

If this routine completes, then the lines&nbsp;*2a* and&nbsp;*2b* together will have performed a Fisher-Yates shuffle&nbsp;[@FY1948STFBAAMR; @K1969SA].
By always randomly choosing an index pair&nbsp;$(i,j)$ from the not-yet-chosen ones, it will enumerate the complete `1swap` neighborhood in a uniformly random fashion.
It should be noted that accessing the elements of&nbsp;$\sespel'$ in a random in comparison to deterministic order might incur some performance loss due to not being very cache-friendly.
Whether or not it can in turn provide a larger gain in terms of search efficiency remains to be seen.
We will refer to this algorithm as&nbsp;`1swapU` and implement it in&nbsp;[@lst:JSSPUnaryOperator1SwapU].

\repo.listing{lst:JSSPUnaryOperator1SwapU}{An excerpt of the `1swapU` operator for the JSSP, namely the random-order implementation of the `enumerate` function from the interface `IUnarySearchOpertor`&nbsp;([@lst:IUnarySearchOperatorEnum]).}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1SwapU.java}{}{enumerate}

### The Algorithm (with Restarts) {#sec:hillClimbing2Algo}

We can now design a new variant of the hill climber which enumerates the neighborhood of the current best point&nbsp;$\bestSoFar{\obspel}$ from the search space spanned by a unary operator.
As soon as it discovers an improvement with respect to the objective function, the new, better point replaces&nbsp;$\bestSoFar{\obspel}$.
The neighborhood enumeration then starts again from there, until the termination criterion is met.
Of course, it could also happen that the enumeration of the neighborhood is completed without discovering a better solution.
In this case, we *know* that $\bestSoFar{\obspel}$ is a local optimum.
Then, we can simply restart at a new, random point.
The general pattern of this algorithm is given below:

1. Set the overall-best objective value&nbsp;$\obspel_B$ to infinity and the overall-best candidate solution&nbsp;$\solspel_B$ to `NULL`. 
2. Create random point&nbsp;$\sespel$ in search space&nbsp;$\searchSpace$ (using the nullary search operator).
3. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
4. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
5. Store&nbsp;$\sespel$ in the variable&nbsp;$\bestSoFar{\sespel}$ and&nbsp;$\obspel$ in&nbsp;$\bestSoFar{\obspel}$.
6. If $\bestSoFar{\obspel}<\obspel_B$, then set&nbsp;$\obspel_B$ to&nbsp;$\bestSoFar{\obspel}$ and store&nbsp;$\solspel_B=\repMap{\sespel}$.
7. Repeat until the termination criterion is met:
    a. For each point&nbsp;$\sespel'$ in the search space neighboring to the current best point&nbsp;$\bestSoFar{\sespel}$ according to the unary search operator do:
       i. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
       ii. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
       iii. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\bestSoFar{\sespel}$, $\obspel'$ in&nbsp;$\bestSoFar{\obspel}$, and stop the enumeration (go back to step&nbsp;*6*).
    b. If we arrive here, the neighborhood of&nbsp;$\bestSoFar{\obspel}$ did not contain any better solution. Hence, we perform a restart by going back to point&nbsp;2.
6. Return **best ever encountered** objective value&nbsp;$\obspel_B$ and solution&nbsp;$\solspel_B$ to the user.

\repo.listing{lst:HillClimber2WithRestarts}{An excerpt of the implementation of the Hill Climbing algorithm with restarts based on neighborhood enumeration.}{java}{src/main/java/aitoa/algorithms/HillClimber2WithRestarts.java}{}{relevant}

If we want to implement this algorithm for black-box optimization, we face the situation that the algorithm does not know the nature of the search space nor the neighborhood spanned by the operator.
Therefore, we rely on the design introduced in [@lst:IUnarySearchOperatorEnum], which allows us to realize this implicitly unknown looping behavior (point&nbsp;*a* above) in form of the visiting pattern.
The idea is that, while our hill climber does not know how to enumerate the neighborhood, the unary operator does, since it defines the neighborhood.
The resulting code is given in [@lst:HillClimber2WithRestarts].

Different from our original hill climber with restarts introduced in [@sec:stochasticHillClimbingWithRestarts], this new algorithm does not need to count steps until restarts.
It therefore also does not need a parameter&nbsp;$L$ determining the number of non-improving FEs after which a restart should be performed.
Its implementation in [@lst:HillClimber2WithRestarts] is therefore also shorter and simpler than the implementation of the original algorithm variant in [@lst:HillClimberWithRestarts].
It should be noted that both new hill climbers can only be applied in scenarios where we actually can enumerate the neighborhoods of the current best solutions efficiently.
In other words, we pay for a potential gain of search efficiency by a reduction of the types of problems we can process.

### Results on the JSSP

\relative.input{jssp_hc2r_results.md}

: The results of the new hill climbers `hc2r_1swap` and `hc2r_1swapU` in comparison with `hcr_16384_1swap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_hc2r_results}

In [@tbl:jssp_hc2r_results], we list the results of new neighborhood-enumerating hill climbers with restarts (prefix `hc2r`).
We compare the version using the deterministic neighborhood enumeration&nbsp;`hc2r_1swap` to `hc2r_1swapU`&nbsp;which enumerates the neighborhood in a random order.
We further also list the results of `hcr_16384_1swap`, the stochastic hill climber which restarts after 16'384 unsuccessful steps.
This setup was found to perform well in [@sec:hillClimberWithRestartSetup].

We find that `hc2r_1swapU` tends to have the edge over `hc2r_1swap`, except for instance `swv15`, where it does perform worse.
Also, `hc2r_1swapU` and `hcr_16384_1swap` deliver very similar results, which also means that it performs worse than our Evolutionary Algorithms or Simulated Annealing.

In [@fig:jssp_progress_hc2r_log], we plot the progress of the `hc2r_1swap`, `hc2r_1swapU`, and `hcr_16384_1swap` algorithms over time.
It is very surprising to see that the median of best-so-far solution qualities of `hc2r_1swapU` and `hcr_16384_1swap` are almost identical during the whole three minute computational budget and on all four JSSP instances.
Both `hc2r_1swapU` and `hcr_16384_1swap` perform random job swaps in each step.
`hc2r_1swapU` avoids trying the same move twice and will restart when it has arrived in a local optimum.
`hcr_16384_1swap` may try the same move multiple times and performs a restart after&nbsp;$L=16'384$ unsuccessfuly steps.
The fact that both algorithms perform so very similar probably means that the restart setting of $L=16'384$ for `hcr_16384_1swap` is probably a rather good choice.

It is also clearly visible that `hc2r_1swap` is initially slower than the other two algorithms, although its end result is still similar.
This shows that enumerating the neighborhood of a solution in a random fashion is better than doing it always in the same deterministic way.
This supports the idea of doing things in a randomized way if no clear advantage of a deterministic approach is visible.

The question arises why we would bother with the `hc2r`-type hill climbers if we seemingly can get the exact same behavior from a stochastic hill climber with restarts.
One answer is the fact that we found a method to actually *know* whether a solution is an optimum instead of having to guess.
Another answer is that we need one parameter less.
We retain the black-box ability of the algorithm but have zero parameters (except the choice of the unary search operator), as opposed to the EA and SA algorithms which each have three ($\mu$, $\lambda$, $cr$ and temperature schedule, $T_s$, $\epsilon$, respectively).

![The median of the progress of the algorithms `hc2r_1swap`, `hc2r_1swapU`, and `hcr_16384_1swap` over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_hc2r_log.svgz}){#fig:jssp_progress_hc2r_log width=84%}
 
