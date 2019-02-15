## The Solution Space {#sec:solutionSpace}

### Definitions

As stated in \text.ref{optimizationProblemEconomical}, an optimization problem asks us to make a choice between different potential solutions.
We call them *candidate solutions*.

\text.block{definition}{candidateSolution}{A *candidate solution*&nbsp;$\solspel$ is one potential solution of an optimization problem.}

\text.block{definition}{solutionSpace}{The *solution space*&nbsp;$\solutionSpace$ of an optimization problem is the set of all of its candidate solutions&nbsp;$\solspel\in\solutionSpace$.}

Basically, the input of an optimization algorithm is the problem instance&nbsp;$\instance$ and the output would be (at least) one candidate solution&nbsp;$\solspel\in\solutionSpace$.
This candidate solution is choice proposed by the optimization process.
From the programmer's perspective, the solution space is again a data structure, e.g., a `class` in Java.
We want to return one instance of this data structure to the user when solving an optimization problem.

### Example: Job Shop Scheduling

What would be a candidate solution to a JSSP instance as defined in [@sec:jsspInstance]?
Recall from [@sec:jsspExample] that our goal is to complete the jobs, i.e., the production tasks, as soon as possible.
Hence, a candidate solution should tell us what to do, i.e., how to process the jobs on the machines.

#### Idea: Gantt Chart

This is basically what a [Gantt chart](http://en.wikipedia.org/wiki/Gantt_chart) is about, as illustrated in [@fig:gantt_demo_without_makespan].
A Gantt chart defines what each of our&nbsp;$\jsspMachines$ machines has to do at each point in time.
The sub-jobs of each job are assigned to time windows on their corresponding machines.

![One example candidate solution for the demo instance given in [@fig:jssp_demo_instance]: A Gantt chart assigning a time window to each job on each machine.](\relative.path{gantt_demo_without_makespan.svgz}){#fig:gantt_demo_without_makespan width=80%}

The Gantt chart contains one row for each machine.
It is to be read from left to right, where the x-axis represents the time units that have passed since the beginning of the job processing.
Each colored bar in the row of a given machine stands for a job and denots the time window during which the job is processed.
The bar representing sub-job&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ is painted in the row of machine&nbsp;$\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex}$ and its length equals the time requirement&nbsp;$\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$.

The chart given in [@fig:gantt_demo_without_makespan], for instance, defines that job&nbsp;0 starts at time unit&nbsp;0 on machine&nbsp;0 and is processed there for ten time units.
Then the machine idles until the 70th time unit, at which point it begins to process job&nbsp;1 for another ten time units.
After 15&nbsp;more time units of idling, job&nbsp;3 will arrive and be processed for 20&nbsp;time units.
Finally, machine&nbsp;0 works on job&nbsp;2 (coming from machine&nbsp;3) for ten time units starting at time unit&nbsp;150.

Machine&nbsp;1 starts its day with an idle period until job&nbsp;2 arrives from machine&nbsp;2 at time unit&nbsp;30 and is processed for 20&nbsp;time units.
It then processes jobs&nbsp;1 and&nbsp;0 consecutively and finishes with job&nbsp;3 after another idle period.
And so on.

If we wanted to create a Java class to represent the complete information from a Gantt diagram, it could look like [@lst:JSSPCandidateSolution].
Here, for each of the&nbsp;$\jsspMachines$ machines, we create one integer array of length&nbsp;$3\jsspJobs$.
Such an array stores three numbers for each of the&nbsp;$\jsspJobs$ sub-jobs to be executed on the machine: the job ID, the start time, and the end time.

\repo.listing{lst:JSSPCandidateSolution}{Excerpt from a Java class for representing the data of a candidate solution to a JSSP.}{java}{src/main/java/aitoa/examples/jssp/JSSPCandidateSolution.java}{}{relevant}

Of course, we would not strictly need a class for that, as we could as well use the integer array `int[][]` directly.
Also the third number, i.e., the end time, is not strictly necessary, as it can be computed based on the instance data as $start+\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex'}$ for job&nbsp;$\jsspJobIndex$ on machine&nbsp;$\jsspMachineIndex$ after searching&nbsp;$\jsspMachineIndex'$ such that $\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex'}=\jsspMachineIndex$.
But the presented structure is handy and easier to understand.

#### Size of the Solution Space {#sec:solutionSpace:size}

It is not directly clear how many Gantt charts exist.
If we allow arbitrary useless waiting times between jobs, then we could create arbitrarily many different valid Gantt charts for any problem instance.
Let us therefore assume that no time is wasted by waiting unnecessarily.

In this case, there exist exactly&nbsp;$\jsspJobs!=\prod_{\jsspJobIndex=1}^{\jsspJobs} \jsspJobIndex$ possible ways to arrange of&nbsp;$\jsspJobs$ on *each* of the&nbsp;$\jsspMachines$ machines.
$\jsspJobs!$, called the [factorial](http://en.wikipedia.org/wiki/Factorial) of&nbsp;$\jsspJobs$, is the number of different [permutations](http://en.wikipedia.org/wiki/Permutation) (or orderings) of&nbsp;$\jsspJobs$ objects.
If we have three jobs $a$, $b$, and $c$, then there are $3!=1*2*3=6$ possible permutations, namely $(a,b,c)$, $(a,c,b)$, $(b,a,c)$, $(b, c, a)$, $(c, a, b)$, and $(c, b, a)$.
If we have three jobs and one machine, this is the number of possible different Gantt charts that do not waste time.

If we would have&nbsp;$\jsspJobs=3$ jobs and&nbsp;$\jsspMachines=2$ machines, we then would have $(3!)^2=36$ possible Gantt charts, as for each of the&nbsp;6 possible sequence of jobs on the first machines, there would be&nbsp;6 possible arrangements on the second machine.
For&nbsp;$\jsspMachines=2$ machines, it is then $(\jsspJobs!)^3$, and so on.
In the general case, we obtain [@eq:jssp_solution_space_size] for the size&nbsp;$\left|\solutionSpace\right|$ of the solution space&nbsp;$\solutionSpace$.

$$ \left|\solutionSpace\right| = (\jsspJobs!)^{\jsspMachines} $$ {#eq:jssp_solution_space_size}

|name|$\jsspJobs$|$\jsspMachines$|$\left|\solutionSpace\right|$|
|:--|--:|--:|--:|
||3|2|36
||3|3|216
||3|4|1'296
||3|5|7'776
||4|2|576
||4|3|13'824
||4|4|331'776
||5|2|14'400
||5|3|1'728'000
||5|4|207'360'000
||5|5|24'883'200'000
`demo`|4|5|7'962'624
`la24`|15|10|$\approx$ 1.462*10^121^
`abz7`|20|15|$\approx$ 6.193*10^275^
`yn4`|20|20|$\approx$ 5.278*10^367^
`swv15`|50|10|$\approx$ 6.772*10^644^

: The size&nbsp;$\left|\solutionSpace\right|$ of the solution space&nbsp;$\solutionSpace$ (without schedules that stall uselessly) for selected of values of the number&nbsp;$\jsspJobs$ of jobs and the number&nbsp;$\jsspMachines$ of machines of an JSSP instance&nbsp;$\instance$. (later compare also with [@fig:function_growth]) {#tbl:jsspSolutionSpaceTable}

We illustrate some examples for the number&nbsp;$\left|\solutionSpace\right|$ of schedules which do not waste time useless in comparison to the problem size in [@tbl:jsspSolutionSpaceTable].
Here we find that even small problems with $\jsspMachines=5$ machines and $\jsspJobs=5$ jobs already have billions of possible solutions.
The four more realistic problem instances which we will try to solve here already have more solutions that what we could ever enumerate, list, or store with any conceivable hardware or computer.
As we cannot simply test all possible solutions and pick the best one, we will need some more sophisticated algorithms to solve these problems &ndash; and this is what we will discuss in the following.
