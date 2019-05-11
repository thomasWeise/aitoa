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

Instead of randomly sampling elements from this neighborhood, we could simple iteratively and exhaustively enumerate over them.
As soon as we encounter and improving move, we can stop and accept the better point.
If we have finished enumerating all possible `1swap` neighbors of a given point in the search space and none of them yields a candidate solution with better objective value (i.e., a Gantt chart with shorter makespan), we know that we have arrived in a local optimum.
This way, we do no longer need to "guess" if we have converged or not, we know it directly.
Also, as detailed in [@sec:appendix:jssp:1swapProb], we should be able to find an improving move faster in average, because we will never redundantly sample the same point in the search space again when investigating the neighborhood of the current best solution.