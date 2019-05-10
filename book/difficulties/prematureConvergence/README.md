## Premature Convergence and Exploration vs. Exploitation

\text.block{definition}{convergence}{An optimization process has converged if it cannot reach new candidate solutions anymore or if it keeps on producing candidate solutions from a small subset of the solution space&nbsp;\solutionSpace.}

One of the problems in global optimization is that it is often not possible to determine whether the best solution currently known is situated on local or a global optimum and thus, if convergence is acceptable.
We often cannot even know if the current best solution is a local optimum or not.
In other words, it is usually not clear whether the optimization process can be stopped, whether it should concentrate on refining the current best solution, or whether it should examine other parts of the search space instead.
This can, of course, only become cumbersome if there are multiple (local) optima, i.e., the problem is *multi-modal*.

\text.block{definition}{multimodality}{An optimization problem is multi-modal if it has more than one local optimum&nbsp;[@R1999ETROLOASPIGS; @HG1995GADATMOTFL; @DJ1975GA; @S1971GOTFFMST].}

The existence of multiple global optima (which, by definition, are also local optima) itself is not problematic and the discovery of only a subset of them can still be considered as successful in many cases.
The occurrence of numerous local optima, however, is more complicated, as the phenomenon of *premature convergence* can occur.

\text.block{definition}{prematureConvergence2}{Convergence to a local optimum is called *premature convergence* (see also \text.ref{prematureConvergence}).}

![An example for how a hill climber from Section&nbsp;[@sec:hillClimbing] could get trapped in a local optimum when minimizing over a one-dimensional, real-valued search space.](\relative.path{premature_convergence.svgz}){#fig:premature_convergence}

Figure&nbsp;[@fig:premature_convergence] illustrates how a simple hill climber as introduced in Section&nbsp;[@sec:hillClimbing] could get trapped in a local optimum.
In the example, we assume that we have a sub-range of the real numbers as one-dimensional search space and try to minimize a multi-model objective function.
There are more than three optima in the figure, but only one of them is the global minimum.
The optimization process, however, discovers the basin of attraction of one of the local optima first.
Once it has traced deep enough into this hole, all the new solutions it can produce are higher on the walls around the local optimum and will thus be rejected (illustrated in gray color).
The algorithm has prematurely converged.
