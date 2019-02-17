## Global Optima and Lower Quality Bounds

We now know the three key-components of an optimization problem.
We are looking for a candidate solution&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ that has the best objective value&nbsp;$\objf(\globalOptimum{\solspel})$ for a given problem instance&nbsp;$\instance$.
But what is the meaning "best"?

### Definitions

Assume that we have a single objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ defined over a solution space&nbsp;$\solutionSpace$.
This objective function is our primary guide during the search and we are looking for its global optima.

\text.block{definition}{globalOptimum}{If a candidate solution$\globalOptimum{\solspel}\in\solutionSpace$ is a *global optimum* for an optimization problem defined over the solution space&nbsp;$\solutionSpace$, then is no other candidate solution in&nbsp;$\solutionSpace$ which is better.}

\text.block{definition}{globalOptimumSO}{For every *global optimum*&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ of single-objective optimization problem with solution space&nbsp;$\solutionSpace$ and objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ subject to minimization, it holds that $\objf(\solspel) \geq \objf(\globalOptimum{\solspel}) \forall \solspel \in \solutionSpace$.}

The real-world meaning of a global optimum is nothing else than a *superlative*.
If we solve a JSSP for a factory, our goal is the *shortest* makespan.
If we try to pack the factory's products into containers, we look for the packing that needs the *least* amount of containers.
Thus, optimization means searching for such superlatives, as illustrated in [@fig:optimization_superlatives].
Vice versa, whenever we are looking for the cheapest, fastest, strongest, best, biggest or smallest "thing", then we have an optimization problem at hand.

![Optimization is the search for superlatives.](\relative.path{optimization_superlatives.svgz}){#fig:optimization_superlatives width=60%}

### Approxiation of the Optimum

When solving an optimization problem, we hope to find at least one global optimum (there may be multiple), as stated in \text.ref{optimizationProblemMathematical}.
However, this may often not be possible or it will just take too long!

![The growth of different functions in a log-log scaled plot. Exponential functions grow very fast, so that an algorithm which needs&nbsp;$\sim 2^s$ steps to solve an optimization problem of size&nbsp;$s$ quickly becomes infeasible. (compare with [@tbl:jsspSolutionSpaceTable] and [@tbl:jsspSearchSpaceTable])](\relative.path{function_growth.svgz}){#fig:function_growth width=99%}

Matter of fact, theoretical computer science shows that for many problems, the time we need to find the best-possible solution can grow exponentially with the size of the problem in the worst case.
Or, in other words, unless something [fundamentally changes](http://en.wikipedia.org/wiki/P_versus_NP_problem)&nbsp;[@C1971TCOTPP], there will be some problems which usually will take too long to solve.
[@fig:function_growth] illustrates that finding the globally optimal solutions for problems with such exponential "time complexity" will quickly become infeasible, even for relatively small problem instances.
Just throwing more computing power at the problems will not solve this fundamental issue.
Our processing power is limited and parallelization can provide a linear speed-up at best.
This cannot mitigate the exponentially growing runtime requirements of many optimization problems.

Unfortunately, our example problems are amongst this kind of problem.
(We also already know that even small instances of the JSSP can have millions or billions of possible candidate solutions, see [@tbl:jsspSolutionSpaceTable].)
So what can we do?
The exponential time requirement occurs if we make *guarantees* about the solution quality, especially about its optimality, over all possible scenarios.

What we can do is that we can trade-in the *guarantee* of finding the globally optimal solution for lower runtime requirements.[^npruntimeother]
We can use algorithms from which we hope that they find a good *approximation* of the optimum, i.e., a solution which is very good with respect to the objective function, but which do not *guarantee* that their result will be the best possible solution.
We may sometimes be lucky and even find the optimum, while in other cases, we may get a solution which is close enough.
And we will get this within acceptable time limits.

[^npruntimeother]: Another choice would be to drop the "over all possible scenarios" aspect, by developing algorithms for specific, simpler versions of the optimization problem.
Solving a JSSP where all sub-jobs have the same time requirement, for instance, may be much easier.

### Bounds of the Objective Function

If we apply an approximation algorithm, then we do not have the guarantee that the solution we get is optimal.
We often do not even know if the best solution we currently have is optimal or not.
In some cases, we be able to compute a *lower bound*&nbsp;$\lowerBound(\objf)$ for the objective value of an optimal solution, i.e., we know "It is not possible that any solution can have a quality better than $\lowerBound(\objf)$, but we may not know whether a solution actually exists that has quality&nbsp;$\lowerBound(\objf)$."
This is not useful for solving the problem, but it can tell us whether our method for solving the problem is good.
For instance, if we have developed an algorithm for approximately solving a given problem and we *know* that the qualities of the solutions we get are close to a the lower bound, then we know that our algorithm is good.
We then know that improving the result quality of the algorithm may be hard, maybe even impossible, and probably not worthwhile.
However, if we cannot produce solutions as good as or close to the lower quality bound, this does not necessarily mean that our algorithm is bad.

It should be noted that it is *not* necessary to know the bounds of objective values.
Lower bounds are a *"nice to have"* feature allowing us to better understand the performance of our algorithms.

### Example: Job Shop Scheduling {#sec:jssp:lowerBounds}

We have already defined our solution space&nbsp;$\solutionSpace$ for the JSSP in [@lst:JSSPCandidateSolution] and the objective function&nbsp;$\objf$ in [@lst:IObjectiveFunction].
A Gantt chart with the shortest possible makespan is then a global optimum.
There may be multiple globally optimal solutions, which then would all have the same makespan.

When facing a JSSP instance&nbsp;$\instance$, we do not know whether a given Gantt chart is the globally optimal solution or not, because we do not know the shortest possible makespan.
There is no direct way in which we can compute it.
But we can, at least, compute some *lower bound*&nbsp;$\lowerBound(\objf)$ for the best possible makespan.

For instance, we know that a job&nbsp;$\jsspJobIndex$ needs at least as long to complete as the sum&nbsp;$\sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ over the processing times of all of its sub-jobs.
It is clear that no schedule can complete faster then the longst job.
Furthermore, we know that the makespan of the optimal schedule also cannot be shorter than the latest "finishing time" of any machine&nbsp;$\jsspMachineIndex$.
This finishing time is at least as big as the sum&nbsp;$\jsspMachineRuntime{\jsspMachineIndex}$ of the runtimes of all the sub-jobs assigned to this machine.
But it may also include a least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$, namely if the sub-jobs for machine&nbsp;$\jsspMachineIndex$ never come first in their job.
Similarly, there is a least idle time&nbsp;$\jsspMachineEndIdle{\jsspMachineIndex}$ at the end if these sub-jobs never come last in their job.
As lower bound for the fastest schedule that could theoretically exist, we therefore get:

$$ \lowerBound(\objf) = \max\left\{\max_{\jsspJobIndex}\left\{ \sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}\right\} \;,\; \max_{\jsspMachineIndex} \left\{ \jsspMachineStartIdle{\jsspMachineIndex}+\jsspMachineRuntime{\jsspMachineIndex} +\jsspMachineEndIdle{\jsspMachineIndex}\right\}\right\} $$ {#eq:jsspLowerBound}

More details are given in [@sec:appendix:jssp:lowerBounds] and [@T199BFBSP].

Of course, we cannot know whether a schedule exists that can achieve this lower bound makespan.
There simply may not be any way to arrange the jobs such that no sub-job stalls any other sub-job.
This is why the value&nbsp;$\lowerBound(\objf)$ is a lower bound: we know no solution can be better than this, but we do not know whether a solution with such minimal makespan exists.

However, if our algorithms produce solutions with a quality close to&nbsp;$\lowerBound(\objf)$, we know that are doing very well.
The lower bounds for the makespans of our example problems are illustrated in [@tbl:jsspLowerBoundsTable].

|name|$\jsspJobs$|$\jsspMachines$|$\lowerBound(\objf)$|$\lowerBound(\objf)^{\star}$|source for&nbsp;$\lowerBound{\objf}^{\star}$
|:--|--:|--:|--:|--:|:--|
`demo`|4|5|180|180|[@eq:jsspLowerBound]
`abz7`|20|15|638|656|[@MF1975OSWRTADDTMML; @VLS2015FDSFCBS; @VLS2015FDSFCBSDER; @vH2015JSIAS]
`la24`|15|10|872|935|[@AC1991ACSOTJSSP; @vH2015JSIAS]
`swv15`|50|10|2885|2885|[@eq:jsspLowerBound]
`yn4`|20|20|818|929|[@VLS2015FDSFCBS; @VLS2015FDSFCBSDER; @vH2015JSIAS]

: The lower bounds&nbsp;$\lowerBound{\objf}$ for the makespan of the optimal solutions for our example problems. For the instances `abz7`, `la24`, and `yn4`, research literature (last column) provides better (i.e., higher) lower bounds&nbsp;$\lowerBound(\objf)^{\star}$. {#tbl:jsspLowerBoundsTable}

![The globally optimal solution of the demo instance [@fig:jssp_demo_instance], whose makespan happens to be the same as the lower bound.](\relative.path{gantt_demo_optimal_bound.svgz}){#fig:gantt_demo_optimal_bound width=80%}

[@fig:gantt_demo_optimal_bound] illustrates the globally optimal solution for our small demo JSSP instance defined in [@fig:jssp_demo_instance] (we will get to how to find such a solution later).
Here we were lucky: The objective value of this solution happens to be the same as the lower bound for the makespan.
Upon closer inspection, the limiting machine is the one at index&nbsp;3.

We will find this by again looking at [@fig:jssp_demo_instance].
Regardless with which job we would start here, it would need to initially wait at least&nbsp;$\jsspMachineStartIdle{3}=30$ time units.
The reason is that no first sub-job of any job starts at machine&nbsp;3.
Job&nbsp;0 would get to machine&nbsp;3 the earliest after 50&nbsp;time units, job&nbsp;1 after&nbsp;30, job&nbsp;2 after&nbsp;62, and job&nbsp;3 after again 50&nbsp;time units.
Also, no job in the `demo` instance finishes at machine&nbsp;3.
Job&nbsp;0, for instance, needs to be processed by machine&nbsp;4 for 10&nbsp;time units after it has passed through machine&nbsp;3.
Job&nbsp;1 requires 80&nbsp;more time units after finishing at machine&nbp;3, job&nbsp;2 also 10&nbsp;time units, and job&nbsp;3again&nbsp;50 time units.
In other words, machine&nbsp;3 needs to wait at least 30&nbsp;time units before it can commence its work and will remain idle for at least 10&nbsp;time units after processing the last sub job.
Inbetween, it will need to work for exactly&nbsp;140 time units, the total sum of the running time of all sub-jobs assigned to it.
This means that no schedule can complete faster than $30+140+10=180$ time units.
Thus, [@fig:gantt_demo_optimal_bound] illustrates the optimal solution for the `demo` instance.

Then, all the jobs together on the machine will consume&nbsp;$\jsspMachineRuntime{3}=150$ time units if we can execute them without further delay.
Finally, it regardless with which job we finish on this machine, it will lead to a further waiting time of&nbsp;$\jsspMachineEndIdle{3}=10$ time units.
This leads to a lower bound&nbsp;$\lowerBound(\objf)$ of&nbsp;180 and since we found the illustrated candidate solution with exactly this makespan, we have solved this (very easy) JSSP instance.
