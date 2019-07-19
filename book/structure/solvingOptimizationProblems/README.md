## Solving Optimization Problems

Thank you for sticking with me during this long and a bit dry introduction chapter.
Why did we go through all of this long discussion?
We did not even solve the JSSP yet&hellip;

Well, in the following you will see that we now are actually only a few steps away from getting good solutions for the JSSP.
Or any optimization problem.
Because we now have actually exercise a the basic process that we need to go through whenever we want to solve a new optimization task.

1. The first thing to do is to understand the scenario information, i.e., the input data&nbsp;$\instance$ that our program will receive.
2. The second step is to understand what our users will consider as a solution &ndash; a Gantt chart, for instance.
   Then we need to define a data structure&nbsp;$\solutionSpace$ which can hold all the information of such a candidate solution.
3. Once we have the data structure&nbsp;$\solutionSpace$ representing a complete candidate solution, we need to know when a solution is good.
   We will define the objective function&nbsp;$\objf$, which returns one number (say the makespan) for a given candidate solution.
4. If we want to apply any of the optimization algorithms introduced in the following chapters, then we also to know when to stop.
   As already discussed, we usually cannot solve instances of a new problem to optimality within feasible time and often don't know whether the current-best solution is optimal or not.
   Hence, a termination criterion usually arises from practical constraints, such as the acceptable runtime.

All the above points need to be tackled in close collaboration with the user.
The user may be the person who will eventually, well, use the software we build or at least a domain expert.
The following steps then are our own responsibility:

5. In the future, we will need to generate many candidate solutions quickly, and these better be feasible.
   Can this be done easily using the data structure&nbsp;$\solutionSpace$?
   If yes, then we are good.
   If not, then we should think about whether we can define an alternative search space&nbsp;$\searchSpace$, a simpler data structure.
   Creating and modifying instances of such a simple data structure&nbsp;$\searchSpace$ is much easier than&nbsp;$\solutionSpace$.
   Of course, defining such a data structure&nbsp;$\searchSpace$ makes only sense if we can also define a mapping&nbsp;$\repMap$ from&nbsp;$\searchSpace$ to&nbsp;$\solutionSpace$.
6. We select optimization algorithms and plug in the representation and objective function.
   We may need to implement some other algorithmic modules, such as search operations.
   In the following chapters, we discuss a variety of methods for this.
7. We test, benchmark, and compare several algorithms to pick those with the best and most reliable performance (see [@sec:comparingOptimizationAlgorithms]).
