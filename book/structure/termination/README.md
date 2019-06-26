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
While she does so, can we solve the problem?
Unfortunately, probably not.
As said, for finding the best possible solution, if we are unlucky, we would need in invest a runtime growing exponentially with the problem size, i.e., $\jsspMachines$ and $\jsspJobs$&nbsp;[@LLRKS1993SASAAC; @CPW1998AROMSCAAA].
So can we guarantee to find a solution which is, say, 1% worse, until she finishes her drink? 
Well, it was shown that there is *no* algorithm which can guarantee us to find a solution only 25% worse than the optimum within a runtime polynomial in the problem size&nbsp;[@WHHHLSS1997SSS; @JMSO2005ASFJSSPWCPT] in 1997.
Since 2011, we know that *any* algorithm guaranteeing to provide schedules that are only be a constant factor (be it 25% or 1'000'000) worse than the optimum may need the dreaded exponential runtime&nbsp;[@MS2011HOAFAJSSP].
So whatever algorithm we will develop for the JSSP, defining a some limit solution quality based on the lower bound of the objective value at which we can stop makes little sense. 

Hence, we should rely on the simple practical concern:
The operator drinks a coffee. 
A termination criterion granting three minutes of runtime seems to be reasonable to me here.
We should look for the algorithm implementation that can give us the best solution quality within that time window.

Of course, there may also be other constraints based on the application scenario, e.g., whether a proposed schedule can be implemented/completed within the working hours of a single day.
We might let the algorithm run longer than three minutes until such a solution was discovered.
But, as said before, if a very odd scenario occurs, it might take a long time to discover such a solution, if ever.
The operator may also need to be given the ability to manually stop the process and extract the best-so-far solution if needed.
For our benchmark instances, however, this is not relevant and we can limit ourselves to the runtime-based termination criterion.
