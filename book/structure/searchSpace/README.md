## The Search Space

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
In the demo instance $\instance$, we have $\elementOf{\instance}{m}=5$ machines and $\elementOf{\instance}{n}=4$ jobs.
Each job has $\elementOf{\instance}{m}=5$  sub-jobs that must be distributed to the machines.
We could use a string of length $\elementOf{\instance}{m}*\elementOf{\instance}{n}=20$ denoting the priority of the sub-jobs.
Since we *know* the order of the sub-jobs per job as part of the problem instance data&nbsp;$\instance$, we do not need to encode it.
This means that we just include each job's id $\elementOf{\instance}{m}=5$  times in the string.
