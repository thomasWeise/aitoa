## The Search Space and Representation Mapping

The solution space is the data structure that "makes sense" from the perspective of the user, the decision maker, who will be supplied with one instance of this structure (a candidate solution) at the end of the opimization procedure.
But it not necessarily is the space that is most suitable for searching inside.

### Definitions

\text.block{definition}{searchSpace}{The *search space*&nbsp;$\searchSpace$ is a mapping of the solution space which allows for an efficient generation of candidate solutions.}

\text.block{definition}{searchSpacePoint}{The elements&nbsp;$\sespel\in\searchSpace$ of the search space $\searchSpace$ are called *points* in the search space.}

\text.block{definition}{representationMapping}{The *representation mapping*&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ maps the points $\sespel\in\searchSpace$ of the search space&nbsp;$\searchSpace$ to the candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$.}

The mapping&nbsp;$\repMap$ does not need to be [injective](http://en.wikipedia.org/wiki/Injective_function), as it may map two points&nbsp;$\sespel_1$ and&nbsp;$\sespel_2$ to the same candidate solution even though they are different ($\sespel_1\neq \sespel_2$).
Then, there exists some redundancy in the search space (which we would normally like to avoid).

The mapping&nbsp;$\repMap$ also does not necessarily need to be [surjective](http://en.wikipedia.org/wiki/Surjective_function), i.e., there can be candidate solutions&nbsp;$\solspel\in\solutionSpace$ for which no&nbsp;$\sespel\in\searchSpace$ with $\repMap(\sespel)=\solspel$ exists.
However, such solutions then can never be discovered.

\repo.listing{lst:IRepresentationMapping}{A general interface for representation mappings.}{java}{src/main/java/aitoa/structure/IRepresentationMapping.java}{}{}

The [generic](http://en.wikipedia.org/wiki/Generics_in_Java) interface given in [@lst:IRepresentationMapping] provides a function `map` which maps one point&nbsp;`x` in the search space class&nbsp;`X` to a candidate solution instance&nbsp;`y` of the solution space class&nbsp;`Y`.
It will overwrite whatever contents were stored in&nbsp;`y` in the process, i.e., we assume that `Y` is a class whose instances can be modified.

### Example: Job Shop Scheduling

In our JSSP example, we have developed the class `JSSPCandidateSolution` given in [@lst:JSSPCandidateSolution] to represent the data of a Gantt chart (candidate solution).
It can easily be interpreted by the user and we have defined a suitable objective function for it in [@lst:JSSPMakespanObjectiveFunction].
Yet, it is not that clear how we can efficiently create such solutions let alone how to *search* in the space of Gantt charts.
What we would like to have is a *search space*&nbsp;$\searchSpace$, which can represent the possible candidate solutions of the problem in a more machine-tangible, algorithm-friendly way.

Furthermore, this space also contains a lot us uninteresting candidate solutions, as we can always add useless idle time to an existing Gantt chart and the resulting (longer) chart would still be a valid solution (although one which will definitely be inferior of what we had before).
If we would design a compact and efficient search space&nbsp;$\searchSpace$ more suitable for our problem, the representation mapping&nbsp;$\repMap$ should thus probably be injective but not surjective.
If different points in the search space to different candidate Gantt charts, i.e., $\sespel_1,\sespel_2\in\searchSpace \land \sespel_1 \neq \sespel_2 \Rightarrow \repMap(\sespel_1) \neq \repMap(\sespel_2)$.
At the same time, it should leave unaccessible as many of the Gantt charts with unnecessary delays as possible.

One idea is to encode the two-dimensional structure&nbsp;$\solutionSpace$ in a simple one-dimensional string of integer numbers&nbsp;$\searchSpace$.
The corresponding representation mapping can best be described by an example.
In the demo instance $\instance$, we have $\elementOf{\instance}{m}=5$ machines and $\elementOf{\instance}{n}=4$ jobs.
Each job has $\elementOf{\instance}{m}=5$  sub-jobs that must be distributed to the machines.
We could use a string of length $\elementOf{\instance}{m}*\elementOf{\instance}{n}=20$ denoting the priority of the sub-jobs.
Since we *know* the order of the sub-jobs per job as part of the problem instance data&nbsp;$\instance$, we do not need to encode it.
This means that we just include each job's id $\elementOf{\instance}{m}=5$ times in the string.

![Illustration of the first four steps of the representation mapping of an example point&nbsp;$\sespel\in\searchSpace$ in the integer string search space&nbsp;$\searchSpace$ to a candidate solution&nbsp;$\solspel\in\solutionSpace$ by using the instance data&nbsp;$\instance$ for the `demo` JSSP instance.](\relative.path{demo_mapping.svgz}){#fig:jssp_mapping_demo width=100%}

A point&nbsp;$\sespel\in\searchSpace$ in the search space&nbsp;$\searchSpace$ for the `demo` JSSP instance would thus be an integer string of length 20.
As example, we chose $\sespel=(0, 2, 1, 0, 3, 1, 0, 1, 2, 3, 2, 1, 1, 2, 3, 0, 2, 0, 3, 3)$ in [@fig:jssp_mapping_demo].
The representation mapping starts with an empty Gantt chart.
This string is interpreted from left to right, as illustrated in the figure.
The first value is&nbsp;0, which means that job&nbsp;0 is assigned to a machine first.
From the instance data, we know that job&nbsp;0 first must be executed for 10 time units on machine&nbsp;0.
The job is thus inserted on machine&nbsp;0 in the chart.
Since machine&nbsp;0 is initially idle, it can be placed at time index&nbsp;0.

The next number in the string is&nbsp;2, so job&nbsp;2 is next.
This job needs to go for 30 time units to machine&nbsp;2, which also is initally idle.
So it can be inserted into the candidate solution directly as well.

Then job&nbsp;1 is next in&nbsp;$\sespel$, and from the instance data we can see that it will go to machine&nbsp;1 for 20 time units.
This machine is idle as well, so the job can start immediately.

We now encounter job&nbsp;0 again in the integer string.
Since we have already performed the first sub-job of job&nbsp;0, we now would like to schedule its second sub-job.
According to the instance data, the second sub-job takes place on machine&nbsp;1 and will take 20 time units.
We know that completing the first sub-job took 10 time units.
We also know that machine&nbsp;1 first has to process job&nbsp;1 for 20 time units.
The earliest possible time at which we can begin with the second sub-job of job&nbsp;0 is thus at time unit 20, namely the bigger one of the above two values.
This means that job&nbsp;0 has to wait for 10 time units after completing its first sub-job and then can be processed by machine&nbsp;1.

We now encounter job&nbsp;3 in the integer string, and we know that job&nbsp;3 first goes to machine&nbsp;4, which currently is idle.
It can thus directly be placed on machine&nbsp;4, which it will occupy for 50 time units.

Then we again encounter job&nbsp;1 in the integer string.
Job&nbsp;1 should, in its second sub-job, go to machine&nbsp;0.
Its first sub-job to 20 time units on machine&nbsp;1, while machine&nbsp;0 was occupied for 10 time units by job&nbsp;0.
We can thus start the second sub-job of job&nbsp;1 directly at time index&nbsp;20.

Further processing of&nbsp;$\solspel$ leads us to job&nbsp;0 again, which means we will need to schedule its third sub-job, which will need 20 time units on machine&nbsp;2.
Machine&nbsp;2 is occupied by job&nbsp;2 from time unit&nbsp;0 to&nbsp;30 and becomes idle thereafter.
The second sub-job of job&nbsp;0 finishes on time index&nbsp;40 at machine&nbsp;1.
Hence, we can begin with the third sub-job at time index&nbsp;40 at machine&nbsp;2, which had to idle for 10 time units.

We continue this iterative processing until reaching the end of the string&nbsp;$\sespel$, at which point we have constructed the complete Gantt chart illustrated in [@fig:jssp_mapping_demo].

\repo.listing{lst:JSSPRepresentationMapping}{Excerpt from a Java class for implementing the representation mapping.}{java}{src/main/java/aitoa/examples/jssp/JSSPRepresentationMapping.java}{}{relevant}

In [@lst:JSSPRepresentationMapping], we illustrate how such a mapping can be implemented.
It basically is a function translating an instance of `int[]` to `JSSPCandidateSolution`.
This is done by keeping track of time that has passed for each machine and each job, as well as by remembering the next sub-job for each job and the position in the schedule of each machine.