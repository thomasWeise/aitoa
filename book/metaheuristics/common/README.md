## Common Characteristics {#sec:metaheuristicsCommon}

Before we delve into our first algorithms, let us first take a look on some things that all metaheuristics have in common.

### Anytime Algorithms {#sec:anytimeAlgorithm}

\text.block{definition}{anytimeAlgorithm}{An *anytime algorithm* is an algorithm which can provide an approximate result during almost any time of its execution.}

All metaheuristics &ndash; and many other optimization and machine learning methods &ndash; are anytime algorithms&nbsp;[@BD1989STDPP2].
The idea behind anytime algorithms is that they start with (potentially bad) guess about what a good solution would be.
During their course, they try to improve their approximation quality, by trying to produce better and better candidate solutions.
At any point in time, we can extract the current best guess about the optimum (and stop the optimization process if we want to).
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
That our search operator interfaces in [@lst:INullarySearchOperator;@lst:IUnarySearchOperator;@lst:IBinarySearchOperator] all accept a pseudorandom number generator as parameter is one manifestation of this issue.
Random number generators are objects which provide functions that can return numbers from certain ranges, say from $[0,1)$ or an integer interval.
Whenever we call such a function, it may return any value from the allowed range, but we do not know which one it will be.
Also, the returned value should be independent from those returned before, i.e., from known the past random numbers, we should *not* be able to guess the next one.
By using such random number generators, we can let an algorithm make random choices, randomly pick elements from a set, or change a variable's value in some unpredictable way.  

### Black-Box Optimization {#sec:blackbox}

![The black-box character of many metaheuristics, which can often accept arbitrary search operators, representations, and objective functions.](\relative.path{black_box_metaheuristic.svgz}){#fig:black_box_metaheuristic}

The concept of general metaheuristics, the idea to attack a very wide class of optimization problems with one basic algorithm design, can be realized when following a *black-box* approach.
If we want to have one algorithm that can be applied to all the examples given in in the introduction, then this can best be done if we hide all details of the problems under the hood of the structural elements introduced in [@sec:structure].
For a black-box metaheuristic, it does not matter how the objective function&nbsp;$\objf$ works.
The only thing that matters is that gives a rating of a candidate solution&nbsp;$\solspel\in\solutionSpace$ and that smaller ratings are better.

There are different degrees of how general black-box metaheuristics can be.
For the most general algorithms, it does not matter what exactly the search operators do or even what data structure is used as search space&nbsp;$\searchSpace$.
For them, it only matters that these operators can be used to get to new points in the search space (which can be mapped to candidate solutions&nbsp;$\solspel$ via a representation mapping&nbsp;$\repMap$ whose nature is also unimportant for the metaheuristic).
Then, even the nature of the candidate solutions&nbsp;$\solspel\in\solutionSpace$ and the solution space&nbsp;$\solutionSpace$ play no big role for black-box optimization methods, as they only work on and explore the search space&nbsp;$\searchSpace$.

Then there are also black-box metaheuristics that demand a special type of search space, e.g., a specific subset of the $n$-dimensional real numbers ($\searchSpace\subset\realNumbers^n$), bit strings of a given length, or permutations of the first $n$&nbsp;natural numbers.
These algorithms can still be general, as they may make very few assumptions about the nature of the objective function&nbsp;$\objf$ defined over the solution space&nbsp;$\problemSpace$.

The solution space is relevant for the human operator using the algorithm only, the search space is what the algorithm works on.
Of course, in many cases, $\searchSpace=\solutionSpace$.

Thus, a black-box metaheuristic is a general algorithm into which we can plug representations, objective functions, and often also search operations as needed by a specific application.
This is illustrated in [@fig:black_box_metaheuristic].
Black-box optimization is the highest level of abstraction on which we can work when trying to solve complex problems.

### Putting it Together: A simple API

Before, I promised that we will implement all the algorithms discussed in this book.

If we would be dealing with "classical" algorithms, things would be somewhat easier:
A classical algorithm has clearly defined input and output data structures.
Dijkstra's shortest path algorithm&nbsp;[@D1959ANOTPICWG], for instance, gets fed with a graph of weighted edges and a start node and will return the paths of minimum weight to all other nodes (or a specified target node).
In Machine Learning, the situation is quite similar:
We would have a lot of specialized algorithms for clearly defined situations.
The input and output data would usually adhere to some basic, fixed structures.
If you implement $k$&#8209;means clustering&nbsp;[@F1965CAOMDEVIOC; @HW1979AA1AKMCA], for instance, you have real vectors coming in and $k$~real vectors going out of your algorithm and that's that.
Deep Learning&nbsp;[@GBC2016DL] basically takes, as input, a set of labeled real vectors (plus a network structure) and, as output, produces the vector of weights for the network.
However, we have to deal with the black-box concept, meaning that our algorithms will be very variable in terms of the data structures we can feed to them.
Matter in fact:
*Any* of the three scenarios above can be modeled as optimization problem.
*Any* of them can be tackled with (most of) the metaheuristics in this book as well!

This is challenging from a programming perspective, especially when we try to tackle this in an educational setting, where stuff should not be overly complicated.
What we want is to not just implement general algorithms, but also be able to execute them and obtain their results in a convenient fashion.
Ideally, we do not want to be bothered with too much book keeping or the creation of log files and such and such.
It should be possible to implement the most general type of black-box methods as well as problem-specific optimization methods and to run them in a uniform environment. 

I therefore try to define a simple API for black-box optimization that combines all of our considerations far.
The goal is to make the implementation of metaheuristics as simple as possible.
We do this by clearly dividing between the optimization algorithms for solving a problem on one side and the structural components of the problem on the other side.
The algorithms that we will implement will be general black-box methods.
At the same time, we will develop the components that we need to plug into them to solve JSSPs as educational example.

We therefore first need to consider what an optimization process needs as input.
Obviously, in the most common case, these are all the items we have discussed in the previous section, ranging from the termination criterion over the search operators (which we will discuss later) and the representation mapping to the objective function.
Let us therefore define an interface that can provide all these components with corresponding "getter methods."
We call this interface `IBlackBoxProcess<X,Y>` from which an excerpt is given in [@lst:IBlackBoxProcess].
The interface is *generic*, meaning it allows us to provide a search space&nbsp;$\searchSpace$ as type parameter&nbsp;`X` and a solution space&nbsp;$\solutionSpace$ via the type parameter&nbsp;`Y`.

\repo.listing{lst:IBlackBoxProcess}{A generic interface for representing black-box processes to an optimization algorithm.}{java}{src/main/java/aitoa/structure/IBlackBoxProcess.java}{}{relevant}

Actually, such an interface does not need to expose the representation mapping&nbsp;$\repMap$ and objective function&nbsp;$\objf$ as separate components to an optimization algorithm.
It is sufficient if the interface directly implements an `evaluate` that takes, as input, an element $\sespel\in\searchSpace$, internally performs the representation mapping&nbsp;$\solspel=\repMap(\sespel)$, then invokes the objective function&nbsp;$\objf(\solspel)$, and returns its result.
This `evaluate` method could then even be implemented such that it remembers the best-so-far-solution.
We then no longer need to keep track of it in the optimization itself.

Of course, we can also implement logging of the search progress inside of `evaluate`, which would make this functionality available to all of our experiments in a transparent fashion.
Furthermore, we could also keep track of the total number of calls to the objective function as well as of the consumed runtime.
This, in turn, can be used to implement the termination criterion.

All in all, this interface allows us to create transparent implementations that

1. provide a random number generator to the algorithm,
2. wrap an objective function&nbsp;$\objf$ together with a representation mapping&nbsp;$\repMap$ to allow us to evaluate a point in the search space&nbsp;$\sespel\in\searchSpace$ in a single step, effectively performing&nbsp;$\objf(\repMap(\sespel))$,
3. keep track of the elapsed runtime and FEs as well as when the last improvement was made by updating said information when necessary during the invocations of the "wrapped" objective function,
4. keep track of the best points in the search space and solution space so far as well as their associated objective value in special variables by updating them whenever the "wrapped" objective function discovers an improvement (taking care of the issue from [@sec:rememberBest] automatically),
5. represent a termination criterion based on the above information (e.g., maximum FEs, maximum runtime, reaching a goal objective value), and
6. log the improvements that the algorithm makes to a text file, so that we can use them to make tables and draw diagrams.

Along with the interface class `IBlackBoxProcess`, we also provide a builder for instantiating it.
The actual implementation behind this interface does not matter here.
It is clear what it does, and the actual code is simple and not contributing to the understand of the algorithms or processes.
Thus, you do not need to bother with it, just the assumption that an object implementing `IBlackBoxProcess` has the abilities listed above shall suffice here.
 
When instantiating this interface via the builder, we can provide the termination criterion, representation mapping, and objective function.
Additionally, we also need to provide the functionality to instantiate and copy the data structures making up the spaces&nbsp;$\searchSpace$ and $\solutionSpace$.
On one hand, these are needed for the internal book-keeping so that `evaluate` can internally make a copy of the best-so-far elements in&nbsp;$\searchSpace$ and $\solutionSpace$).
On the other hand, the black-box optimization algorithms that we will implement also must be able to make such copies.
Since we do not make any assumption about the Java `class`es corresponding to the spaces&nbsp;$\searchSpace$ and&nbsp;$\solutionSpace$, we add another easy-to-implement and very simple interface, namely `ISpace`, see [@lst:ISpace].
It can be implemented for each problem type and then provides the required functionality.

\repo.listing{lst:ISpace}{A excerpt of the generic interface `ISpace` for representing basic functionality of search and solution spaces needed by [@lst:IBlackBoxProcess].}{java}{src/main/java/aitoa/structure/ISpace.java}{}{relevant}

Equipped with this, defining an interface for black-box metaheuristics becomes easy:
The optimization algorithms themselves then are implementations of the generic interface `IMetaheuristic<X,Y>` given in [@lst:IMetaheuristic].
As you can see, this interface only really needs a single method, `solve`.
This method will use the functionality provided by the `IBlackBoxProcess` handed to it as parameter `process`.
The implemented algorithm can generate new points in the search space&nbsp;`X` and send them to the `evaluate` method of `process`.
This is the core behavior of every basic metaheuristic and in the rest of this chapter, we will learn how different algorithms realize it.

\repo.listing{lst:IMetaheuristic}{A generic interface of a metaheuristic optimization algorithm.}{java}{src/main/java/aitoa/structure/IMetaheuristic.java}{}{relevant}

Notice that the interface `IMetaheuristic` is, again, generic, allowing us to specify a search space&nbsp;$\searchSpace$ as type parameter&nbsp;`X` and a solution space&nbsp;$\solutionSpace$ via the type parameter&nbsp;`Y`.
Whether an implementation of this interface is generic too or whether it ties down `X` or `Y` to concrete types will then depend on the algorithms we try to realize.
The most general black-box metaheuristics may be able to deal with any search- and solution space, as long they are provided with the right operators.
Still, we could also implement an algorithm specified to numerical problems where&nbsp;$\searchSpace\subset\realNumbers^n$, by tying down `X` to `double[]` in the algorithm class specification.

### Example: Job Shop Scheduling

What we need to provide for our JSSP example are implementations of our `ISpace` interface for both the search and the solution space, which are given in [@lst:JSSPSearchSpace] and [@lst:JSSPSolutionSpace], respectively.
These classes implement the methods that an `IBlackBoxProcess` implementation needs under the hood to, e.g., copy and store candidate solutions and points in the search space.

\repo.listing{lst:JSSPSearchSpace}{An excerpt of the implementation of our `ISpace` interface for the search space for the JSSP problem.}{java}{src/main/java/aitoa/examples/jssp/JSSPSearchSpace.java}{}{relevant}

\repo.listing{lst:JSSPSolutionSpace}{An excerpt of the implementation of the `ISpace` interface for the solution space for the JSSP problem.}{java}{src/main/java/aitoa/examples/jssp/JSSPSolutionSpace.java}{}{relevant}

With the exception of the search operators, which we will introduce "when they are needed," we have already discussed how the other components needed to solve a JSSP can be realized in [@sec:jssp:gantt], [@sec:jsspSearchSpace], [@sec:jsspObjectiveFunction], and [@sec:jssp:termination].
