## Ant Colony Optimization {#sec:aco}

Ant Colony Optimization (ACO)&nbsp;[@DBS2006ACO; @DMC1996ASOBACOCA; @D1992OLANA; @DS2004ACO] is a family of metaheuristics, which can be considered special forms of EDAs with two special characteristics:

1. They are designed for problems whose solutions can be expressed as paths&nbsp;$\sespel$ in graphs&nbsp;$G$.
2. During the model sampling (i.e., the creation of a path&nbsp;$\sespel$), they make use of additional heuristic information obtained from the problem instance.

You can imagine a graph as a mathematical abstraction that can represent a street map, a computer network, a power network, or network of water pipes, and such and such.
More formally, graph&nbsp;$G=(V,E)$ is a structure described by a set of&nbsp;$\nu$ vertices&nbsp;$V=\{v_1,v_2,\dots,v_{\nu}\}$ and a set of edges&nbsp;$E\subseteq V\times V$ connecting the vertices.
A path&nbsp;$\sespel$ through the graph&nbsp;$G$ is a sequence&nbsp;$(\arrayIndex{\sespel}{0},\arrayIndex{\sespel}{1},\dots,\arrayIndex{\sespel}{l})$ such that&nbsp;$\arrayIndex{\sespel}{i}\in V\forall i\in 0\dots(l-1)$ and the end vertex of edge&nbsp;$\arrayIndex{\sespel}{i}$ is the start vertex of edge&nbsp;$\arrayIndex{\sespel}{i+1}$ for&nbsp;$i\in 0\dots{l-2}$, i.e., all such $(\arrayIndex{\sespel}{i},\arrayIndex{\sespel}{i+1})$ are edges and elements of&nbsp;$E$.
The search space&nbsp;$\searchSpace$ of ACO corresponds to the set of all paths&nbsp;$\sespel\in\searchSpace$ admissible by the problem instance.
If we represent a street map as a graph&nbsp;$G$, then a path&nbsp;$\sespel$ through&nbsp;$G$ correspond to a route on the map from a starting point to an end point.

### The Algorithm

Let us first discuss the basic concept of ACO.
If we recall the structure of EDAs from [@sec:eda:basic_algorithm], then ACO can be considered as

1. a special model structure and sampling method, and
3. a special model update method.

We do not require a new overall algorithm structure or new implementation &ndash; [@lst:EDA] will do just fine &ndash; all we need is to understand these new concepts.

#### Model Sampling

The model sampling in ACO works by step-by-step building a path through a graph.
In each step, a node is added to the path until no nodes can be added anymore.
The choice which node is added is probabilistic.
It depends on two factors: the model&nbsp;$M$ and the heuristic information&nbsp;$H$.

The model&nbsp;$M$ is a two-dimensional table called "pheromone matrix".
Each row&nbsp;$i\in 0\dots(\nu-1)$ stands for one of the vertices and holds a value&nbsp;$\arrayIndexx{M}{i}{j}$ for each other vertex&nbsp;$j\in 0\dots(\nu-1)$ with&nbsp;$j\neq i$.
The higher the value&nbsp;$\arrayIndexx{M}{i}{j}$, the more likely should it be that the edge&nbsp;$(i,j)$ is added to the candidate solution, i.e., the path being constructed during model sampling.

Besides the model&nbsp;$M$, ACO also uses one heuristic value&nbsp;$\arrayIndexx{H}{i}{j}$ for each edge.
This value reflects something like a "gain" that can be obtained by adding the edge.
Like in the case of&nbsp;$\arrayIndexx{M}{i}{j}$, larger values of&nbsp;$\arrayIndexx{H}{i}{j}$ make adding the edge&nbsp;$(i,j)$ to the path more likely.

The first vertex at which the path&nbsp;$\sespel$ is started at iteration index&nbsp;$i=0$ is either chosen completely randomly, fixed, or based on some policy.
In each following step&nbsp;$i>0$ of the model sampling, the algorithm first determines the set&nbsp;$N$ of vertices that can be added.
Normally, these are all the vertices not yet present in&nbsp;$\sespel$, i.e., $V\setminus \sespel$.
In this case, we can initially set $N=V\setminus \arrayIndex{\sespel}{0}$ and remove every vertex added to&nbsp;$\sespel$ from&nbsp;$N$.
But there may also be other scenarios, for instance, if we navigate through a graph where some vertexes are not directly connected.  
Either way, once&nbsp;$N$ has been determined, the choice about which edge to add to&nbsp;$\sespel$ in iteration&nbsp;$i>0$ is made probabilistically.
Assume that&nbsp;$N$ contains&nbsp;$\nu'$ vertices, then the probability&nbsp;$P(\text{add~}\arrayIndex{N}{j})$ to add vertex&nbsp;$\arrayIndex{N}{j}$ to&nbsp;$\sespel$ is:

$$ P(\text{add~}\arrayIndex{N}{j}) = \frac{{\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}}^{\alpha}*{\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}}^{\beta}}{\sum_{k=0}^{\nu'-1} {\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{k}}}^{\alpha}*{\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{k}}}^{\beta} } $$ {#eq:aco:vertex:probability}

Here, $\alpha>0$ and $\beta>0$ are two configuration parameters which weight the impact of the model&nbsp;$M$ and the heuristic information&nbsp;$H$, respectively.
The higher the model and heuristic values for the edge from the last-added vertex&nbsp;$\arrayIndex{\sespel}{i}$ to a potential next vertex&nbsp;$\arrayIndex{N}{j}$, the more likely it is selected.
The model sampling then works as follows:

1. The point to sample&nbsp;$\sespel$ will be an array of vertexes which represents the path. It is initially empty.
2. Allocate an array&nbsp;$p$ of real numbers of length&nbsp;$\nu-1$. 
3. Set an index variable&nbsp;$i=0$.
4. Choose a first vertex and store it in&nbsp;$\arrayIndex{\sespel}{i}$.
5. Repeat:
    a. Set&nbsp;$i=i+1$.
    b. Obtain $N\subset V$&nbsp;as the set of vertices that can potentially be added to&nbsp;$\sespel$ in this round. ($N$&nbsp;is usually equivalent to&nbsp;$V$ minus all vertices already added.)
    c. The number of vertices in&nbsp;$N$ be&nbsp;$\nu'$.
    d. If&nbsp;$\nu'=0$, exit the loop, because the path construction is complete.
    e. If&nbsp;$\nu'=1$, set $k=0$, because there is only one vertex to choose from.
    f. else
       i. Set a real variable&nbsp;$ps$ to&nbsp;$0$.
       ii. For $j$ from $0$ to $\nu'-1$ do:
           A. Set $ps=ps+{\arrayIndexx{M}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}}^{\alpha}*{\arrayIndexx{H}{\arrayIndex{\sespel}{i-1}}{\arrayIndex{N}{j}}}^{\beta}$.
           B. Set $\arrayIndex{p}{j}=ps$.
       iii. Draw a random number&nbsp;$r$ uniformly distributed in $[0,ps)$.
       iv. Determine $k$&nbsp;to be the index of the smallest value in&nbsp;$p$ which is greater than&nbsp;$r$. It can be found via binary search (we may need to check for smaller values left-wards if pheromones and heuristic values can be&nbsp;0).
    g. Set&nbsp;$\arrayIndex{\sespel}{i}=\arrayIndex{N}{k}$, i.e., append the node to&nbsp;$\sespel$.

