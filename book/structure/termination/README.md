## The Termination Criterion and the Problem of Measuring Time {#sec:terminationCriterion}

We have seen that the search space for even small instances of the JSSP can already be quite large.
We simply cannot enumerate all of them, as it would take too long.
This raises the question that if we cannot look at all possible solutions, how can we find the global optimum?
Actually, we may ask, if we cannot look at all possible solutions, how can we know whether a given candidate solution is the global optimum or not?
In many optimization scenarios, we can use theoretical bounds to solve that issue, but a priori, these questions are valid and their answer is simply: *No*.
No, without any further theoretical investigation of the optimization problem, we don't know if the best solution we know so far is the global optimum or not.
This leads us to another problem:
If we do not know whether we found the best-possible solution or not, how do we know if we can stop the optimization process or should continue trying to solve the problem?
There are two basic answers:
Either when the time is up or when we found a reasonably-good solution.

### Definitions

\text.block{definition}{terminationCriterion}{The *termination criterion*&nbsp;$\shouldTerminate\mapsto\{true,false\}$ is a monotonous function of the state of the optimization process which becomes `true` if the optimization process should stop (and then remains `true`) and, until then, remains `false` as long as it can continue.}

\repo.listing{lst:ITerminationCriterion}{A general interface for termination criteria.}{java}{src/main/java/aitoa/structure/ITerminationCriterion.java}{}{}

With a termination criterion defined as implementation of the interface given in [@lst:ITerminationCriterion], we can embedd any combination of time or solution quality limits.
For solution quality, the concept is relatively simple:
We know a goal objective value&nbsp;$g$ and can stop the optimization procedure as soon as a candidate solution&nbsp;$\solspel\in\solutionSpace$ has been discovered with $\objf(\solspel)\leq g$, i.e., which is at least as good as the goal.

If we base the termination criterion on the consumed time, we have two basic choices:

\text.block{definition}{clockTime}{The consumed *clock time* is the time that has passed since the optimization process was started.}

\text.block{definition}{fes}{The consumed *function evaluations*&nbsp;(FEs) are the number of calls to the objective function issued since the beginning of the optimization process.}

Measuring and defining limits for the clock time has several advantages.
In a practical scenario, this is the relevant dimension.
The operator starts the optimization process and waits for the result &ndash; and there is a limit on how long she will accept to wait.
The quantity "time" makes physical sense, too.
Many research works thus report their results together with consumed clock times.
Finally, measuring the clock time contains all "internal" sources of delay in optimization, such as loading files, converting data structures, memory management, etc.

From the scientific point of view, it also has disdavantages, though.
Foremost: It is strongly machine dependent.
This has two implications:
First, all results in this book reported based on clock time might be outdated when you read this text.
Second, it will be virtually impossible to exactly replicate experimental the results, as one would need the exactly same software and hardware setup.
Also, there can be several factors introducing noise into the results, such as schedule by the operating system and I/O delays.
These issues render research reported using clock time somewhat incomparable.

In scientific work, we often report the consumed *FEs*, the number of times we have invoked the objective function.
This also usually equivalent to the number of candidate solutions that were generated, i.e., the number of times the representation mapping was applied.
This is a machine-independent time measure which cannot be influenced by any outside effects.
Using it also makes sense because in many domains, the objective function with the representation mapping are the most time-consuming elements of the optimization process.
FEs then are somehow equivalent to "algorithm steps," which are the basis for [theoretical runtime analysis](http://en.wikipedia.org/wiki/Analysis_of_algorithms).
Hence, reducing the FEs needed to get a certain solution quality is a primary research concern.

The downside of using FEs is that there is no well-defined relationship with the runtime.
A big problem in scientific work is that different algorithms may require vastly different amounts of runtime for one FE.
The search steps in a local search may have [algorithmic complexity](http://en.wikipedia.org/wiki/Analysis_of_algorithms#Orders_of_growth) of&nbsp;$\bigO{1}$ while those of an ant colony optimization approach may have&nbsp;$\bigO{s^2}$, where&nbsp;$s$ is the number of decision variables.
Assuming that one step of the local search would take as long as one step of the ant colony optimization algorithm would then be grossly unfair.
Also, FEs do not capture any complexity or time spent in book-keeping or mangament not related to the generation of candidate solutions.
Still, they are one of the most important time measures in research.

The problem can be solved by using both time measures when evaluating the algorithm's performance.

### Example: Job Shop Scheduling

In our example domain, the JSSP, we can assume that the human operator will input the instance data&nbsp;$\instance$ into the computer.
Then she may go drink a coffee and expect the results to be ready upon her return.
A termination criterion granting three minutes of runtime seems to be reasonable to me here.

Of course, there may also be other limits, e.g., whether a proposed schedule can be implemented/completed within the working hours of a single day.
We might let the algorithm run longer than three minutes until such a solution was discovered.
For our benchmark instances, however, this is not relevant and we can limit ourselves to the runtime-based termination criterion.
