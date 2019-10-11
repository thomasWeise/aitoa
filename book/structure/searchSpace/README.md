## The Search Space and Representation Mapping {#sec:searchSpace}

The solution space&nbsp;$\solutionSpace$ is the data structure that "makes sense" from the perspective of the user, the decision maker, who will be supplied with one instance of this structure (a candidate solution) at the end of the optimization procedure.
But&nbsp;$\solutionSpace$ it not necessarily is the space that is most suitable for searching inside.

We have already seen that there are several constraints that apply to the Gantt charts.
For every problem instance, different solutions may be feasible.
Besides the constraints, the space of Gantt charts also looks kind of unordered, unstructured, and messy.
It would be nice to have a compact, clear, and easy-to-understand representation of the candidate solutions.

### Definitions

\text.block{definition}{searchSpace}{The *search space*&nbsp;$\searchSpace$ is a representation of the solution space&nbsp;$\solutionSpace$ suitable for exploration by an algorithm.}

\text.block{definition}{searchSpacePoint}{The elements&nbsp;$\sespel\in\searchSpace$ of the search space $\searchSpace$ are called *points* in the search space.}

\text.block{definition}{representationMapping}{The *representation mapping*&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ is a [left-total](http://en.wikipedia.org/wiki/Binary_relation#left-total) relation which maps the points&nbsp;$\sespel\in\searchSpace$ of the search space&nbsp;$\searchSpace$ to the candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$.}

For applying an optimization algorithm, we usually choose a data structure&nbsp;$\searchSpace$ which we can understand intuitively.
Ideally, it should be possible to define concepts such as distances, similarity, or neighborhoods on this data structure.
Spaces that are especially suitable for searching in include, for instances:

1. subsets of $s$-dimensional real vectors, i.e., $\realNumbers^s$,
2. the set&nbsp;$\mathSpace{P}(s)$ of sequences/permutations of&nbsp;$s$ objects, and
3. a number of&nbsp;$s$ yes-no decisions, which can be represented as bit strings of length&nbsp;$s$ and spans the space&nbsp;$\{0,1\}^s$.

For such spaces, we can relatively easily define good search methods and can rely on a large amount of existing research work and literature.
If we are lucky, then our solution space&nbsp;$\solutionSpace$ is already "similar" to one of these well-known and well-researched data structures.
Then, we can set&nbsp;$\searchSpace=\solutionSpace$ and use the identity mapping&nbsp;$\repMap(\sespel)=\sespel\forall \sespel\in\searchSpace$ as representation mapping.
In other cases, we will often prefer to map&nbsp;$\solutionSpace$ to something similar to these spaces and define&nbsp;$\repMap$ accordingly.  

The mapping&nbsp;$\repMap$ does not need to be [injective](http://en.wikipedia.org/wiki/Injective_function), as it may map two points&nbsp;$\sespel_1$ and&nbsp;$\sespel_2$ to the same candidate solution even though they are different ($\sespel_1\neq \sespel_2$).
Then, there exists some redundancy in the search space.
We would normally like to avoid redundancy, as it tends to slow down the optimization process&nbsp;[@KW2002OTUOREIMBES].
Being injective is therefore a good feature for&nbsp;$\repMap$.

The mapping&nbsp;$\repMap$ also does not necessarily need to be [surjective](http://en.wikipedia.org/wiki/Surjective_function), i.e., there can be candidate solutions&nbsp;$\solspel\in\solutionSpace$ for which no&nbsp;$\sespel\in\searchSpace$ with $\repMap(\sespel)=\solspel$ exists.
However, such solutions then can never be discovered.
If the optimal solution would reside in the set of such solutions to which no point in the search space can be mapped, then, well, it could not be found by the optimization process.
Being surjective is therefore a good feature for&nbsp;$\repMap$.

\repo.listing{lst:IRepresentationMapping}{A general interface for representation mappings.}{java}{src/main/java/aitoa/structure/IRepresentationMapping.java}{}{relevant}

The interface given in [@lst:IRepresentationMapping] provides a function `map` which maps one point&nbsp;`x` in the search space class&nbsp;`X` to a candidate solution instance&nbsp;`y` of the solution space class&nbsp;`Y`.
We define the interface as [generic](http://en.wikipedia.org/wiki/Generics_in_Java), because we here do not make any assumption about the nature of&nbsp;`X` and&nbsp;`Y`.
This interface therefore truly corresponds to the general definition $\repMap:\searchSpace\mapsto\solutionSpace$ of the representation mapping.
Side note: An implementation of `map` will overwrite whatever contents were stored in object&nbsp;`y` in the process, i.e., we assume that `Y` is a class whose instances can be modified.

### Example: Job Shop Scheduling {#sec:jsspSearchSpace}

In our JSSP example, we have developed the class `JSSPCandidateSolution` given in [@lst:JSSPCandidateSolution] to represent the data of a Gantt chart (candidate solution).
It can easily be interpreted by the user and we have defined a suitable objective function for it in [@lst:JSSPMakespanObjectiveFunction].
Yet, it is not that clear how we can efficiently create such solutions, especially feasible ones, let alone how to *search* in the space of Gantt charts.^[Of course, there are many algorithms that can do that and we could discover one if we think about it for a bit, but here we take the educational route where we investigate the full scenario with $\searchSpace\neq\solutionSpace$.]
What we would like to have is a *search space*&nbsp;$\searchSpace$, which can represent the possible candidate solutions of the problem in a more machine-tangible, algorithm-friendly way.
While comprehensive overviews about different such search spaces for the JSSP can be found in [@CGT1996ATSOJSSPUGAIR, @W2013GAFSSPAS; @A2010RIGAFTJSPACS, @YN1997GAFJSSP], we here develop only one single idea which I find particularly appealing. 

#### Idea: 1-dimensional Encoding

Imagine you would like to construct a Gantt chart as candidate solution for a given JSSP instance.
How would you do that?
Well, we know that each of the $\jsspJobs$&nbsp;jobs has $\jsspMachines$&nbsp;sub-jobs, one for each machine.
We could simply begin by choosing one job and placing its first sub-job on the machine to which it belongs, i.e., write it into the Gantt chart.
Then we again pick a job, take the first not-yet-scheduled sub-job of this job, and "add" it to the end of the row of its corresponding machine in the Gantt chart.
Of course, we cannot pick a job whose sub-jobs all have already be assigned.
We can continue doing this until all jobs are assigned &ndash; and we will get a valid solution.

This solution is defined by the order in which we chose the jobs.
Such an order can be described as a simple, linear string of job IDs, i.e., of integer numbers.
If we process such a string from the beginning to the end and step-by-step assign the jobs, we get a feasible Gantt chart as result.

The encoding and corresponding representation mapping can best be described by an example.
In the demo instance, we have&nbsp;$\jsspMachines=5$ machines and&nbsp;$\jsspJobs=4$ jobs.
Each job has&nbsp;$\jsspMachines=5$ sub-jobs that must be distributed to the machines.
We use a string of length&nbsp;$\jsspMachines*\jsspJobs=20$ denoting the priority of the sub-jobs.
We *know* the order of the sub-jobs per job as part of the problem instance data&nbsp;$\instance$.
We therefore do not need to encode it.
This means that we just include each job's id&nbsp;$\jsspMachines=5$ times in the string.
This was the original idea: The encoding represents the order in which we assign the $\jsspJobs$&nbsp;jobs, and each job must be picked $\jssoMachines$&nbsp;times.
Our search space is thus somehow similar to the set&nbsp;$\mathSpace{P}(\jsspJobs*\jsspMachines)$ of permutations of&nbsp;$\jsspJobs*\jsspMachines$ objects mentioned earlier, but instead of permutations, we have *permutations with repetitions*.

![Illustration of the first four steps of the representation mapping of an example point in the search space to a candidate solution.](\relative.path{demo_mapping.svgz}){#fig:jssp_mapping_demo width=99%}
 
A point&nbsp;$\sespel\in\searchSpace$ in the search space&nbsp;$\searchSpace$ for the `demo` JSSP instance would thus be an integer string of length&nbsp;20.
As example, we chose $\sespel=(0, 2, 1, 0, 3, 1, 0, 1, 2, 3, 2, 1, 1, 2, 3, 0, 2, 0, 3, 3)$ in [@fig:jssp_mapping_demo].
The representation mapping starts with an empty Gantt chart.
This string is interpreted from left to right, as illustrated in the figure.
The first value is&nbsp;0, which means that job&nbsp;0 is assigned to a machine first.
From the instance data, we know that job&nbsp;0 first must be executed for 10&nbsp;time units on machine&nbsp;0.
The job is thus inserted on machine&nbsp;0 in the chart.
Since machine&nbsp;0 is initially idle, it can be placed at time index&nbsp;0.
We also know that this sub-job can definitely be executed, i.e., won't cause a deadlock, because it is the first sub-job of the job.

The next number in the string is&nbsp;2, so job&nbsp;2 is next.
This job needs to go for 30 time units to machine&nbsp;2, which also is initially idle.
So it can be inserted into the candidate solution directly as well (and cannot cause any deadlock either).

Then job&nbsp;1 is next in&nbsp;$\sespel$, and from the instance data we can see that it will go to machine&nbsp;1 for 20 time units.
This machine is idle as well, so the job can start immediately.

We now encounter job&nbsp;0 again in the integer string.
Since we have already performed the first sub-job of job&nbsp;0, we now would like to schedule its second sub-job.
According to the instance data, the second sub-job takes place on machine&nbsp;1 and will take 20&nbsp;time units.
We know that completing the first sub-job took 10&nbsp;time units.
We also know that machine&nbsp;1 first has to process job&nbsp;1 for 20&nbsp;time units.
The earliest possible time at which we can begin with the second sub-job of job&nbsp;0 is thus at time unit&nbsp;20, namely the bigger one of the above two values.
This means that job&nbsp;0 has to wait for 10&nbsp;time units after completing its first sub-job and then can be processed by machine&nbsp;1.
No deadlock can occur, as we made sure that the first sub-job of job&nbsp;0 has been scheduled before the second one.

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

We continue this iterative processing until reaching the end of the string&nbsp;$\sespel$.
We now have constructed the complete Gantt chart&nbsp;$\solspel$ illustrated in [@fig:jssp_mapping_demo].
Whenever we assign a sub-job&nbsp;$\jsspJobIndex>0$ of any given job to a machine, then we already had assigned all sub-jobs at smaller indices first.
No deadlock can occur and&nbsp;$\solspel$ must therefore be feasible.

\repo.listing{lst:JSSPRepresentationMapping}{Excerpt from a Java class for implementing the representation mapping.}{java}{src/main/java/aitoa/examples/jssp/JSSPRepresentationMapping.java}{}{relevant}

In [@lst:JSSPRepresentationMapping], we illustrate how such a mapping can be implemented.
It basically is a function translating an instance of `int[]` to `JSSPCandidateSolution`.
This is done by keeping track of time that has passed for each machine and each job, as well as by remembering the next sub-job for each job and the position in the schedule of each machine.

#### Advantages of a very simple Encoding

This is a very nice and natural way to represent Gantt charts with a much simpler data structure.
As a result, it has been discovered by several researchers independently, the earliest being Gen et&nbsp;al.&nbsp;[@GTK1994SJSSPBGA], Bierwirth&nbsp;[@B1995AGPATJSSWGA; @BMK1996OPRFSP], and Shi et&nbsp;al.&nbsp;[@SIS1997NESFSJSPBGA], all in the 1990s.

But what do we gain by using this search space and representation mapping?
First, well, we now have a very simple data structure&nbsp;$\searchSpace$ to represent our candidate solutions.
Second, we also have very simple rules for validating a point&nbsp;$\sespel$ in the search space:
If it contains the numbers&nbsp;$0\dots (\jsspJobs-1)$ each exactly&nbsp;$\jsspMachines$ times, it represents a feasible candidate solution.

Third, the candidate solution corresponding to a valid point from the search space will always be *feasible*&nbsp;[@B1995AGPATJSSWGA].
The mapping&nbsp;$\repMap$ will ensure that the order of the sub-jobs per job is always observed.
We do not need to worry about the issue of deadlocks mentioned in [@sec:solutionSpace:feasibility].
We know from [@tbl:jsspSolutionSpaceTable], that the vast majority of the possible Gantt charts for a given problem may be infeasible &ndash; and now we do no longer need to worry about that. 
Our mapping also makes sure of the more trivial constraints, such as that each machine will process at most one job at a time and that all sub-jobs are eventually processed.

Finally, we also could modify our representation mapping&nbsp;$\repMap$ to adapt to more complicated and constraint versions of the JSSP if need be:
For example, imagine that it would take a job- and machine-dependent time requirement for carrying a job from one machine to another, then we could facilitate this by changing&nbsp;$\repMap$ so that it adds this time to the starting time of the job.
If there was a job-dependent setup time for each machine&nbsp;[@ANCK2008ASOSPWSTOC], which could be different if job&nbsp;1 follows job&nbsp;0 instead of job&nbsp;2, then this could be facilitated easily as well.
If our sub-jobs would be assigned to "machine types" instead of "machines" and there could be more than one machine per machine type, then the representation mapping could assign the sub-jobs to the next machine of their type which becomes idle.
Our representation also trivially covers the situation where each job may have more than&nbsp;$\jsspMachines$ operations, i.e., where a job may need to cycle back and pass one machine twice.
It is also suitable to simple scenarios, such as the [Flow Shop Problem](http://en.wikipedia.org/wiki/Flow_shop_scheduling), where all jobs pass through the machines in the same, pre-determined order&nbsp;[@T199BFBSP; @GJS1976TCOFAJS; @W2013GAFSSPAS].

Many such different problem flavors can now be reduced to investigating the same space&nbsp;$\searchSpace$ using the same optimization algorithms, just with different representation mappings&nbsp;$\repMap$ and/or objective functions&nbsp;$\objf$.
Additionally, it became very easy to indirectly create and modify candidate solutions by sampling points from the search space and moving to similar points, as we will see in the following chapters.

#### Size of the Search Space

It is relatively easy to compute the size&nbsp;$\left|\searchSpace\right|$ of our proposed search space&nbsp;$\searchSpace$&nbsp;[@SIS1997NESFSJSPBGA].
We do not need to make any assumptions regarding "no useless waiting time", as in [@sec:solutionSpace:size], since this is not possible by default.
Each element&nbsp;$\sespel\in\searchSpace$ is a [permutation of a multiset](http://en.wikipedia.org/wiki/Permutation#Permutations_of_multisets) where each of the&nbsp;$\jsspJobs$ elements occurs exactly&nbsp;$\jsspMachines$ times.
This means that the size of the search space can be computed as given in [@eq:jssp_search_space_size].

$$ \left|\searchSpace\right| = \frac{\left(\jsspMachines*\jsspJobs\right)!}{ \left(\jsspMachines!\right)^{\jsspJobs} } $$ {#eq:jssp_search_space_size}

|name|$\jsspJobs$|$\jsspMachines$|$\left|\solutionSpace\right|$|$\left|\searchSpace\right|$|
|:--|--:|--:|--:|--:|
||3|2|36|90
||3|3|216|1'680
||3|4|1'296|34'650
||3|5|7'776|756'756
||4|2|576|2'520
||4|3|13'824|369'600
||4|4|331'776|63'063'000
||5|2|14'400|113'400
||5|3|1'728'000|168'168'000
||5|4|207'360'000|305'540'235'000
||5|5|24'883'200'000|623'360'743'125'120
demo|4|5|7'962'624|11'732'745'024
la24|15|10|$\approx$&nbsp;1.462*10^121^|$\approx$&nbsp;2.293*10^164^
abz7|20|15|$\approx$&nbsp;6.193*10^275^|$\approx$&nbsp;1.432*10^372^
yn4|20|20|$\approx$&nbsp;5.278*10^367^|$\approx$&nbsp;1.213*10^501^
swv15|50|10|$\approx$&nbsp;6.772*10^644^|$\approx$&nbsp;1.254*10^806^

: The sizes&nbsp;$\left|\searchSpace\right|$ and&nbsp;$\left|\solutionSpace\right|$ of the search and solution spaces for selected values of the number&nbsp;$\jsspJobs$ of jobs and the number&nbsp;$\jsspMachines$ of machines of an JSSP instance&nbsp;$\instance$. (compare with [@fig:function_growth] and with the size&nbsp;$\left|\solutionSpace\right|$ of the solution space); compare with [@fig:jssp_searchspace_size_scale] {#tbl:jsspSearchSpaceTable}

We give some example values for this search space size&nbsp;$\left|\searchSpace\right|$ in [@tbl:jsspSearchSpaceTable].
From the table, we can immediately see that the number of points in the search space, too, grows very quickly with both the number of jobs&nbsp;$\jsspJobs$ and the number of machines&nbsp;$\jsspMachines$ of an JSSP instance&nbsp;$\instance$.

For our `demo` JSSP instance with&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines, we already have about 12&nbsp;billion different points in the search space and 7&nbsp;million possible, non-wasteful candidate solutions.

We now find the drawback of our encoding: There is some redundancy in our mapping, $\repMap$&nbsp;here is not injective.
If we would exchange the first three numbers in the example string in [@fig:jssp_mapping_demo], we would obtain the same Gantt chart, as jobs&nbsp;0, 1, and&nbsp;2 start at different machines.

As said before, we should avoid redundancy in the search space.
However, here we will stick with our proposed mapping because it is very simple, it solves the problem of feasibility of candidate solutions, and it allows us to relatively easily introduce and discuss many different approaches, algorithms, and sub-algorithms. 
