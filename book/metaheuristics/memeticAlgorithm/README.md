## Memetic Algorithms: Hybrid of Global and Local Search {#sec:memeticAlgorithms}

We now have seen two types of efficient algorithms for solving optimization problems:

1. local search methods, like the hill climbers, that can refine and improve one solution quickly but may get stuck at local optima, and 
2. global search methods, like evolutionary algorithms, which try to preserve a diverse set of solutions and are less likely to end up in local optima, but pay for it by slower optimization speed.

It is a natural idea to combine both types of algorithms, to obtain a hybrid algorithm which unites the best from both worlds.
Such algorithms are today often called *Memetic Algorithms* (MAs)&nbsp;[@M1989MA; @HSK2005RAIMA; @NCM2012HOMA].

The idea is as follows:
In an Evolutionary Algorithm, the population guards against premature convergence to a local optimum.
In each generation of the EA, new points in the search space are derived from the ones that have been selected in the previous step.
This means that, from the perspective of a single point in the population, each generation of the EA is similar to one iteration of a hill climber.
However, there are $\mu$~points in the population, not just one.
As a result, the progress made towards a good solution is much slower compared to the hill climber.

Another issue is that we introduced a binary search operator which combines traits from two points in the population to form a new, hopefully better solution.
The idea is that the points that have survived selection should be good, hence they should include good components, and we hope to combine these.
However, during the early stages of the search, the population contains first random and then slightly refined points (see above).
For quite some time, these will not yet be good and thus neither contain good components.

Both of these issues can be mitigated by one simple idea:
Let each new point, before it enters the population, become the starting point of a local search that runs until it converges and then enter the result of this local search into the population instead.
This is already the concept of a Memetic Algorithm.

As a result, the first generation of the MA performs exactly the same as a Hill Climber with restarts [@sec:hc2WithRestarts].
The inputs of the binary search operator will then not just be selected points, they will be local optima (with respect to the neighborhood spanned by the unary operator). 
Actually, we can omit the unary operator in the MA as it is already used in the local search and always apply the binary operator to generate new points.
In the following generations, the local search will then refine the combinations of local optima.
