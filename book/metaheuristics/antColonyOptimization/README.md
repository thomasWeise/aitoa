## Ant Colony Optimization {#sec:aco}

Ant Colony Optimization (ACO)&nbsp;[@DBS2006ACO; @DMC1996ASOBACOCA; @D1992OLANA; @DS2004ACO] is a family of metaheuristics, which can be considered EDAs with two special characteristics:

1. They are designed for problems whose solutions can be expressed as paths&nbsp;$\sespel$ in graphs&nbsp;$G$.
2. During the model sampling (i.e., the creation of a path&nbsp;$\sespel$), they make use of additional heuristic information obtained from the problem instance.

You can imagine a graph as a mathematical abstraction that can represent a street map, a computer network, a power network, a network of water pipes, and such and such.
More formally, graph&nbsp;$G=(V,E)$ is a structure described by a set&nbsp;$V$ of&nbsp;$v$ vertices, which we will here identify by integers IDs, i.e., $V=0\dots{v-1}\}$.
$E\subseteq V\times V$ is the set of edges connecting the vertices.
A path&nbsp;$\sespel$ through the graph&nbsp;$G$ is a sequence&nbsp;$(\arrayIndex{\sespel}{0},\arrayIndex{\sespel}{1},\dots,\arrayIndex{\sespel}{l})$ such that&nbsp;$\arrayIndex{\sespel}{i}\in V$ for $\forall i\in 0\dots(l-1)$.
The vertexes at index&nbsp;$i$ and&nbsp;$i+1$ in&nbsp;$\sespel$ for&nbsp;$i\in 0\dots{l-2}$ form the edges of the path, i.e., $(\arrayIndex{\sespel}{i},\arrayIndex{\sespel}{i+1})$ are elements of&nbsp;$E$.
The search space&nbsp;$\searchSpace$ of ACO corresponds to the set of all paths&nbsp;$\sespel\in\searchSpace$ admissible by the problem instance.
If we represent a street map as a graph&nbsp;$G$, then a path&nbsp;$\sespel$ through&nbsp;$G$ corresponds to a route on the map from a starting point to an end point.

### The Algorithm

If we recall the structure of EDAs from [@sec:eda:basic_algorithm], then ACO adds

1. a special model structure,
2. a special sampling method, and
3. a special model update method.

We do not require a new overall algorithm structure or new implementation &ndash; [@lst:EDA] will do just fine &ndash; all we need is to understand these new concepts.

#### Model and Model Sampling

The model sampling in ACO works by iteratively building a path through a graph.
In each step, a vertex is added to the path until no nodes can be added anymore and the path&nbsp;$\sespel$ is completed.
The choice which vertex to add is probabilistic.
It depends on two factors: the model&nbsp;$M$ and the heuristic information&nbsp;$H$.

The model&nbsp;$M$ is a two-dimensional table called "pheromone matrix."
Each row&nbsp;$i\in 0\dots(v-1)$ stands for one of the vertices and holds a value&nbsp;$\arrayIndexx{M}{i}{j}$ for each other vertex&nbsp;$j\in 0\dots(v-1)$ with&nbsp;$j\neq i$.
The higher the value&nbsp;$\arrayIndexx{M}{i}{j}$, the more likely should it be that the edge&nbsp;$(i,j)$ is added to the path, i.e., that vertex&nbsp;$j$ follows after vertex&nbsp;$i$.

Besides the model&nbsp;$M$, ACO also uses one heuristic value&nbsp;$\arrayIndexx{H}{i}{j}$ for each such edge.
This value reflects a "gain" that can be obtained by adding the edge.
As in the case of&nbsp;$\arrayIndexx{M}{i}{j}$, larger values of&nbsp;$\arrayIndexx{H}{i}{j}$ make adding the edge&nbsp;$(i,j)$ to the path more likely.

The first vertex at which the path&nbsp;$\sespel$ is started at iteration index&nbsp;$i=0$ is either chosen completely randomly, fixed, or based on some policy.
In each following step&nbsp;$i>0$ of the model sampling, the algorithm first determines the set&nbsp;$N$ of vertices that can be added.
Often, these are all the vertices not yet present in&nbsp;$\sespel$, i.e., $V\setminus \sespel$.
In this case, we can initially set $N=V\setminus \arrayIndex{\sespel}{0}$ and iteratively remove every vertex added to&nbsp;$\sespel$ from&nbsp;$N$.
But there may also be other scenarios, for instance, if we navigate through a graph where not all vertexes are directly connected.  
Either way, once&nbsp;$N$ has been determined, the choice about which edge to add to&nbsp;$\sespel$ in iteration&nbsp;$i>0$ is made probabilistically.
Assume that&nbsp;$N$ contains&nbsp;$v'$ vertices, then the probability&nbsp;$P(\text{add~}\arrayIndex{N}{j})$ to add vertex&nbsp;$\arrayIndex{N}{j}$ to&nbsp;$\sespel$ is:

$$ P(\text{add~}\arrayIndex{N}{j}) = \frac{\left(\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}\right)^{\alpha}*\left(\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}\right)^{\beta}}{\sum_{k=0}^{v'-1} \left(\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{k}}\right)^{\alpha}*\left(\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{k}}\right)^{\beta} } $$ {#eq:aco:vertex:probability}

Here, $\alpha>0$ and $\beta>0$ are two configuration parameters which weight the impact of the model&nbsp;$M$ and the heuristic information&nbsp;$H$, respectively.
The higher the model and heuristic values for the edge from the last-added vertex&nbsp;$\arrayIndex{\sespel}{i}$ to a potential next vertex&nbsp;$\arrayIndex{N}{j}$, the more likely it is selected.
The model sampling then works as follows:

1. The point to sample&nbsp;$\sespel$ will be an array of vertexes which represents the path. It is initially empty.
2. Allocate an array&nbsp;$p$ of real numbers of length&nbsp;$v-1$. 
3. Set an index variable&nbsp;$i=0$.
4. Choose a first vertex and store it in&nbsp;$\arrayIndex{\sespel}{i}$.
5. Repeat:
    a. Set&nbsp;$i=i+1$.
    b. Obtain $N\subset V$&nbsp;as the set of vertices that can potentially be added to&nbsp;$\sespel$ in this round. ($N$&nbsp;is usually equivalent to&nbsp;$V$ minus all vertices already added.)
    c. The number of vertices in&nbsp;$N$ be&nbsp;$v'$.
    d. If&nbsp;$v'=0$, exit the loop, because the path construction is complete.
    e. If&nbsp;$v'=1$, set $k=0$, because there is only one vertex to choose from.
    f. else, i.e., if $v'>1$, do:
       i. Set a real variable&nbsp;$ps$ to&nbsp;$0$.
       ii. For $j$ from $0$ to $v'-1$ do:
          A. Set $ps=ps+\left(\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}\right)^{\alpha}*\left(\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}\right)^{\beta}$.
          B. Set $\arrayIndex{p}{j}=ps$.
       iii. Draw a random number&nbsp;$r$ uniformly distributed in $[0,ps)$.
       iv. Determine $k$&nbsp;to be the index of the smallest value in&nbsp;$p$ which is greater than&nbsp;$r$. It can be found via binary search (we may need to check for smaller values left-wards if model or heuristic values can be&nbsp;0).
    g. Set&nbsp;$\arrayIndex{\sespel}{i}=\arrayIndex{N}{k}$, i.e., append the vertex to&nbsp;$\sespel$.
6. Return the completed path&nbsp;$\sespel$.

We implement [@eq:aco:vertex:probability] in *lines&nbsp;5e* and&nbsp;*5f*.
Obviously, if there is only $v'=1$ node that could be added, then it will have probability&nbsp;1 and we do not need to actually compute the equation.
If $v'>1$, then we need to compute the product&nbsp;$\arrayIndex{P}{j}$ of the model value&nbsp;$\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}^{\alpha}$ and heuristic value&nbsp;$\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}^{\beta}$ for each vertex.
The probability for each vertex to be chosen would then be their corresponding result divided by the overall sum of all of these values.
*Lines&nbsp;5fi$ to&nbsp;*5fiv* show how this can be done efficiently:
Instead of assigning the results directly to the vertices, we use a running sum&nbsp;$ps$ instead.
Thus, the value&nbsp;$\arrayIndex{p}{0}$ is&nbsp;$\arrayIndex{P}{0}$, $\arrayIndex{p}{1}=\arrayIndex{P}{0}+\arrayIndex{P}{1}$, $\arrayIndex{p}{2}=\arrayIndex{P}{0}+\arrayIndex{P}{1}+\arrayIndex{P}{2}$, and so on.
Finally, we just need to draw a random number&nbsp;$r$ from&nbsp;$[0,ps)$.
If it is less than&nbsp;$\arrayIndex{p}{0}=\arrayIndex{P}{0}$, then we choose vertex&nbsp;$\arrayIndex{N}{0}$.
Otherwise, if it is less than&nbsp;$\arrayIndex{p}{1}=\arrayIndex{P}{0}+\arrayIndex{P}{1}$, we pick&nbsp;$\arrayIndex{N}{1}$.
Otherwise, if it is less than&nbsp;$\arrayIndex{p}{2}=\arrayIndex{P}{0}+\arrayIndex{P}{1}+\arrayIndex{P}{2}$, we pick&nbsp;$\arrayIndex{N}{2}$, and so on.
We can speed up finding the right node by doing a binary search.
(In the case that model or heuristic values can be zero, we need to be careful because we then could have some&nbsp;$\arrayIndex{p}{\kappa}=\arrayIndex{p}{\kappa+1}$ and thus would need to check that we really have the lowest index&nbsp;k$ for which&nbsp;$\arrayIndex{p}{k}>r$.)

If we need to add all vertexes in&nbsp;$V$, then it is relatively easy to see that this model sampling routine has quadratic complexity:
For each current vertex we need to look at all other (not-yet-chosen) vertices due to *line&nbsp;5fii*.

#### Model Update

In the traditional ACO approach, the model will be sampled&nbsp;$\lambda>0$ times in each iteration and&nbsp;$0<\mu\leq \lambda$ of the solutions are used in the model update step.
Here, we discuss the model update procedure for the first ACO algorithm, the *Ant System* (AS)&nbsp;[@DMC1996ASOBACOCA; @D1992OLANA] and its improved version, the *Max-Min Ant System* (MMAS)&nbsp;[@SH2000MMAS].

Let $\searchSpaceSubset$&nbsp;be the list of the&nbsp;$\mu$ selected paths.
Then, the model values (called "pheromones") in the matrix&nbsp;$M$ are updated as follows:

$$ \arrayIndexx{M}{i}{j} = \min\{U, \max\{L, (1-\rho)\arrayIndexx{M}{i}{j} + \sum_{\forall \sespel\in \searchSpaceSubset} \arrayIndexx{\tau^{\sespel}}{i}{j} \}\} $$ {#eq:aco:update}

All model values are limited to the real interval&nbsp;$[L,U]$ and&nbsp;$L$ and&nbsp;$U$ are its upper and lower bound, respectively.
If the pheromone&nbsp;$\arrayIndexx{M}{i}{j}$  on an edge&nbsp;$(i,j)$ would become&nbsp;0, then its probability to be added will also be zero and&nbsp;$j$ will never be added again to any&nbsp;$\sespel$ directly after&nbsp;$i$.
Since we want to preserve a certain minimum probability, setting a lower limit&nbsp;$L>0$ makes sense.
If&nbsp;$\arrayIndexx{M}{i}{j}$ gets too large, this can have the opposite effect and then&nbsp;$j$ will always be chosen directly after&nbsp;$i$.
Thus, the upper limit&nbsp;$U>L$ is introduced.
 
The current model value is reduced by multiplying it with $(1-\rho)$, where $\rho\in[0,1]$&nbsp;is called the "evaporation rate."
This concept has already been mentioned in our summary on EDAs ([@sec:eda:summary]) and is used in the PBIL&nbsp;[@B1994PBILAMFIGSBFOACL; @BC1995RTGFTSGA] algorithm.

The amount&nbsp;$\arrayIndexx{\tau^{\sespel}}{i}{j}$ added to the model values for each&nbsp;$\sespel\in \searchSpaceSubset$ is:

$$ \arrayIndexx{\tau^{\sespel}}{i}{j} = \left\{\begin{array}{ll}
Q / \objf(\repMap(\sespel))&\text{if~edge~}(i,j)\text{~appears~in~}\sespel\\
0&\text{otherwise}
\end{array}\right. $$

where $Q$&nbsp;is a constant.
In other words, the pheromone&nbsp;$\arrayIndexx{M}{i}{j}$ of an edge&nbsp;$(i,j)$ increases more if it appears in selected solutions with small objective values.

In the AS, $\mu=\lambda$ and now bounds for the pheromones are given, i.e., $L=0$ and $U=+\infty$.
In the MMAS in&nbsp;[@SH2000MMAS], the matrix&nbsp;$M$ is initialized with the value&nbsp;$U$, $\alpha=1$, $\beta=2$, $\lambda=v$ (i.e., the number of vertices), $\mu=1$, $Q=1$.
There, values of&nbsp;$\rho\in[0.7,0.99]$ are investigated and the smaller values lead to slower convergence and more exploration whereas the high $\rho$&nbsp;values increase the search speed but also the chance of premature convergence.

Either way, from [@eq:aco:update], we know that the model update will need at least a quadratic number of algorithm steps and the model itself is also requires quadratic amount of memory.
Both of these can be problematic for large numbers&nbsp;$v$ of vertices or short time budgets (and the latter is the case in our JSSP scenario).
