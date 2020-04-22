## Objective Function {#sec:objectiveFunction}

We now know the most important input and output data for an optimization algorithm: the problem instances&nbsp;$\instance$ and candidate solutions&nbsp;$\solspel\in\solutionSpace$, respectively.
But we do not just want to produce some output, not just want to find "any" candidate solution &ndash; we want to find the "good" ones.
For this, we need a measure rating the solution quality.

### Definitions

\text.block{definition}{objectiveFunction}{An *objective function* $\objf:\solutionSpace\mapsto\realNumbers$ rates the quality of a candidate solution $\solspel\in\solutionSpace$ from the solution space $\solutionSpace$ as real number.}

\text.block{definition}{objectiveValue}{An *objective value* $\objf(\solspel)$ of the candidate solution $\solspel\in\solutionSpace$ is the value that the objective function $\objf$ takes on for $\solspel$.}

Without loss of generality, we assume that all objective functions are subject to *minimization*, meaning that smaller objective values are better.
In this case, a candidate solution&nbsp;$\solspel_1\in\solutionSpace$ is better than another candidate solution&nbsp;$\solspel_2\in\solutionSpace$ if and only if&nbsp;$\objf(\solspel_1)<\objf(\solspel_2)$.
If&nbsp;$\objf(\solspel_1)>\objf(\solspel_2)$, then&nbsp;$\solspel_2$ would be better and for&nbsp;$\objf(\solspel_1)=\objf(\solspel_2)$, there would be no benefit of either solution over the other, at least from the perspective of the optimization criterion&nbsp;$\objf$.
The minimization scenario fits to situations where&nbsp;$\objf$ represents a cost, a time requirement, or, in general, any number of required resources.

Maximization problems, i.e., where the candidate solution with the higher objective value is better, are problems where the objective function represents profits, gains, or any other form of positive output or result of a scenario.
Maximization and minimization problems can be converted to each other by simply negating the objective function.
In other words, if&nbsp;$\objf$ is the objective function of a minimization problem, we can solve the maximization problem with&nbsp;$-\objf$ and get the same result, and vice versa.

From the perspective of a Java programmer, the general concept of objective functions can be represented by the interface given in [@lst:IObjectiveFunction].
The `evaluate` function of this interface accepts one instance of the solution space class&nbsp;`Y` and returns a `double` value.
`double`s are floating point numbers in Java, i.e., represent a subset of the real numbers.
We keep the interface generic, so that we can implement it for arbitrary solution spaces.
Any actual objective function would then be an implementation of that interface.

\repo.listing{lst:IObjectiveFunction}{A generic interface for objective functions.}{java}{src/main/java/aitoa/structure/IObjectiveFunction.java}{}{relevant}

### Example: Job Shop Scheduling {#sec:jsspObjectiveFunction}

As stated in [@sec:jsspExample], our goal is to complete the production jobs as soon as possible.
This means that we want to minimize the makespan, the time when the last job finishes.
Obviously, the smaller this value, the earlier we are done with all jobs, the better is the plan.
As illustrated in [@fig:gantt_demo_with_makespan], the makespan is the time index of the right-most edge of any of the machine rows/schedules in the Gantt chart.
In the figure, this happens to be the end time&nbsp;230 of the last operation of job&nbsp;0, executed on machine&nbsp;4.

![The makespan (purple), i.e., the time when the last job is completed, for the example candidate solution illustrated in [@fig:gantt_demo_without_makespan] for the demo instance from [@fig:jssp_demo_instance].](\relative.path{gantt_demo_with_makespan.svgz}){#fig:gantt_demo_with_makespan width=80%}

Our objective function&nbsp;$\objf$ is thus equivalent to the makespan and subject to minimization.
Based on our candidate solution data structure from [@lst:JSSPCandidateSolution], we can easily compute&nbsp;$\objf$.
We simply have to look at the last number in each of the integer arrays stored in the member `schedule`, as it represents the end time of the last job processed by a machine.
We then return the largest of these numbers.
We implement the interface `IObjectiveFunction` in class `JSSPMakespanObjectiveFunction` accordingly in [@lst:JSSPMakespanObjectiveFunction].

\repo.listing{lst:JSSPMakespanObjectiveFunction}{Excerpt from a Java class computing the makespan resulting from a candidate solution to the JSSP.}{java}{src/main/java/aitoa/examples/jssp/JSSPMakespanObjectiveFunction.java}{}{relevant}

With this objective function&nbsp;$\objf$, subject to minimization, we have defined that a Gantt chart&nbsp;$\solspel_1$ is better than another Gantt chart&nbsp;$\solspel_2$ if and only if $\objf(\solspel_1)<\objf(\solspel_2)$.^[under the assumption that both are feasible, of course]
