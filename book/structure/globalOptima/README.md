## Global Optima and the Lower Bound of the Objective Function

We now know the three key-components of an optimization problem.
We are looking for a candidate solution&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ that has the best objective value&nbsp;$\objf(\globalOptimum{\solspel})$ for a given problem instance&nbsp;$\instance$.
But what is the meaning "best"?

### Definitions

Assume that we have a single objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ defined over a solution space&nbsp;$\solutionSpace$.
This objective function is our primary guide during the search and we are looking for its global optima.

\text.block{definition}{globalOptimum}{If a candidate solution$\globalOptimum{\solspel}\in\solutionSpace$ is a *global optimum* for an optimization problem defined over the solution space&nbsp;$\solutionSpace$, then there is no other candidate solution in&nbsp;$\solutionSpace$ which is better.}

\text.block{definition}{globalOptimumSO}{For every *global optimum*&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ of single-objective optimization problem with solution space&nbsp;$\solutionSpace$ and objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ subject to minimization, it holds that $\objf(\solspel) \geq \objf(\globalOptimum{\solspel}) \forall \solspel \in \solutionSpace$.}

Notice that \text.ref{globalOptimumSO} does not state that the objective value of&nbsp;$\globalOptimum{\solspel}$ needs to be better than the objective value of all other possible solutions.
The reason is that there may be more than one global optimum, in which case all of them have the same objective value.
Thus, a global optimum is not defined as a candidate solutions better than all other solutions, but as a solution for which no better alternative exists.

The real-world meaning of a "globally optimal" is nothing else than "superlative"&nbsp;[@BB2008NO].
If we solve a JSSP for a factory, our goal is to find the *shortest* makespan.
If we try to pack the factory's products into containers, we look for the packing that needs the *least* amount of containers.
Thus, optimization means searching for such superlatives, as illustrated in [@fig:optimization_superlatives].
Vice versa, whenever we are looking for the cheapest, fastest, strongest, best, biggest or smallest "thing", then we have an optimization problem at hand.

![Optimization is the search for superlatives&nbsp;[@BB2008NO].](\relative.path{optimization_superlatives.svgz}){#fig:optimization_superlatives width=60%}

For example, for the JSSP there exists a simple and fast algorithm that can find the optimal schedules for problem instances with exactly&nbsp;$\jsspMachines=2$ machines *and* if all&nbsp;$\jsspJobs$ jobs need to be processed by the two machines in exactly the same order&nbsp;[@J1954OTATSPSWSTI].
If our application always falls into a special case of the problem, we may be lucky to find an efficient way to always solve it to optimality.
The general version of the JSSP, however, is \NPprefix&#8209;hard&nbsp;[@LLRKS1993SASAAC; @CPW1998AROMSCAAA], meaning that we cannot expect to solve it to global optimality in reasonable time.
Developing a good (meta-)heuristic algorithm, which cannot provide guaranteed optimality but will give close-to-optimal solutions in practice, is a good choice. 

### Bounds of the Objective Function

If we apply an approximation algorithm, then we do not have the guarantee that the solution we get is optimal.
We often do not even know if the best solution we currently have is optimal or not.
In some cases, we be able to compute a *lower bound*&nbsp;$\lowerBound(\objf)$ for the objective value of an optimal solution, i.e., we know "It is not possible that any solution can have a quality better than $\lowerBound(\objf)$, but we may not know whether a solution actually exists that has quality&nbsp;$\lowerBound(\objf)$."
This is not directly useful for solving the problem, but it can tell us whether our method for solving the problem is good.
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
It is clear that no schedule can complete faster then the longest job.
Furthermore, we know that the makespan of the optimal schedule also cannot be shorter than the latest "finishing time" of any machine&nbsp;$\jsspMachineIndex$.
This finishing time is at least as big as the sum&nbsp;$\jsspMachineRuntime{\jsspMachineIndex}$ of the runtimes of all the sub-jobs assigned to this machine.
But it may also include a least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$:
If the sub-jobs for machine&nbsp;$\jsspMachineIndex$ never come first in their job, then for each job, we need to sum up the runtimes of the sub-jobs coming before the one on machine&nbsp;$\machineIndex$.
The least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$ is then the smallest of these sums.
Similarly, there is a least idle time&nbsp;$\jsspMachineEndIdle{\jsspMachineIndex}$ at the end if these sub-jobs never come last in their job.
As lower bound for the fastest schedule that could theoretically exist, we therefore get:

$$ \lowerBound(\objf) = \max\left\{\max_{\jsspJobIndex}\left\{ \sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}\right\} \;,\; \max_{\jsspMachineIndex} \left\{ \jsspMachineStartIdle{\jsspMachineIndex}+\jsspMachineRuntime{\jsspMachineIndex} +\jsspMachineEndIdle{\jsspMachineIndex}\right\}\right\} $$ {#eq:jsspLowerBound}

More details are given in [@sec:appendix:jssp:lowerBounds] and [@T199BFBSP].
Often, we may not have such lower bounds, but it does never hurt to think about them, because it will provide us with some more understanding about the nature of the problem we are trying to solve.

Even if we have a lower bound for the objective function, we can usually not know whether any solution of that quality actually exists.
In other words, we do not know whether it is actually possible to find a schedule whose makespan equals the lower bound.
There simply may not be any way to arrange the jobs such that no sub-job stalls any other sub-job.
This is why the value&nbsp;$\lowerBound(\objf)$ is called lower bound:
We know no solution can be better than this, but we do not know whether a solution with such minimal makespan exists.

However, if our algorithms produce solutions with a quality close to&nbsp;$\lowerBound(\objf)$, we know that we are doing well.
Also, if we would actually find a solution with that makespan, then we would know that we have perfectly solved the problem.
The lower bounds for the makespans of our example problems are illustrated in [@tbl:jsspLowerBoundsTable].

|name|$\jsspJobs$|$\jsspMachines$|$\lowerBound(\objf)$|$\lowerBound(\objf)^{\star}$|source for&nbsp;$\lowerBound(\objf)^{\star}$
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
Job&nbsp;1 requires 80&nbsp;more time units after finishing at machine&nbsp;3, job&nbsp;2 also 10&nbsp;time units, and job&nbsp;3 again&nbsp;50 time units.
In other words, machine&nbsp;3 needs to wait at least 30&nbsp;time units before it can commence its work and will remain idle for at least 10&nbsp;time units after processing the last sub job.
In between, it will need to work for exactly&nbsp;140 time units, the total sum of the running time of all sub-jobs assigned to it.
This means that no schedule can complete faster than $30+140+10=180$ time units.
Thus, [@fig:gantt_demo_optimal_bound] illustrates the optimal solution for the `demo` instance.

Then, all the jobs together on the machine will consume&nbsp;$\jsspMachineRuntime{3}=150$ time units if we can execute them without further delay.
Finally, it regardless with which job we finish on this machine, it will lead to a further waiting time of&nbsp;$\jsspMachineEndIdle{3}=10$ time units.
This leads to a lower bound&nbsp;$\lowerBound(\objf)$ of&nbsp;180 and since we found the illustrated candidate solution with exactly this makespan, we have solved this (very easy) JSSP instance.

\repo.listing{lst:IObjectiveFunctionLB}{A generic interface for objective functions, now including a function for the lower bound.}{java}{src/main/java/aitoa/structure/IObjectiveFunction.java}{}{relevant,lowerBound}

We can extend our interface for objective functions in [@lst:IObjectiveFunctionLB] to now also allow us to implement a function `lowerBound` which returns, well, the lower bound.
If we have no idea how to compute that for a given problem instance, this function can simply return&nbsp;$-\infty$.
