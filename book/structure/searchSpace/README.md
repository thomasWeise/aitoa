## The Search Space and Representation Mapping {#sec:searchSpace}

The solution space is the data structure that "makes sense" from the perspective of the user, the decision maker, who will be supplied with one instance of this structure (a candidate solution) at the end of the opimization procedure.
But it not necessarily is the space that is most suitable for searching inside.

### Definitions

\text.block{definition}{searchSpace}{The *search space*&nbsp;$\searchSpace$ is a mapping of the solution space which allows for an efficient generation of candidate solutions.}

\text.block{definition}{searchSpacePoint}{The elements&nbsp;$\sespel\in\searchSpace$ of the search space $\searchSpace$ are called *points* in the search space.}

\text.block{definition}{representationMapping}{The *representation mapping*&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ is a [left-total](http://en.wikipedia.org/wiki/Binary_relation#left-total) relation which maps the points $\sespel\in\searchSpace$ of the search space&nbsp;$\searchSpace$ to the candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$.}

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
If we would design a compact and efficient search space&nbsp;$\searchSpace$ more suitable for our problem, the representation mapping&nbsp;$\repMap$ should thus probably not be surjective, as we then could leave unaccessible as many of the Gantt charts with unnecessary delays as possible.

One idea is to encode the two-dimensional array structure&nbsp;$\solutionSpace$ in a simple linear string of integer numbers&nbsp;$\searchSpace$.
The corresponding representation mapping can best be described by an example.
In the demo instance $\instance$, we have $\elementOf{\instance}{m}=5$ machines and $\elementOf{\instance}{n}=4$ jobs.
Each job has $\elementOf{\instance}{m}=5$  sub-jobs that must be distributed to the machines.
We could use a string of length $\elementOf{\instance}{m}*\elementOf{\instance}{n}=20$ denoting the priority of the sub-jobs.
Since we *know* the order of the sub-jobs per job as part of the problem instance data&nbsp;$\instance$, we do not need to encode it.
This means that we just include each job's id $\elementOf{\instance}{m}=5$ times in the string.

![Illustration of the first four steps of the representation mapping of an example point in the search space to a candidate solution.](\relative.path{demo_mapping.svgz}){#fig:jssp_mapping_demo width=99%}

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

What did we gain by such a mapping?
Well, we now have a very simple data structure&nbsp;$\searchSpace$ to represent our candidate solutions.
We have very simple rules for validating a point&nbsp;$\sespel$ in the search space:
If it contains the numbers&nbsp;$0\dots \elementOf{\instance}{n}$ each exactly&nbsp;$\elementOf{\instance}{m}$ times, it represents a valid candidate solution.
The corresponding candidate solution will never violate any constraint, as the mapping&nbsp;$\repMap$ will ensure that the order of the sub-jobs per job is always observed and each machine will process at most one job at a time.
We now have a basis to indirectly create and modify candidate solutions by sampling points from the search space and moving to similar points, as we will see in the following chapters.

It can also be see that we could modify our representation mapping&nbsp;$\repMap$ to adapt to more complicated and constraint versions of the JSSP:
If, for instance, it would take a job- and machine-dependent time requirement for carry a job from one machine to another, we could facilitate this by adding it to the next starting of the job.
If there was a job-dependent setup time for each machine, which could be different if job&nbsp;1 follows job&nbsp;0 instead of job&nbsp;2, then this could be facilitated easily as well.
Many such different problem flavors can now be reduced of investigating the same space&nbsp;$\searchSpace$ using the same optimization algorithms, just with different representation mappings&nbsp;$\repMap$ and/or objective functions&nbsp;$\objf$.

By using&nbsp;$\searchSpace$, we furthermore get a very clear idea about the size and structure of set of possible solutions.
Each element&nbsp;$\sespel\in\searchSpace$ is a [permutation of a multiset](http://en.wikipedia.org/wiki/Permutation#Permutations_of_multisets) where each of the&nbsp;$\elementOf{\instance}{n}$ elements occurs exactly&nbsp;$\elementOf{\instance}{m}$ times.
This means that the size of the search space can be computed as given in [@eq:jssp_search_space_size].

$$ \left|\searchSpace\right| = \frac{\left(\elementOf{\instance}{m}*\elementOf{\instance}{n}\right)!}{ \left(\elementOf{\instance}{m}!\right)^{\elementOf{\instance}{n}} } $$ {#eq:jssp_search_space_size}

| $\elementOf{\instance}{n}$ | $\elementOf{\instance}{m}$ | $\left|\searchSpace\right|$ |
|--:|--:|--:|
3|2|90
3|3|1'680
3|4|34'650
3|5|756'756
4|2|2'520
4|3|369'600
4|4|63'063'000
4|5|1.17*10^10^
5|2|113'400
5|3|168'168'000
5|4|3.06*10^11^
5|5|6.23*10^14^

: The size&nbsp;$\left|\searchSpace\right|$ of the search space&nbsp;$\searchSpace$ for selected of values of the number of jobs&nbsp;$\elementOf{\instance}{n}$ and the number of machines&nbsp;$\elementOf{\instance}{m}$ of an JSSP instance&nbsp;$\instance$. {#tbl:jsspSearchSpaceTable}

We give some example values for this search space size in [@tbl:jsspSearchSpaceTable].
From the table, we can immediately see that the number of points in the search space grows very quickly with both the number of jobs&nbsp;$\elementOf{\instance}{n}$ and the number of machines&nbsp;$\elementOf{\instance}{m}$ of an JSSP instance&nbsp;$\instance$.

For our `demo` JSSP instance with&nbsp;$\elementOf{\instance}{n}=4$ jobs and&nbsp;$\elementOf{\instance}{m}=5$ machines, we already have about 12 billion different points in the search space.
Of course, there is some redundancy, as our mapping is not [injective](http://en.wikipedia.org/wiki/Injective_function):
If we would exchange the first three numbers in the example string in [@fig:jssp_mapping_demo], we would obtain the same Gantt chart, as jobs&nbsp;0, 1, and&nbsp;2 start at different machines.
Nevertheless, `demo` may already be among the largest instances that we could solve in reasonable time by simply exhaustively enumerating all possible solutions with the computers available today.
For more "realistic" problem instances such as `la24` with 15 jobs and 10 machines we arrive already at 2.29*10^164^ different points in the search space &ndash; and this is the smallest one of the example benchmark instances we will look at.
It is clear that finding the global optima of these instances cannot be done by testing all possible options and we will need something better.