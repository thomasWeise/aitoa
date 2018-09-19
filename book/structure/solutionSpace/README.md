## The Solution Space

Per \text.ref{optimizationProblemEconomical}, an optimization problem forces us to make a choice between different potential solutions.

\text.block{definition}{candidateSolution}{A *candidate solution*&nbsp;$\sespel$ is one potential solution of an optimization problem.}

\text.block{definition}{solutionSpace}{The *solution space*&nbsp;$\solutionSpace$ of an optimization problem is the set of all of its candidate solutions&nbsp;$\sespel\in\solutionSpace$.}

### Example: Job Shop Scheduling

But what would be a candidate solution to a JSSP instance as defined in [@sec:jsspInstance]?
Such a solution should basically tell us what to do, i.e., how to process the jobs on the machines.
This is basically what a Gantt chart as about, as illustrated in [@fig:gantt_demo_without_makespan].

![One example solution for the demo instance given in [@fig:jssp_demo_instance]: A Gantt chart assigning a time window to each job on each machine.](\relative.path{gantt_demo_without_makespan.svgz}){#fig:gantt_demo_without_makespan width=90%}

A Gantt chart defines what each of our $\elementOf{\instance}{m}$ has to do at each point in time.
Therefore, the sub-jobs of each job are assigned to time windows on their corresponding machines.
The Gantt chart contains one row for each machine.
It is to be read from left to right, where the x-axis represents the time units that have passed since the beginning of the job processing.
A colored bar in the row of a given machine stands for a job and denots the time window when the job is processed.

The chart given in [@fig:gantt_demo_without_makespan], for instance, defines that job&nbsp;0 starts at time unit 0 on machine&nbsp;0 and is processed for ten time units.
Then the machine idles until the 70th time unit, at which point it begins to process job&nbsp;1 for another ten time units.
After 15 more time units of idling, job&nbsp;3 will arrive and be processed for 20 time units.
Finally, machine&nbsp;0 works on job&nbsp;2 (coming from machine&nbsp;3) for ten time units starting at time unit 150.

Machine&nbsp;1 starts its day with an idle period until job&nbsp;2 arrives from Machine&nbsp;2 at time unit 30 and is processed for 20 time units.
It then processes jobs&nbsp;1 and 0 consecutively and finishes with job&nbsp;3 after another idle period.
And so on.