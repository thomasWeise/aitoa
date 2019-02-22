## Common Characteristics {#sec:metaheuristicsCommon}

Before we delve into our first algorithms, let us first take a look on some things that all metaheuristics have in common.

### Anytime Algorithms {#sec:anytimeAlgorithm}

\text.block{definition}{anytimeAlgorithm}{An *anytime algorithm* is an algorithm which can produce an approximate result during almost any time of its execution.}

All metaheuristics &ndash; and many other optimization and machine learning methods &ndash; are [anytime algorithms](http://en.wikipedia.org/wiki/Anytime_algorithm)&nbsp;[@BD1989STDPP2].
The idea behind anytime algorithms is that they start with (potentially bad) guess about what a good solution would be.
During their course, they try to improve their approximation quality, by trying to produce better and better candidate solutions.
At any point in time, we can extract the current best guess about the optimum.
This fits to the optimization situation that we have discussed in [@sec:terminationCriterion]:
We often cannot find out whether the best solution we currently have is the globally optimal solution for the given problem instance or not, so we simply continue trying to improve upon it until a *termination criterion* tells us to quit, e.g., until the time is up.

### Return the Best-So-Far Candidate Solution {#sec:rememberBest}

This one is actually quite simple, yet often ignored and misunderstood by novices to the subject:
Regardless what the optimization algorithm does, it will never *NEVER* forget the best-so-far candidate solution.
Often, this is not explicitly written in the formal definition of the algorithms, but there *always* exists a special variable somewhere storing that solution.
This variable is updated each time a better solution is found.
Its value is returned when the algorithm stops.

### Randomization {#sec:randomizedAlgos}

Often, metaheuristics make randomized choices.
In cases where it is not clear whether doing "A" or doing "B" is better, it makes sense to simply flip a coin and do "A" if it is heads and "B" if it is tails.
That our search operator interfaces in [@lst:INullarySearchOperator;@lst:IUnarySearchOperator;@lst:IBinarySearchOperator] all accept a [pseudorandom number generator](http://en.wikipedia.org/wiki/Pseudorandom_number_generator) as parameter is one manifestation of this issue.
Random number generators are objects which provide functions that can return numbers from certain ranges, say from $[0,1)$ or an integer interval.
Whenever we call such a function, it may return any value from the allowed range, but we do not know which one it will be.
Also, the returned value should be independent from those returned before, i.e., from known the past random numbers, we should *not* be able to guess the next one.
By using such random number generators, we can let an algorithm make random choices, randomly pick elements from a set, or change a variable's value in some unpredictable way.  

### Black Box Optimization {#sec:blackbox}

The concept of general metaheuristics, the idea to attack a very wide class of optimization problems with one basic algorithm design, can only be realized when following a *black-box* approach.
If we want to have one algorithm that can be applied to all the examples given in in the introduction, then this can best be done if we hide all details of the problems under the hood of the structural elements introduced in [@sec:structure].
For a black-box metaheuristic, it does not matter how the objective function&nbsp;$\objf$ works.
The only thing that matters is that gives a rating of a candidate solution&nbsp;$\solspel\in\solutionSpace$ and that smaller ratings are better.
For the metaheuristic, it does not matter what exactly the search operators do or even what data structure is used as search space&nbsp;$\searchSpace$.
It only matters that these operators can be used to get to new points in the search space (which can be mapped to candidate solutions&nbsp;$\solspel$ via a representation mapping&nbsp;$\repMap$ whose nature is also unimportant for the metaheuristic).
Indeed, even the nature of the candidate solutions&nbsp;$\solspel\in\solutionSpace$ and the solution space&nbsp;$\solutionSpace$ play no big role for black-box optimization methods, as they only work on and explore the search space&nbsp;$\searchSpace$.
The solution space is relevant for the human operator using the algorithm only, the search space is what the algorithm works on.
Black-box optimization is the highest level of abstraction on which we can work when trying to solve complex problems.

### Putting it Together

In our following considerations and discussions of algorithms, we will therefore attempt to define an "API" for black-box optimization.
We will fill the abstract interfaces making up the API with simple and clear implementations of algorithms and their adaptation to the JSSP.
We put all the components that a metaheuristic uses as well as representation of a state of an optimization together into one interface.
We call this interface `IBlackBoxProcess` from which an excerpt is given in [@lst:IBlackBoxProcess].

\repo.listing{lst:IBlackBoxProcess}{A generic interface for representing black-box processes to an optimization algorithm.}{java}{src/main/java/aitoa/structure/IBlackBoxProcess.java}{}{relevant}

This interface allows us to

1. provide a random number generator to the algorithm,
2. wrap an objective function&nbsp;$\objf$ together with a representation mapping&nbsp;$\repMap$ to allow us to evaluate a point in the search space&nbsp;$\sespel\in\searchSpace$ in a single step, effectively performing&nbsp;$\objf(\repMap(\sespel))$,
3. keep track of the elapsed runtime and FEs as well as when the last improvement was made by updating said information when necessary during the invocations of the "wrapped" objective,
4. keep track of the best points in the search space and solution space so far as well as their associated objective value in special variables by updating them whenever the "wrapped" objective function discovers an improvement (taking care of the issue from [@sec:rememberBest] automatically),
5. represent a termination criterion based on the above information (e.g., maximum FEs, maximum runtime, reaching a goal objective value), and
7. log the improvements that the algorithm makes to a text file, so that I can use them to make tables and draw diagrams.

Along with the interface class `IBlackBoxProcess`, we also provide a [builder](http://en.wikipedia.org/wiki/Builder_pattern) for instantiation.
The actual implementation behind this interface does not matter here, it is only simple code not contributing to the understand of the algorithms or processes.
Thus, you do not need to bother with it, just the assumption that an object implementing `IBlackBoxProcess` has the abilities listed above shall suffice here.
 
When instantiating this interface by our utility functions, besides the search operators, termination criterion, representation mapping, and objective function, we also need to provide the functionality to instantiate and copy the data structures making up the spaces&nbsp;$\searchSpace$ and $\solutionSpace$.
For this purpose, we add another easy-to-implement and very simple interface, namely `ISpace`, see [@lst:ISpace].

\repo.listing{lst:ISpace}{A excerpt of the generic interface `ISpace` for representing basic functionality of search and solution spaces needed by [@lst:IBlackBoxProcess].}{java}{src/main/java/aitoa/structure/ISpace.java}{}{relevant}

### Example: Job Shop Scheduling

What we need to provide for our JSSP example are implementations of our `ISpace` interface for both the search and the solution space, which are given in [@lst:JSSPSearchSpace] and [@lst:JSSPSolutionSpace], respectively.
These classes implement the methods that an `IBlackBoxProcess` implementation needs under the hood to, e.g., copy and store candidate solutions and points in the search space.

\repo.listing{lst:JSSPSearchSpace}{An excerpt of the implementation of our `ISpace` interface for the search space for the JSSP problem.}{java}{src/main/java/aitoa/examples/jssp/JSSPSearchSpace.java}{}{relevant}

\repo.listing{lst:JSSPSolutionSpace}{An excerpt of the implementation of the `ISpace` interface for the solution space for the JSSP problem.}{java}{src/main/java/aitoa/examples/jssp/JSSPSolutionSpace.java}{}{relevant}

With the exception of the search operators, which we will introduce "when they are needed," we have already discussed how the other components needed to solve a JSSP can be realized in [@sec:jssp:gantt], [@sec:jsspSearchSpace], [@sec:jsspObjectiveFunction], and [@sec:jssp:termination].
 