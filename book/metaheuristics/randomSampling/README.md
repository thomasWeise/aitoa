## Random Sampling {#sec:randomSampling}

If we have our optimization problem and its components properly defined according to [@sec:structure], then we have the proper tools to solve the problem.
We know

- how a solution can internally be represented as "point"&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ ([@sec:searchSpace]),
- how we can map such a point&nbsp;$\sespel\in\searchSpace$ to a candidate solution&nbsp;$\solspel$ in the solution space&nbsp;$\solutionSpace$ ([@sec:solutionSpace]) via the representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ ([@sec:searchSpace]), and
- how to rate a candidate solution&nbsp;$\solspel\in\solutionSpace$ with the objective function&nbsp;$\objf$ ([@sec:objectiveFunction]).

Basically, all what we need now is to somehow "create" a point&nbsp;$\sespel$ in the search space.
We can then apply&nbsp;$\repMap(\sespel)$ and get a candidate solution&nbsp;$\solspel$ whose quality we can assess via&nbsp;$\objf(\solspel)$.
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

### Single Random Sample

\repo.listing{lst:SingleRandomSample}{An excerpt of the implementation of an algorithm which creates a single random candidate solution.}{java}{src/main/java/aitoa/algorithms/SingleRandomSample.java}{}{relevant}

Now that we have all ingredients ready, we can test the idea.
In [@lst:SingleRandomSample], we implement this algorithm `1rs` which creates exactly one random point in the search space.
It then takes this point and passes it to the evaluation function of our black-box `process`, which will perform the representation mapping and compute the objective value.

Of course, since the algorithm is *randomized*, it may give us a different result every time we run it.
In order to understand what kind of solution qualities we can expect, we hence have to run it a couple of times and compute result statistics.
We therefore execute our program 101 times and the results are summarized in [@tbl:singleRandomSampleJSSP].

|$\instance$|$\lowerBound{\objf}$|best|mean|med|t(med)|sd|
|:-:|--:|--:|--:|--:|--:|--:|
|`abz7`|656|1131|1334|1326|0s|106|
|`la24`|935|1487|1842|1814|0s|165|
|`swv15`|2885|5935|6600|6563|0s|346|
|`yn4`|929|1754|2036|2039|0s|125|

: The results of the single random sample algorithm `1rs` for each instance $\instance$ in comparison to the lower bound&nbsp;$\lowerBound{\objf}$ of the makespan&nbsp;$\objf$ over 101&nbsp;runs: the *best*, *mean*, and median (*med*) result quality, as well as the median time *t(med)* needed to obtain a solution at least as good as *med* and the standard deviation *sd* of the result quality.  {#tbl:singleRandomSampleJSSP}

![The Gantt charts of the median solutions obtained by the `1rs` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_1rs_med.svgz}){#fig:jssp_1rs_me width=98%}

What we can find in [@tbl:singleRandomSampleJSSP] is that the makespan of best solution that any of the 101&nbsp;runs has delivered for each of the four JSSP instances is between 60% and 100% longer than the lower bound.
The [arithmetic mean](http://en.wikipedia.org/wiki/Arithmetic_mean) and [median](http://en.wikipedia.org/wiki/Median) of the solution qualities are even between 10% and 20% worse.
In the Gantt charts of the median solutions depicted in [@fig:jssp_1rs_med], we can find big gaps between the sub-jobs.
This all is expected.
After all, we just create a single random solution.
We can hardly assume that doing all jobs of a JSSP in a random order would even be good idea.

But we also notice more.
The time $t(med)$ that the top-50% of the runs need to get their result is approximately&nbsp;0s.
Creating, mapping, and evaluating a solution can be very fast, actually within a few milliseconds.
However, we had originally planned to use up to three minutes for optimization.
Hence, almost all of our time budget remains unused.
At the same time, we already know that that there is a 10-20% difference between the best and the median solution quality among the 101&nbsp;random solutions we created.
The standard deviation&nbsp;$sd$ of the solution quality also is always above 100&nbsp;time units of makespan.
So why don't we try to make use of this variance and the high speed of solution creation?
