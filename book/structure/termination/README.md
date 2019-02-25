## The Termination Criterion and the Problem of Measuring Time {#sec:terminationCriterion}

We have seen that the search space for even small instances of the JSSP can already be quite large.
We simply cannot enumerate all of them, as it would take too long.
This raises the question: "If we cannot look at all possible solutions, how can we find the global optimum?"
We may also ask: "If we cannot look at all possible solutions, how can we know whether a given candidate solution is the global optimum or not?"
In many optimization scenarios, we can use theoretical bounds to solve that issue, but a priori, these questions are valid and their answer is simply: *No*.
*No*, without any further theoretical investigation of the optimization problem, we don't know if the best solution we know so far is the global optimum or not.
This leads us to another problem:
If we do not know whether we found the best-possible solution or not, how do we know if we can stop the optimization process or should continue trying to solve the problem?
There are two basic answers:
Either when the time is up or when we found a reasonably-good solution.

### Definitions

\text.block{definition}{terminationCriterion}{The *termination criterion* is a function of the state of the optimization process which becomes `true` if the optimization process should stop (and then remains `true`) and remains `false` as long as it can continue.}

\repo.listing{lst:ITerminationCriterion}{A general interface for termination criteria.}{java}{src/main/java/aitoa/structure/ITerminationCriterion.java}{}{}

With a termination criterion defined as implementation of the interface given in [@lst:ITerminationCriterion], we can embed any combination of time or solution quality limits.
We could, for instance, define a goal objective value&nbsp;$g$ good enough so that we can stop the optimization procedure as soon as a candidate solution&nbsp;$\solspel\in\solutionSpace$ has been discovered with $\objf(\solspel)\leq g$, i.e., which is at least as good as the goal.
Alternatively &ndash; or in addition &ndash; we may define a maximum amount of time the user is willing to wait for an answer, i.e., a computational budget after which we simply need to stop.
Discussions of both approaches from the perspective of measuring algorithm performance are given in [@sec:basicPerformanceIndicators; @sec:measuringTime].

### Example: Job Shop Scheduling {#sec:jssp:termination}

In our example domain, the JSSP, we can assume that the human operator will input the instance data&nbsp;$\instance$ into the computer.
Then she may go drink a coffee and expect the results to be ready upon her return.
A termination criterion granting three minutes of runtime seems to be reasonable to me here.

Of course, there may also be other limits, e.g., whether a proposed schedule can be implemented/completed within the working hours of a single day.
We might let the algorithm run longer than three minutes until such a solution was discovered.
For our benchmark instances, however, this is not relevant and we can limit ourselves to the runtime-based termination criterion.
