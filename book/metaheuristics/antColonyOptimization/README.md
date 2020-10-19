## Ant Colony Optimization {#sec:aco}

A graph&nbsp;$G=(V,E)$ is a structure described by a set of vertices&nbsp;$V=\{v_1,v_2,\dots,v_k\}$ and a set of edges&nbsp;$E\subseteq V\times V$ connecting the vertices.
A path&nbsp;$\pi$ through the graph&nbsp;$G$ is a sequence&nbsp;$(\pi_1,\pi_2,\dots,\pi_p)$ such that&nbsp;$p_i\in E\forall i\in 1\dots p$ and the end vertex of edge&nbsp;$p_i$ is the start vertex of edge&nbsp;$\pi_{i+1}$ for&nbsp;$i\in 1\dots{p-1}$. 

Ant Colony Optimization (ACO)&nbsp;[@DBS2006ACO; @DMC1996ASOBACOCA; @D1992OLANA; @DS2004ACO] is a family of metaheuristics, which can be considered special forms of EDAs with two special characteristics:

1. They are designed for problems whose solutions can be expressed as paths&nbsp;$\pi$ in graphs&nbsp;$G$.
2. During the model sampling (i.e., the creation of a path&nbsp;$\pi$), they make use of additional heuristic information obtained from the problem instance.

### The Algorithm

A lot of variants of ACO have been developed over the years.