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

### Example: Job Shop Scheduling {#sec:jsspSearchSpace}

In our JSSP example, we have developed the class `JSSPCandidateSolution` given in [@lst:JSSPCandidateSolution] to represent the data of a Gantt chart (candidate solution).
It can easily be interpreted by the user and we have defined a suitable objective function for it in [@lst:JSSPMakespanObjectiveFunction].
Yet, it is not that clear how we can efficiently create such solutions let alone how to *search* in the space of Gantt charts.
What we would like to have is a *search space*&nbsp;$\searchSpace$, which can represent the possible candidate solutions of the problem in a more machine-tangible, algorithm-friendly way.

#### Idea: 1-dimensional Encoding

One idea is to encode the two-dimensional array structure&nbsp;$\solutionSpace$ in a simple linear string of integer numbers&nbsp;$\searchSpace$.
The corresponding representation mapping can best be described by an example.
In the demo instance, we have&nbsp;$\jsspMachines=5$ machines and&nbsp;$\jsspJobs=4$ jobs.
Each job has&nbsp;$\jsspMachines=5$  sub-jobs that must be distributed to the machines.
We could use a string of length&nbsp;$\jsspMachines*\jsspJobs=20$ denoting the priority of the sub-jobs.
Since we *know* the order of the sub-jobs per job as part of the problem instance data&nbsp;$\instance$, we do not need to encode it.
This means that we just include each job's id&nbsp;$\jsspMachines=5$ times in the string.

![Illustration of the first four steps of the representation mapping of an example point in the search space to a candidate solution.](\relative.path{demo_mapping.svgz}){#fig:jssp_mapping_demo width=99%}

A point&nbsp;$\sespel\in\searchSpace$ in the search space&nbsp;$\searchSpace$ for the `demo` JSSP instance would thus be an integer string of length&nbsp;20.
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

#### Advantages of a very simple Encoding

What did we gain by such a mapping?

We now have a very simple data structure&nbsp;$\searchSpace$ to represent our candidate solutions.
We have very simple rules for validating a point&nbsp;$\sespel$ in the search space:
If it contains the numbers&nbsp;$0\dots (\jsspJobs-1)$ each exactly&nbsp;$\jsspMachines$ times, it represents a valid candidate solution.

An even more salient advantage may be that the candidate solution corresponding to a valid point from the search space will always be *feasible*.
The mapping&nbsp;$\repMap$ will ensure that the order of the sub-jobs per job is always observed.
Each machine will process at most one job at a time.
And we do not need to worry about the issue of deadlocks mentioned in [@sec:solutionSpace:feasibility] either.

We could also modify our representation mapping&nbsp;$\repMap$ to adapt to more complicated and constraint versions of the JSSP if need be:
For example, imagine that it would take a job- and machine-dependent time requirement for carrying a job from one machine to another, then we could facilitate this by changing&nbsp;$\repMap$ so that it adds this time to the starting time of the job.
If there was a job-dependent setup time for each machine, which could be different if job&nbsp;1 follows job&nbsp;0 instead of job&nbsp;2, then this could be facilitated easily as well.
If our sub-jobs would be assigned to "machine types" instead of "machines" and there could be more than one machine per machine type, then the representation mapping could assign the sub-jobs to the next machine of their type which becomes idle.
Many such different problem flavors can now be reduced of investigating the same space&nbsp;$\searchSpace$ using the same optimization algorithms, just with different representation mappings&nbsp;$\repMap$ and/or objective functions&nbsp;$\objf$.
Additionally, it became very easy to indirectly create and modify candidate solutions by sampling points from the search space and moving to similar points, as we will see in the following chapters.

#### Size of the Search Space

It is rather easy to compute the size&nbsp;$\left|\searchSpace\right|$ of our proposed &nbsp;$\searchSpace$.
We do not need to make any assumptions regarding "no useless waiting time", as in [@sec:solutionSpace:size], since this is not possible by default.
Each element&nbsp;$\sespel\in\searchSpace$ is a [permutation of a multiset](http://en.wikipedia.org/wiki/Permutation#Permutations_of_multisets) where each of the&nbsp;$\jsspJobs$ elements occurs exactly&nbsp;$\jsspMachines$ times.
This means that the size of the search space can be computed as given in [@eq:jssp_search_space_size].

$$ \left|\searchSpace\right| = \frac{\left(\jsspMachines*\jsspJobs\right)!}{ \left(\jsspMachines!\right)^{\jsspJobs} } $$ {#eq:jssp_search_space_size}

|name|$\jsspJobs$|$\jsspMachines$|$\lowerBound(\#\textnormal{feasible})$|$\left|\solutionSpace\right|$|$\left|\searchSpace\right|$|
|:--|--:|--:|--:|--:|--:|
||3|2|22|36|90
||3|3|63|216|1'680
||3|4|147|1'296|34'650
||3|5|317|7'776|756'756
||4|2|244|576|2'520
||4|3|1'630|13'824|369'600
||4|4||331'776|63'063'000
||5|2|4'548|14'400|113'400
||5|3|91'461|1'728'000|168'168'000
||5|4||207'360'000|305'540'235'000
||5|5||24'883'200'000|623'360'743'125'120
demo|4|5||7'962'624|11'732'745'024
la24|15|10||$\approx$&nbsp;1.462*10^121^|$\approx$&nbsp;2.293*10^164^
abz7|20|15||$\approx$&nbsp;6.193*10^275^|$\approx$&nbsp;1.432*10^372^
yn4|20|20||$\approx$&nbsp;5.278*10^367^|$\approx$&nbsp;1.213*10^501^
swv15|50|10||$\approx$&nbsp;6.772*10^644^|$\approx$&nbsp;1.254*10^806^

: The sizes&nbsp;$\left|\searchSpace\right|$ and&nbsp;$\left|\solutionSpace\right|$ of the search and solution spaces, as well as the lower bound&nbsp;$\lowerBound(\#\textnormal{feasible})$ of the number of feasible solutions for selected of values of the number&nbsp;$\jsspJobs$ of jobs and the number&nbsp;$\jsspMachines$ of machines of an JSSP instance&nbsp;$\instance$. (compare with [@fig:function_growth] and with the size&nbsp;$\left|\solutionSpace\right|$ of the solution space) {#tbl:jsspSearchSpaceTable}

We give some example values for this search space size&nbsp;$\left|\searchSpace\right|$ in [@tbl:jsspSearchSpaceTable].
From the table, we can immediately see that the number of points in the search space, too, grows very quickly with both the number of jobs&nbsp;$\jsspJobs$ and the number of machines&nbsp;$\jsspMachines$ of an JSSP instance&nbsp;$\instance$.

For our `demo` JSSP instance with&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines, we already have about 12&nbsp;billion different points in the search space and 7&nbsp;million possible, non-wasteful candidate solutions.
From the table we also see that there is some redundancy in our mapping, $\repMap$&nbsp;here is not [injective](http://en.wikipedia.org/wiki/Injective_function):
If we would exchange the first three numbers in the example string in [@fig:jssp_mapping_demo], we would obtain the same Gantt chart, as jobs&nbsp;0, 1, and&nbsp;2 start at different machines.

In practice we should avoid redundancy in the search space, as it will slow down our algorithm&nbsp;[@KW2002OTUOREIMBES].
However, here we will stick with our proposed mapping because it is very simple, it solves the problem of feasibility of candidate solutions, and it allows me to relatively easily introduce and discuss many different approaches, algorithms, and sub-algorithms.
