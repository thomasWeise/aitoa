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

### Example: Job Shop Scheduling

We have already defined our solution space&nbsp;$\solutionSpace$ for the JSSP in [@lst:JSSPCandidateSolution] and the objective function&nbsp;$\objf$ in [@lst:IObjectiveFunction].
A Gantt chart with the shortest possible makespan is then a global optimum.
There may be multiple globally optimal solutions, which then would all have the same makespan.

When facing a JSSP instance&nbsp;$\instance$, we do not know whether a given Gantt chart is the globally optimal solution or not, because we do not know the shortest possible makespan.
There is no direct way in which we can compute it.
But we can, at least, compute some *lower bound*&nbsp;$\lowerBound{\objf}$ for the best possible makespan.

For example, we know that our factory has&nbsp;$\elementOf{\instance}{m}$ machines and each of the&nbsp;$\elementOf{\instance}{n}$ jobs&nbsp;$p$ will have a sub-job&nbsp;$q$ to be executed at each of these machines.
A sub-job&nbsp;$q$ of a given job&nbsp;$p$ can only begin once all other earlier sub-jobs (those with indices smaller than&nbsp;$q$) of the job have finished.
Its completion time $T_{p,q}$ is thus the sum of their execution times plus its own execution time.

$$ T_{p,q} = \sum_{i\leq q} \elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{i}}{time} $$

A machine&nbsp;$v$ cannot be "finished" before all of the sub-jobs for it have been finished as well.
This means that its completion time&nbsp;$T_v$ cannot be earlier than the maximum&nbsp;$T_v^a$ of all the completion times of the sub-jobs assigned to it.

$$ T_v^a = \max{\left\{ T_{p,q} \;|\; \forall p, \elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{q}}{machine}=v \right\}} $$

It can also not earlier than the overall sum&nbsp;$T_v^b$ over all of the time requirements of each of the sub-jobs assigned to it.

$$ T_v^b = \sum{\left\{ \elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{q}}{time}  \;|\; \forall p, \elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{q}}{machine}=v  \right\}} $$

The lower bound for the completion time for machine&nbsp;$v$ would then be the maximum of the two values&nbsp;$T_v^a$ and&nbsp;$T_v^b$.
The makespan of the global optimum of a JSSP instance&nbsp;$\instance$ cannot be shorter than the  maximum of the times when the machines are finished.
The lower bound&nbsp;$\lowerBound{\objf}$ for the best makespan on instance&nbsp;$\instance$ would then be the maximum over all the completion times of the machines, i.e.:

$$ \lowerBound{\objf} = \max{\left\{  T_v^a, T_v^b \;|\; \forall v \in 1\dots \elementOf{\instance}{m} \right\}} $$

We do not know whether a schedule exists that can achieve this, because this would mean that we have a schedule where no sub-job needs to wait even for a single time unit before commencing.
This value is a lower bound, we know no solution can be better than this, but we do not know whether a solution with such minimal makespan exists.
If our algorithms produce solutions with a quality close to&nbsp;$\lowerBound{\objf}$, we know that are doing very well.
