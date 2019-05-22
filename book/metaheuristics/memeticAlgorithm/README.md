## Memetic Algorithms: Hybrid of Global and Local Search {#sec:memeticAlgorithms}

We now have seen two types of efficient algorithms for solving optimization problems:

1. local search methods, like the hill climbers, that can refine and improve one solution quickly but may get stuck at local optima, and 
2. global search methods, like evolutionary algorithms, which try to preserve a diverse set of solutions and are less likely to end up in local optima, but pay for it by slower optimization speed.

It is a natural idea to combine both types of algorithms, to obtain a hybrid algorithm which unites the best from both worlds.
Such algorithms are today often called *Memetic Algorithms* (MAs)&nbsp;[@M1989MA; @HSK2005RAIMA; @NCM2012HOMA] (sometimes also Lamarkian Evolution&nbsp;[@WGM1994LETBEAFO]).

### Idea: Combining Local Search and Global Search

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

### Algorithm: EA Hybridized with Neighborhood-Enumerating Hill Climber

The basic $(\mu+\lambda)$&nbsp;Memetic Algorithm is given below and implemented in [@lst:MA].

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.    
4. Repeat until the termination criterion is met:
		b. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
			 i.  Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
       ii Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.       
       iii. **Local Search:** For each point&nbsp;$\sespel'$ in the search space neighboring to $\elementOf{\arrayIndex{P}{i}}{\sespel}$ according to the unary search operator do:
            1. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
            2 Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
            3. If the termination criterion has been met, jump directly to step&nbsp;5.
            4. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}$, $\obspel'$ in&nbsp;$\elementOf{\arrayIndex{P}{i}}{\obspel}$, stop the enumeration, and go back to step&nbsp;*4b.iii*.    
    c. Sort the array&nbsp;$P$ according to the objective values such that the records with better associated objective value&nbsp;$\obspel$ are located at smaller indices. For minimization problems, this means elements with smaller objective values come first.
    d. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    e. Set the first source index&nbsp;$p=-1$.
    f. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        iv. Set the source index&nbsp;$p$ to&nbsp;$p=\modulo{(p+1)}{\mu}$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
        v. Randomly choose another index&nbsp;$p2$ from $0\dots(\mu-1)$ such that&nbsp;$p2\neq p$.
        vi. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_2(\elementOf{\arrayIndex{P}{p}}{\sespel}, \elementOf{\arrayIndex{P}{p2}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the binary search operator to the points stored at index&nbsp;$p$ and&nbsp;$p2$.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.

\repo.listing{lst:MA}{An excerpt of the implementation of the Memetic Algorithm algorithm.}{java}{src/main/java/aitoa/algorithms/MA.java}{}{relevant}



#### Results on the JSSP
