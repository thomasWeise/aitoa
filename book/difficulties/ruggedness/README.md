## Ruggedness and Weak Causality

All the optimization algorithms we have discussed utilize *memory* in one form or another.
The hill climbers remember the best-so-far point in the search space.
Evolutionary algorithms even remember a set of multiple such points, called the population.
We do this because we expect that the optimization problem exhibits *causality*:
Small changes to a candidate solution will lead to small changes in its utility (see \text.ref{causality} in [@sec:hillClimbing]).
If this is true, than we are more likely to discover a great solution in the neighborhood of a good solution than in the neighborhood of a solution with bad corresponding objective value. 
But what if the causality is *weak*?

### The Problem: Ruggedness

![An illustration of problems exhibiting increasing ruggedness (from left to right).](\relative.path{increasing_ruggedness.svgz}){#fig:increasing_ruggedness}

[@fig:increasing_ruggedness] illustrates different problems with increasing ruggedness of the objective function.
Obviously, unimodal problems, which only have a single optimum, are the easiest to solve.
Multi-modal problems (\text.ref{multimodality}) are harder, but the difficulty steeply increases if the objective function gets rugged, i.e., rises and falls quickly.
Ruggedness has detrimental effects on the performance because it de-values the use of memory in optimization.
Under a highly rugged objective function, there is little relationship between the objective values of a given solution and its neighbors.
Remembering and investigating the neighborhood of the best-so-far solution will then not be more promising than remembering any other solution or, in the worst case, simply conducting random sampling.

Moderately rugged landscapes already pose a problem, too, because they will have many local optima.
Then, techniques like restarting local searches will become less successful, because each restarted search will likely again end up in a local optimum.

### Countermeasures

#### Hybridization with Local Search

![An illustration of how the objective functions from [@fig:increasing_ruggedness] would look like from the perspective of a Memetic Algorithm: The local search traces down into local optima and the MA hence only "sees" the objective values of optima&nbsp;[@WGM1994LETBEAFO].](\relative.path{ruggedness_local_search.svgz}){#fig:ruggedness_local_search}

It has been suggested that combining global and local search can mitigate the effects of ruggedness to some degree&nbsp;[@WGM1994LETBEAFO].
There are two options for this:

Memetic Algorithms or Lamarckian Evolution (see [@sec:memeticAlgorithms]):
Here, the "hosting" global optimization method, say an evolutionary algorithm, samples new points from the search space.
It could create them randomly or obtain them as result of a binary search operator.
These points are then the starting points of local searches.
The result of the local search is then entered into the population.
Since the result of a local search is a local optimum, this means that the EA actually only sees the "bottoms" of valleys of the objective functions and never the "peaks".
From its perspective, the objective function looks more smoothly.

A similar idea is utilizing the Baldwin Effect&nbsp;[@HN1987HLCGE; @WGM1994LETBEAFO; @GW1993ALTTCDONNEATBE].
Here, the global optimization algorithm still works in the search space&nbsp;$\searchSpace$ while the local search (in this context also called "learning") is applied in the solution space&nbsp;$\solutionSpace$.
In other words, the hosting algorithm generates new points&nbsp;$\sespel\in\searchSpace$ in the search space and maps them to points&nbsp;$\solspel=\repMap(\sespel)$ in the solution space&nbsp;$\solutionSpace$ by applying the representation mapping&nbsp;$\repMap$.
These points are then refined directly in the solution space, but the refinements are *not* coded back by some reverse mapping.
Instead, only their objective values are assigned to the original points in the search space.
The algorithm will remember the overall best-ever candidate solution, of course.
In our context, the goal here is again to smoothen out the objective function that is seen by the global search method.
This "smoothing" is illustrated in [@fig:ruggedness_local_search], which is inspired by&nbsp;[@WGM1994LETBEAFO].