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
