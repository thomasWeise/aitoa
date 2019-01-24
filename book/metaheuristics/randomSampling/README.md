## Random Sampling {#sec:randomSampling}

If we have our optimization problem and its components properly defined according to [@sec:structure], then we have the proper tools to solve the problem.
We know

- how a solution can internally be represented as "point"&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ ([@sec:searchSpace]),
- how we can map such a point&nbsp;$\sespel\in\searchSpace$ to a candidate solution&nbsp;$\solspel$ in the solution space&nbsp;$\solutionSpace$ ([@sec:solutionSpace]) via the representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ ([@sec:searchSpace]), and
- how to rate a candidate solution&nbsp;$\solspel\in\solutionSpace$ with the objective function&nbsp;$\ofel$ ([@sec:objectiveFunction]).

Basically, all what we need now is to somehow "create" a point&nbsp;$\sespel$ in the search space.
We can then apply&nbsp;$\repMap(\sespel)$ and get a candidate solution&nbsp;$\solspel$ whose quality we can assess via&nbsp;$\ofel(\solspel)$.
If we look at the problem as a black box ([@sec:blackbox]), i.e., don't really know what "makes a candidate solution good," then the best we can do is just create the solutions randomly.

### Ingredient: Nullary Search Operation for the JSSP

For this purpose, we need to implement the nullary search operation from [@lst:INullarySearchOperator].
We create a new search operator which needs no input and returns a point in the search space.
Recall that our representation ([@sec:jsspSearchSpace]) requires that each index&nbsp;$\jsspJobIndex\in 0\dots(\jsspJobs-1)$ of the&nbsp;$\jsspJobs$ must occur exactly&nbsp;$\jsspMachines$ times in the integer array of length&nbsp;$\jsspMachines*\jsspJobs$, where&nbsp;$\jsspMachines$ is the number of machines in the JSSP instance.
In [@lst:JSSPNullaryOperator], we achieve this by first creating the sequence&nbsp;$(\jsspJobs-1,\jsspJobs-2,\dots,0)$ and then copy it&nbsp;$\jsspMachines$ times in the destination array `dest`.
We then randomly shuffle `dest` by applying the [Fisher–Yates shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle) algorithm [@FY1948STFBAAMR; @K1969SA], which simply brings the array into an entirely random order.

\repo.listing{lst:JSSPNullaryOperator}{An excerpt of the implementation of the nullary search operation interface [@lst:INullarySearchOperator] for the JSSP, which will create one random point in the search space.}{java}{src/main/java/aitoa/examples/jssp/JSSPNullaryOperator.java}{}{relevant}

By calling the `apply` method of our implemented operator, it will create one random point in the search space.
We can then pass this point through the representation mapping that we already implemented in [@lst:JSSPRepresentationMapping] and have a Gantt diagram.
Easily we then obtain the quality, i.e., makespan, of this candidate solution as the right-most edge of any an job assignment in the diagram, as defined in [@sec:jsspObjectiveFunction].