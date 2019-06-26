## Scalability

The time required to *solve* a hard problem grows exponentially with the input size, e.g., the number of jobs&nbsp;$\jsspJobs$ or machines&nbsp;$\jsspMachines$ in JSSP.
Many optimization problems with practically relevant size cannot be solved to optimality in reasonable time.
The purpose of metaheuristics is to deliver a reasonably good solution within a reasonable computational budget.
Nevertheless, *any* will take longer for a growing number of decision variables for any (non-trivial) problems.
In other words, the *"curse of dimensionality"*&nbsp;[@B1957DP; @B1961ACPAGT] will also strike metaheuristics.

### The Problem: Lack of Scalability

![The growth of the size of the search space for our representation for the Job Shop Scheduling Problem; compare with [@tbl:jsspSearchSpaceTable].](\relative.path{jssp_searchspace_size_scale.svgz}){#fig:jssp_searchspace_size_scale width=70%}

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
Parallelization means that we utilize multiple CPUs or CPU cores on the same machine at the same time.
Distribution means that we use multiple computers connected by network.
Using either approach approach makes sense if we already perform "close to acceptable."

For example, I could try to use the four CPU cores on my laptop to solve a JSSP instance instead of only one.
I could, for instance, execute four separate runs of the hill climber of Simulated Annealing in parallel and then just take the best result after the three minutes have elapsed.
Matter of fact, I could four different algorithm setups or four different algorithms at once.
It makes sense to assume that this would give me a better chance to obtain a good solution.
However, it is also clear that, overall, I am still just utilizing the variance of the results.
In other words, the result I obtain this way will not really be better than the results I could expect from the best of setups or algorithms if run alone.

One more interesting option is that I could run a metaheuristic together with an exact algorithm which can guarantee to find the optimal solution.
For the JSSP, for instance, there exists an efficient dynamic programming algorithm which can solve several well-known benchmark instances within seconds or minutes&nbsp;[@vH2016DPFRASOSOD; @vHNOG2017ACOTPSTJSSPOBDP; @GvHSGT2010STJSSPOBDP].
Of course, there can and will be instances that it cannot solve.
So the idea would be that in case the exact algorithm can find the optimal solution within the computational budget, we take it.
In case it fails, one or multiple metaheuristics running other CPUs may give us a good approximate solution.

Alternatively, I could take a population-based metaheuristic like an Evolutionary Algorithm.
Instead of executing $\nu$ independent runs on $\nu$ CPU cores, I could divide the offspring generation between the different cores.
In other words, each core could create, map, and evaluate $\lambda/\nu$ offsprings.
Later populations are more likely to find better solutions, but require more computational time to do so. 
By parallelizing them, I thus could utilize this power without needed to wait longer.

However, there is a limit to the speed-up we can achieve with either parallelization or distribution.
[Amdahl's Law](http://en.wikipedia.org/wiki/Amdahl's_law)&nbsp;[@A1967VOTSPATALSCC], in particular with the refinements by Kalfa&nbsp;[@K1988B] shows that we can get at most a sub-linear speed-up.
On the one hand, only a certain fraction of a program can be parallelized and each parallel block has a minimum required execution time (e.g., a block must take at least as long as one single CPU instruction).
On the other hand, communication and synchronization between the&nbsp;$\nu$ involved threads or processes is required, and the amount of it grows with their number&nbsp;$\nu$.
There is a limit value for the number of parallel processes&nbsp;$\nu$ above which no further runtime reduction can be achieved.
In summary, when battling an exponential growth of the search space size with a sub-linear gain in speed, we will hit certain limits, which may only be surpassed by qualitatively better algorithms.

#### Indirect Representations

In several application areas, we can try to speed up the search by reducing the size of the search space.
The idea is to define a small search space&nbsp;$\searchSpace$ which is mapped by a representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ to a much larger solution space&nbsp;$\solutionSpace$, i.e., $|\searchSpace|\ll|\solutionSpace|$&nbsp;[@BK1999TWTGDACOEFAEDP; @D2009WAWDINGADS].

The first group of indirect representations uses so-called *generative mappings* assume some underlying structure, usually forms of symmetry, in&nbsp;$\solutionSpace$&nbsp;[@DAS2007ANGEFENNSAOG; @RCON1998GPGE].
When trying to optimize, e.g., the profile of a tire, it makes sense to assume that it will by symmetrically repeated over the whole tire.
Most houses, bridges, trains, car frames, or even plants are symmetric, too.
Many physical or chemical processes exhibit symmetries towards the surrounding system or vessel as well.
Representing both sides of a symmetric solution separately would be a form of redundancy.
If a part of a structure can be repeated, rotated, scaled, or copied to obtain "the whole", then we only need to represent this part.
Of course, there might be asymmetric tire profiles or oddly-shaped bridges which could perform even better and which we would then be unable to discover.
Yet, the gain in optimization speed may make up for this potential loss.

If there are two decision variables $\arrayIndex{\sespel}{1}$ and $\arrayIndex{\sespel}{2}$ and, usually, $\arrayIndex{\sespel}{2}\approx-\arrayIndex{\sespel}{1}$, for example, we could reduce the number of decision variables by one by always setting&nbsp;$\arrayIndex{\sespel}{2}=-\arrayIndex{\sespel}{1}$.
Of course, we then cannot investigate solutions where $\arrayIndex{\sespel}{2}\neq-\arrayIndex{\sespel}{1}$, so we may lose some generality.

Based on these symmetries, indirect representations create a "compressed" version&nbsp;$\searchSpace$ of&nbsp;$\solutionSpace$ of a much smaller size&nbsp;$|\searchSpace|\ll|\solutionSpace|$.
The search then takes place in this compressed search space and thus only needs to consider much fewer possible solutions.
If the assumptions about the structure of the search space is correct, then we will lose only very little solution quality.

A second form of indirect representations is called *ontogenic representation* or *developmental mappings*&nbsp;[@DWT2012ASOSRFEOOGS; @D2009WAWDINGADS; @EL2007DBELOSEI].
They are similar to generative mapping in that the search space is smaller than the solution space.
However, their representational mappings are more complex and often iteratively transform an initial candidate solution with feedback from simulations.
Assume that we want to optimize a metal structure composed of hundreds of beams.
Instead of encoding the diameter of each beam, we encode a neural network that tells us how the diameter of a beam should be changed based on the stress on it.
Then, some initial truss structure is simulated several times.
After each simulation, the diameters of the beams are updated according to the neural network, which is fed with the stress computed in the simulation.
Here, the search space encodes the weights of the neural network&nbsp;$\searchSpace$ while the solution space&nbsp;$\solutionSpace$ represents the diameters of the beams. 
Notice that the size of&nbsp;$\searchSpace$ is unrelated to the size of&nbsp;$\solutionSpace$, i.e., could be the same for 100 or for 1000 beam structures.

#### Exploiting Separability

Sometimes, some decision variables may be unrelated to each other.
If this information can be discovered (see [@sec:epistasis:variableInteraction]), the groups of independent decision variables can be optimized separately.
This will then be faster.
