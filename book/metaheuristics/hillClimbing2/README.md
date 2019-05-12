## Hill Climbing Revisited {#sec:hillClimbing2}

Until now, we have entirely relied on randomness to produce new points in the search space.
The results of our nullary, unary, and binary operators are all random.
In case of the unary and binary operator, they of course depend on the input points in the search space fed to the operators, but still, the results are unpredictable and random.
This is, in general, not a bad property.
In the absence of knowledge about what is best, doing an arbitrary thing might have a better expected outcome than doing a fixed, pre-determined thing.
However, it also does not provide us with any information regarding whether we have prematurely converged to a local optimum or not.
We simply guess this, and in [@sec:stochasticHillClimbingWithRestarts] we therefore design an algorithm that restarts if it did not encounter an improvement for a certain time.
This might be too early, as there may still be undiscovered solutions in the neighborhood of the current best on &ndash; or it might be too late and we may have already investigated the complete neighborhood.

Let us take one step back, to the simple hill climber and the original unary search operator `1swap` for the JSSP from [@sec:hillClimbingJssp1Swap].
This operator tries to perform a single swap, i.e., exchange the order of two job IDs in a point from the search space.
We already discussed in [@sec:hillClimbingWithDifferentUnaryOperator] that the size of this neighborhood is&nbsp;$0.5*\jsspMachines^2*\jsspJobs*(\jsspJobs-1)$ for each point in the search space.

### Idea: Enumerating Neighborhoods

Instead of randomly sampling elements from this neighborhood, we could simple iteratively and exhaustively enumerate over them.
As soon as we encounter and improving move, we can stop and accept the better point.
If we have finished enumerating all possible `1swap` neighbors of a given point in the search space and none of them yields a candidate solution with better objective value (i.e., a Gantt chart with shorter makespan), we know that we have arrived in a local optimum.
This way, we do no longer need to "guess" if we have converged or not, we know it directly.
Also, as detailed in [@sec:appendix:jssp:1swapProb], we should be able to find an improving move faster in average, because we will never redundantly sample the same point in the search space again when investigating the neighborhood of the current best solution.

Implementing this concept is a little bit more complicated than creating the simple unary operator that just returns one single new point in the search space as a result.
Instead, such an enumerating unary operator for a black-box metaheuristic may create any number of points.
Moreover, if one of the new points already maps to a candidate solutions which can improve upon the current best solution, then maybe we wish to terminate the enumeration process at that point.

Such behavior can be realized by following a [visitor design pattern](http://en.wikipedia.org/wiki/Visitor_pattern).
An enumerating unary operator will receive a point&nbsp;$\sespel$ in the search space and a call-back function from the optimization process.
Every time it creates a neighbor&nbsp;$\sespel'$ of&nbsp;$\sespel$, it will invoke the call-back function and pass&nbsp;$\sespel'$ to it.
If the function returns, say `true`, then the enumeration will be terminated, while it is continued for `false`.
The optimization process, in the call-back function, could apply the representation mapping&nbsp;$\repMap$ to&nbsp;$\sespel'$ and compute the objective value of the resulting candidate solution.
If that solution is better than&nbsp;$\sespel$, it could store it and return `true`.
Otherwise, it would return `false` and be fed with the next neighbor, until the neighborhood was exhaustively enumerated. 

This idea can be implemented by extending our original interface `IUnarySearchOperator` for unary search operations given in [@lst:IUnarySearchOperator]. 

\repo.listing{lst:IUnarySearchOperatorEnum}{A the generic interface for unary search operators, now able to enumerate neighborhoods.}{java}{src/main/java/aitoa/structure/IUnarySearchOperator.java}{}{relevant,enumerate}

The extension, presented in [@lst:IUnarySearchOperatorEnum], is a single new function, `enumerate`, which should realize the neighborhood enumeration.
This function receives an existing point&nbsp;`x`in the search space as input, as well as a destination data structure&nbsp;`dest` where, iteratively, the neighboring points of&nbsp;`x` should be stored.
Additionally, a call-back function&nbsp;`visitor` is provided as implementation Java&nbsp;8-interface [`Predicate`](http://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html).
The [`test` function](http://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html#test-T-) function of this interface will, upon each call, receive the next neighbor of `x` (stored in `dest`).
It returns `true` when the enumeration should be stopped (maybe because a better solution was discovered) and `false` to continue. 
`enumerate` itself will return `true` if and only if `test` ever returned `true` and `false` otherwise.

### Ingredient: Neighborhood Enumerating `1swap` Operation for the JSSP {#sec:hillClimbingJssp1SwapEnum}

Let us now consider how such an exhaustive enumeration of the neighborhood spanned by the `1swap` operator can be implemented.

1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. For index $i$ from $1$ to $\jsspMachines*\jsspJobs-1$ do:
    a. Store the job at index $i$ in $\sespel'$ in variable $job_i$. 
		b. For index $j$ from $0$ to $i-1$ do:
		   i. Store the job at index $j$ in $\sespel'$ in variable $job_j$.
		   ii. If $job_i\neq job_j$ then:
		       1. Store $job_i$ at index $j$ in $\sespel'$.
		       2. Store $job_j$ at index $i$ in $\sespel'$.
		       3. Pass $\sespel'$ to a call-back function of the optimization process.
		          If the function indicates that it wishes to terminate the enumeration, then quit.
		          Otherwise continue with the next step.
		       4. Store $job_i$ at index $i$ in $\sespel'$.
		       5. Store $job_j$ at index $j$ in $\sespel'$.

This simple algorithm is implemented in [@lst:JSSPUnaryOperator1SwapEnum], which only shows the new function that was added to our class `JSSPUnaryOperator1Swap` that we had already back in [@sec:hillClimbingJssp1Swap].

\repo.listing{lst:JSSPUnaryOperator1SwapEnum}{An excerpt of the `1swap` operator for the JSSP, namely the implementation of the `enumerate` function from the interface `IUnarySearchOpertor`&nbsp;([@lst:IUnarySearchOperatorEnum]).}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1Swap.java}{}{enumerate}
