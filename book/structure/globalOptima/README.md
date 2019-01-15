## Global Optima and Lower Quality Bounds

### Definitions

Assume that we have a single objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ defined over a solution space&nbsp;$\solutionSpace$.
This objective function is our primary guide during the search.
But what are we looking for?

![Optimization is the search for superlatives.](\relative.path{optimization_superlatives.svgz}){#fig:optimization_superlatives width=60%}

\text.block{definition}{globalOptimum}{If a candidate solution$\globalOptimum{\solspel}\in\solutionSpace$ is a *global optimum* for an optimization problem defined over the solution space&nbsp;$\solutionSpace$, then is no other candidate solution in&nbsp;$\solutionSpace$ which is better.}

\text.block{definition}{globalOptimumSO}{For every *global optimum*&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ of single-objective optimization problem with solution space&nbsp;$\solutionSpace$ and objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ subject to minimization, it holds that $\objf(\solspel) \geq \objf(\globalOptimum{\solspel}) \forall \solspel \in \solutionSpace$.}

A global optimum is nothing else than a *superlative*.
Optimization means searching for such superlatives, as illustrated in [@fig:optimization_superlatives].
Whenever we are looking for the cheapest, fastest, strongest, best, biggest or smallest thing, then we have an optimization problem at hand.

### Approxiation of the Optimum

When solving an optimization problem, we hope to find at least one global optimum (there may be multiple), as stated in \text.ref{optimizationProblemMathematical}.
However, this may often not be possible or it will just take too long.

![The growth of different functions in a log-log scaled plot. Exponential functions grow very fast, so that an algorithm which needs&nbsp;$\sim e^s$ steps to solve an optimization problem of size&nbsp;$s$ quickly becomes infeasible.](\relative.path{function_growth.svgz}){#fig:function_growth width=99%}

Matter of fact, theoretical computer science shows that for many problems, the time we need to find the best-possible solution can grow exponentially with the size of the problem in the worst case.
Or, in other words, unless something [fundamentally changes](http://en.wikipedia.org/wiki/P_versus_NP_problem), there will be some problems which usually will take too long to solve.
[@fig:function_growth] illustrates that finding the globally optimal solutions for problems with such exponential "time complexity" will quickly become infeasible, even for relatively problem instances.

Unfortunately, our example problems are amongst this kind of problem.
So what can we do?
We trade-in the *guarantee* of finding the globally optimal solution for better runtime.
We use algorithms from which we hope that they find a good *approximation* of the optimum, i.e., a solution which is very good with respect to the objective function.
We may sometimes be lucky and even find the optimum, while in other cases, we may get a solution which is close enough.
And we will get this within acceptable time limits.

### Bounds of the Objective Function

If we apply an approximation algorithm, then we do not have the guarantee that the solution we get is optimal.
Actually, we often do not know if the solution we have is optimal or not.
In some cases, we be able to compute a *lower bound*&nbsp;$\lowerBound{\objf}$ for the objective value of an optimal solution, i.e., we know "It is not possible that any solution can have a quality better than $\lowerBound{\objf}$, but we do not know if a solution exists that has quality&nbsp;$\lowerBound{\objf}$."
This is not useful for solving the problem, but it can tell us whether our method for solving the problem is good.
For instance, if we have developed an algorithm for approximately solving a given problem and we *know* that the qualities we get are close to a the lower bound, then we know that our algorithm is good.
We then know that improving the result quality of the algorithm may be hard, maybe even impossible, and probably not worthwhile.
However, if we cannot produce solutions as good as the lower bound or even only solutions which are a bit far off, this does not necessarily mean that our algorithm is bad.

### Example: Job Shop Scheduling {#sec:jssp:lowerBounds}

We have already defined our solution space&nbsp;$\solutionSpace$ for the JSSP in [@lst:JSSPCandidateSolution] and the objective function&nbsp;$\objf$ in [@lst:IObjectiveFunction].
A Gantt chart with the shortest possible makespan is then a global optimum.
There may be multiple globally optimal solutions, which then would all have the same makespan.

When facing a JSSP instance&nbsp;$\instance$, we do not know whether a given Gantt chart is the globally optimal solution or not, because we do not know the shortest possible makespan.
There is no direct way in which we can compute it.
But we can, at least, compute some *lower bound*&nbsp;$\lowerBound{\objf}$ for the best possible makespan.

For instance, we know that a job&nbsp;$\jsspJobIndex$ needs at least as long to complete as the sum&nbsp;$\sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ over the processing times of all of its sub-jobs.
It is clear that no schedule can complete faster then the longst job.
Furthermore, we know that the makespan of the optimal schedule also cannot be shorter than the latest "finishing time" of any machine&nbsp;$\jsspMachineIndex$.
This finishing time is at least as big as the sum&nbsp;$\jsspMachineRuntime{\jsspMachineIndex}$ of the runtimes of all the sub-jobs assigned to this machine.
But it may also include a least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$, namely if the sub-jobs for machine&nbsp;$\jsspMachineIndex$ never come first in their job.
Similarly, there is a least idle time&nbsp;$\jsspMachineEndIdle{\jsspMachineIndex}$ at the end if these sub-jobs never come last in their job.
As lower bound for the fastest schedule that could theoretically exist, we therefore get:

$$ \lowerBound{\objf} = \max\left\{\max_{\jsspJobIndex}\left\{ \sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}\right\} \;,\; \max_{\jsspMachineIndex} \left\{ \jsspMachineStartIdle{\jsspMachineIndex}+\jsspMachineRuntime{\jsspMachineIndex} +\jsspMachineEndIdle{\jsspMachineIndex}\right\}\right\} $$ {#eq:jsspLowerBound}

More details are given in [@sec:appendix:jssp:lowerBounds] and [@T199BFBSP].

Of course, we cannot know whether a schedule exists that can achieve this lower bound makespan.
There simply may not be any way to arrange the jobs such that no sub-job stalls any other sub-job.
This is why the value&nbsp;$\lowerBound{\objf}$ is a lower bound: we know no solution can be better than this, but we do not know whether a solution with such minimal makespan exists.

However, if our algorithms produce solutions with a quality close to&nbsp;$\lowerBound{\objf}$, we know that are doing very well.
The lower bounds for the makespans of our example problems are illustrated in [@tbl:jsspLowerBoundsTable].

| name | $\jsspJobs$ | $\jsspMachines$ | $\lowerBound{\objf}$|
|:--|--:|--:|--:|
demo|4|5|180
abz7|20|15|638
la24|15|10|872
yn4|20|20|818
swv15|50|10|2885

: The lower bounds&nbsp;$\lowerBound{\objf}$ for the makespan of the optimal solutions for our example problems. {#tbl:jsspLowerBoundsTable}

![The globally optimal solution of the demo instance [@fig:jssp_demo_instance], whose makespan happens to be the same as the lower bound.](\relative.path{gantt_demo_optimal_bound.svgz}){#fig:gantt_demo_optimal_bound width=80%}

[@fig:gantt_demo_optimal_bound] illustrates the globally optimal solution for our small demo JSSP instance defined in [@fig:jssp_demo_instance] (we will get to how to find such a solution later).
Here we were lucky: The objective value of this solution happens to be the same as the lower bound for the makespan.
Upon closer inspection, the limiting machine is the one at index&nbsp;3.
Regardless with which job we would start here, it would need to initially wait at least&nbsp;$\jsspMachineStartIdle{3}=30$ time units.
Then, all the jobs together on the machine will consume&nbsp;$\jsspMachineRuntime{3}=150$ time units if we can execute them without further delay.
Finally, it regardless with which job we finish on this machine, it will lead to a further waiting time of&nbsp;$\jsspMachineEndIdle{3}=10$ time units.
This leads to a lower bound&nbsp;$\lowerBound{\objf}$ of&nbsp;180 and since we found the illustrated candidate solution with exactly this makespan, we have solved this (very easy) JSSP instance.
