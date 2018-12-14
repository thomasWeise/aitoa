## Global Optima and Lower Quality Bounds

### Definitions

Assume that we have a single objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ defined over a solution space&nbsp;$\solutionSpace$.
This objective function is our primary guide during the search.
But what are we looking for?

\text.block{definition}{globalOptimum}{If a candidate solution$\globalOptimum{\solspel}\in\solutionSpace$ is a *global optimum* for an optimization problem defined over the solution space&nbsp;$\solutionSpace$, then is no other candidate solution in&nbsp;$\solutionSpace$ which is better.}

\text.block{definition}{globalOptimumSO}{For every *global optimum*&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ of single-objective optimization problem with solution space&nbsp;$\solutionSpace$ and objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ subject to minimization, it holds that $\objf(\solspel) \geq \objf(\globalOptimum{\solspel}) \forall \solspel \in \solutionSpace$.}

When solving an optimization problem, we hope to find at least one global optimum (there may be multiple), as stated in \text.ref{optimizationProblemMathematical}.
However, this may often not be possible or it will just take too long.
Often, we have no way to find out whether a solution is a global optimum or not.
We therefore hope to find a good *approximation* of the optimum, i.e., a solution which is very good with respect to the objective function.

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

No schedule can complete faster then the longst job.
We know that the makespan in a JSSP cannot be shorter than the latest "finishing time" of any machine&nbsp;$\jsspMachineIndex$ in the optimal schedule.
This finishing time is at least as big as the sum&nbsp;$\jsspMachineRuntime{\jsspMachineIndex}$ of the runtimes of all the sub-jobs assigned to this machine.
But it may also include a least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$, namely if the sub-jobs for machine&nbsp;$\jsspMachineIndex$ never come first in their job, as well as a least end idle time&nbsp;$\jsspMachineEndIdle{\jsspMachineIndex}$, if these sub-jobs never come last in their job.
As lower bound for the fastest schedule that could theoretically exist, we therefore get:

$$ \lowerBound{\objf} = \max\left\{\max_{\jsspJobIndex}\left\{ \sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}\right\}, \max_{\jsspMachineIndex} \left\{ \jsspMachineStartIdle{\jsspMachineIndex}+\jsspMachineRuntime{\jsspMachineIndex} +\jsspMachineEndIdle{\jsspMachineIndex}\right\}\right\} $$ {#eq:jsspLowerBound}

More details are given in [@sec:appendix:jssp:lowerBounds] and [@T199BFBSP].
We do not know whether a schedule exists that can achieve this, because this would mean that we have a schedule where no sub-job is stalled by any sub-job of any other job.
The value&nbsp;$\lowerBound{\objf}$ is a lower bound, we know no solution can be better than this, but we do not know whether a solution with such minimal makespan exists.
If our algorithms produce solutions with a quality close to&nbsp;$\lowerBound{\objf}$, we know that are doing very well.
