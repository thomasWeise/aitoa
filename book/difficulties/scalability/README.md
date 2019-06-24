## Scalability

The time required to *solve* a hard problem grows exponentially with the input size, e.g., the number of jobs&nbsp;$\jsspJobs$ or machines&nbsp;$\jsspMachines$ in JSSP.
Many optimization problems with practically relevant size cannot be solved to optimality in reasonable time.
The purpose of metaheuristics is to deliver a reasonably good solution within a reasonable computational budget.
Nevertheless, *any* will take longer for a growing number of decision variables for any (non-trivial) problems.
In other words, the *"curse of dimensionality"*&nbsp;[@B1957DP; @B1961ACPAGT] will also strike metaheuristics.

### The Problem: Lack of Scalability

![The growth of the size of the search space for our representation for the Job Shop Scheduling Problem; compare with [@tbl:jsspSearchSpaceTable].](\relative.path{jssp_searchspace_size_scale.svgz}){#fig:jssp_searchspace_size_scale}

[@fig:jssp_searchspace_size_scale] illustrates how the size&nbsp;$|\searchSpace|$ of the search space&nbsp;$\searchSpace$ grows with the number of machines&nbsp;$\jsspMachines$ and jobs&nbsp;$\jsspJobs$ in our representation for the JSSP.
Since the axis for&nbsp;$|\searchSpace|$ is logarithmically scaled, it is easy to see that the size grows very fast, exponentially with&nbsp;$\jsspMachines$ and&nbsp;$\jsspJobs$.
This means that most likely, the number of points to be investigated by an algorithm to discover a near-optimal solution also increases quickly with these problem parameters.
In other words, if we are trying to schedule the production jobs for a larger factory with more machines and customers, the time needed to find good solutions will increase drastically.

This is also reflected in our experimental results:
Simulated Annealing could discover the globally optimal solution for instance `la24` ([@sec:saResultsOnJSSP]) and in median is only 1.1% off.
`la24` is the instance with the smallest search space size.
For `abz7`, the second smallest instance, we almost reached the optimum with SA and in median were 3% off, while for the largest instances, the difference was bigger.

### Countermeasures

#### Parallelization and Distribution

First, we can try to improve the performance of our algorithms by parallelization and distribution.
This approach makes sense if we already perform "close to acceptable."

#### Indirect Representations

When trying to optimize, e.g., the profile of a tire, it makes sense to assume that it will by symmetric over the whole tyre.
Most houses, bridges, trains, car frames, or even plants are symmetric, too.
Many physical or chemical processes exhibit symmetries towards the surrounding system or vessel as well.

In several application areas, we can try to speed up the search by sacrificing areas in the search space.
Indirect representations assume some underlying structure, usually forms of symmetry, in&nbsp;$\searchSpace$.
If there are two decision variables $\arrayIndex{\sespel}{1}$ and $\arrayIndex{\sespel}{2}$ and we assume that $\arrayIndex{\sespel}{2}=-\arrayIndex{\sespel}{1}$, for example, we can reduce the number of decision variables by one.
Of course, we then cannot investigate solutions where $\arrayIndex{\sespel}{2}\neq-\arrayIndex{\sespel}{1}$. 

Based on these symmetries, indirect representations create a "compressed" version&nbsp;$\searchSpace'$ of&nbsp;$\searchSpace$ of a much smaller size&nbsp;$|\searchSpace'|\ll|\searchSpace|$.
The search then takes place in this compressed search space and thus only needs to consider much fewer possible solutions.
If the assumptions about the structure of the search space is correct, then we will lose only very little solution quality.

#### Exploiting Separability

Sometimes, some decision variables may be unrelated to each other.
If this information can be discovered (see [@sec:epistasis:variableInteraction]), the groups of independent decision variables can be optimized separately.
This will then be faster.
