## Common Characteristics {#sec:metaheuristicsCommon}

But before we delve into our first algorithms, let us first take a look on some things that all metaheuristics have in common.

### Anytime Algorithms

\text.block{definition}{anytimeAlgorithm}{An *anytime algorithm* is an algorithm which can produce an approximate result during almost any time of its execution.}

All metaheuristics &ndash; and many other optimization and machine learning methods &ndash; are [anytime algorithms](http://en.wikipedia.org/wiki/Anytime_algorithm)&nbsp;[@BD1989STDPP2].
The idea behind applying anytime algorithms is that they may start with a bad candidate solution and the longer they run, the better their guess about the correct solution becomes.
This fits to the optimization situation that we have discussed in [@sec:terminationCriterion]:
We often cannot find out whether the best solution we currently have is the globally optimal solution for the given problem instance or not, so we simply continue trying to improve upon it until a *termination criterion* tells us to quit.

### Return the Best-So-Far Candidate Solution {#sec:rememberBest}

This one is actually quite simple, yet often ignored and misunderstood by novices to the subject:
Regardless what the optimization algorithm does, it will never *NEVER* forget the best-so-far candidate solution.
Often, this is not explicitly written in the formal definition of the algorithms, but there *always* exists a special variable somewhere storing that solution and being updated when a better one is found.
This value is returned when the algorithm stops.

### Randomization

Often, metaheuristics make randomized choices.
In cases where it is not clear whether doing "A" or doing "B" is better, it makes sense to simply flip a coin and do "A" if it is heads and "B" if it is tails.
That our search operator interfaces in [@lst:INullarySearchOperator;@lst:IUnarySearchOperator;@lst:IBinarySearchOperator] all accept a [pseudorandom number generator](http://en.wikipedia.org/wiki/Pseudorandom_number_generator) as parameter is one manifestation of this issue.

### Black Box Optimization

The concept of metaheuristics, the idea to attack a whole class of optimization problems with one basic algorithm design, can only be realized when following a *black-box* approach.
If we want to have one algorithm that can be applied to all the examples given in [@sec:examplesOfOptimization], then this can best be done if we hide all details of the problems under the hood of the structural elements introduced in [@sec:structure].
The metaheuristic does not care what the objective function&nbsp;$\objf$ does, it just cares that gives a rating of a candidate solution and that smaller ratings are better.
The metaheuristic does not care what the search operators do, it only cares that it can use them to get to new candidate solutions.
Matter of fact, the metaheuristic does not even care about candidate solutions and the solution space&nbsp;$\solutionSpace$ &ndash; it only works on and explores the search space&nbsp;$\searchSpace$.
The solution space is relevant for the human operator using the algorithm, the search space is what the algorithm works on.

### Putting it Together

All the above can be combined to a representation of an optimization process from the metaheuristic.
We define the interface `IBlackBoxProcess` from which an excerpt is given in [@lst:IBlackBoxProcess].

\repo.listing{lst:IBlackBoxProcess}{A generic interface for representing black-box processes to an optimization algorithm.}{java}{src/main/java/aitoa/structure/IBlackBoxProcess.java}{}{relevant}

This interface allows us to

- provide a random number generator to the algorithm,
- wrap an objective function&nbsp;$\objF$ together with a representation mapping&nbsp;$\repMap$ to allow us to evaluate a point in the search space&nbsp;$\sespel\in\searchSpace$ in a single step, effectively performing&nbsp;$\objF(\repMap(\sespel))$,
- keep track of the elapsed runtime and FEs by updating said information when necessary during the invocations of the "wrapped" objective
- keep track of the best points in the search space and solution space so far as well as their associated objective value by updating them whenever the "wrapped" objective function discovers an improvement,
- represent a termination criterion based on the above information (e.g., maximum FEs, maximum runtime, reaching a goal objective value), and
- log the improvements that the algorithm makes to a file.

In other words, when implementing a metaheuristic, we will provide it with an instance of this interface, which will, e.g., solve the issue from [@sec:rememberBest] automatically.

In the interface class `IBlackBoxProcess`, we also provide static methods for instantiation.
The actual implementation then makes use of another simple interface that provides basic functionality of either the search or solution space given in [@lst:ISpace].

\repo.listing{lst:ISpace}{A generic interface for representing basic functionality of search and solution spaces needed by [@lst:IBlackBoxProcess].}{java}{src/main/java/aitoa/structure/ISpace.java}{}{}