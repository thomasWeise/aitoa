## Global Optima

### Definitions

Assume that we have a single objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ defined over a solution space&nbsp;$\solutionSpace$.
This objective function is our primary guide during the search.
But what are we looking for?

\text.block{definition}{globalOptimum}{If a candidate solution$\globalOptimum{\solspel}\in\solutionSpace$ is a *global optimum* for an optimization problem defined over the solution space&nbsp;$\solutionSpace$, then is no other candidate solution in&nbsp;$\solutionSpace$ which is better.}

\text.block{definition}{globalOptimumSO}{For every *global optimum*&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ of single-objective optimization problem with solution space&nbsp;$\solutionSpace$ and objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ subject to minimization, it holds that $\objf(\solspel)\geq\objf(\globalOptimum{\solspel})\forall\solspel\in\solutionSpace$.}

When solving an optimization problem, we hope to find at least one global optimum (there may be multiple).
However, often, this may not be possible.
For example, sometimes we have no way to find out whether a solution is a global optimum or not.
In such a case, we hope for finding a good *approximation* of the optimum, i.e., a solution which is very good with respect to the objective function.

### Example: Job Shop Scheduling

We have already defined our solution space&nbsp;$\solutionSpace$ for the JSSP in [@lst:JSSPCandidateSolution] and the objective function&nbsp;$\objf$ in [@lst:IObjectiveFunction].
A Gantt chart with the shortest makespan is then a global optimum.
There may be multiple globally optimal solutions, which then would all have the same makespan.