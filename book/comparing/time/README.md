## Measuring Time {#sec:measuringTime}

Let us investigate the question: "What does good optimization algorithm performance mean?"
As a first approximation, we could state that an optimization algorithm performs well if it can solve the optimization problem to optimality.
If two optimization algorithms can solve the problem, then we prefer the faster one.
This brings us to the question what *faster* means.
If we want to compare algorithms, we need a concept of time. 

### Clock Time

Of course, we already know a very well-understood concept of time.
We use it every day: the clock time.
In our experiments with the JSSP, we have measured the runtime mainly in terms of milliseconds that have passed on the clock as well.

\text.block{definition}{clockTime}{The consumed *clock time* is the time that has passed since the optimization process was started.}

This has several *advantages*:

- Clock time is a quantity which makes physical sense and which is intuitive clear to us.
- In applications, we often have well-defined computational budgets and thus need to know how much time our processes really need.
- Many research works report the consumed runtime, so there is a wide basis for comparisons.
- If you want to publish your own work, you should report the runtime that your implementation of your algorithm needs as well.
- If we measure the runtime of your algorithm implementation, it will include everything that the code you are executing does.
If your code loads files, allocates data structures, or does complicated calculations &ndash; everything will be included in the measurement.
- If we can parallelize or even distribute our algorithms, clock time measurements still make sense.

But reporting the clock time consumed by an algorithm implementation also has *disadvantages*:

- The measured time strongly depends on your computer and system configuration.
Runtimes measured on different machines or on different system setups are therefore inherently incomparable or, at least, it is easy to make mistakes here.
Measured runtimes reported twenty years ago are basically useless now, unless they differ from current measurements very significantly, by orders of magnitudes.
- Runtime measurements also are measurements based on a given *implementation*, not *algorithm*.
An algorithm implemented in the `C` programming language may perform very different compared to the very same algorithm implemented in `Java`.
An algorithm implementation using a hash map to store and retrieve certain objects may perform entirely different from the same algorithm implemented using a sorted list.
Hence, effort should be invested to create good implementations before measuring their consumed runtime and, very important, the same effort should be invested into all compared algorithms&hellip; 
- Runtime measurements are not always very accurate.
There may be many effects which can mess up our measurements, ranging from other processes being executed on the same system and slowing down our process, delays caused by swapping or paging, to shifts of CPU speeds due to dynamic CPU clocking.
- Runtime measurements are not very precise.
Often, clocks have resolutions only down to a few milliseconds, and within even a millisecond many action can happen on today's CPUs.

There exist ideas to *mitigate* the drawback that clock times are hard to compare&nbsp;[@JMG2004EAOHFTS; @WCTLTCMY2014BOAAOSFFTTSP].
For a specific optimization problem, one can clearly specify a simple standardized algorithm&nbsp;$\algorithmStyle{B}$, which always terminates in a relatively short time, say a simple heuristic.
Before applying the algorithm&nbsp;$\algorithmStyle{A}$ that we actually want to investigate to an instance&nbsp;$\instance$ of the problem, we first apply&nbsp;$\algorithmStyle{B}$ to&nbsp;$\instance$ and measure the time&nbsp;$T[\algorithmStyle{B}|\instance]$ it takes on our machine.
We then can divide the runtime&nbsp;$T[\algorithmStyle{A}|\instance]$ needed by&nbsp;$\algorithmStyle{A}|\instance$ by&nbsp;$T[\algorithmStyle{B}|\instance]$.
We can then hope that the resulting, normalized runtime is somewhat comparable across machines.
Of course, this is a problem-specific approach, it does not solve the other problems with measuring runtime directly, and it likely will still not generalize over different computer architectures or programming languages. 

### Consumed Function Evaluations

Instead of measuring how many milliseconds our algorithm needs, we often want a more abstract measure.
Another idea is to count the so-called (objective) *function evaluations* or FEs for short.

\text.block{definition}{fes}{The consumed *function evaluations*&nbsp;(FEs) are the number of calls to the objective function issued since the beginning of the optimization process.}

Performing one function evaluation means to take one point from the search space&nbsp;$\sespel\in\searchSpace$, map it to a candidate solution&nbsp;$\solspel\in\solutionSpace$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$ and then computing the quality of&nbsp;$\solspel$ by evaluating the objective function&nbsp;$\objf(\solspel)$.
Usually, the number of FEs is also equal to the number of search operations applied, which means that each FE includes one application of either a nullary, unary, or binary search operator. 
Counting the FEs instead of measuring time directly has the following *advantages*:

- FEs are completely machine- and implementation-independent and therefore can more easily be compared.
If we re-implement an algorithm published 50 years ago, it should still consume the same number of FEs.
- Counting FEs is always accurate and precise, as there cannot be any outside effect or process influencing the measurement (because that would mean that an internal counter variable inside of our process is somehow altered artificially). 
- Results in many works are reported based on FEs or in a format from which we can deduce the consumed FEs.
- If you want to publish your research work, you should probably report the consumed FEs as well. 
- In many optimization processes, the steps included in an FE are the most time consuming ones.
Then, the actual consumed runtime is proportional to the consumed FEs and "performing more FEs" roughly equals to "needing more runtime."
- Measured FEs are something like an empirical, simplified version of algorithmic time complexity.
FEs are inherently close to theoretical computer science, roughly equivalent to "algorithm steps," which are the basis for theoretical runtime analysis.
For example, researchers who are good at Maths can go an derive things like bounds for the "expected number of FEs" to solve a problem for certain problems and certain algorithms.
Doing this with clock time would neither be possible nor make sense.
But with FEs, it can sometimes be possible to compare experimental with theoretical results.

But measuring time in function evaluations also has some *disadvantages*, namely:

- There is no guaranteed relationship between FEs and real time.
- An algorithm may have hidden complexities which are not "appearing" in the FEs.
For instance, an algorithm could necessitate a lengthy pre-processing procedure before sampling even the first point from the search space.
This would not be visible in the FE counter, because, well, it is not an FE.
The same holds for the selection step in an Evolutionary Algorithm (realized as sorting in [@sec:evolutionaryAlgorithmWithoutRecombinationAlgo]).
Although this is probably a very fast procedure, it will be outside of what we can measure with FEs. 
- A big problem is that one function evaluation can have extremely different actual time requirements and algorithmic complexity in different algorithms.
For instance, it is known that in a Traveling Salesman Problem (TSP)&nbsp;[@ABCC2006TTSPACS; @GP2002TTSPAIV] with $n$&nbsp;cities, some algorithms can create an evaluate a new candidate solution from an existing one within a *constant* number of steps, i.e., in&nbsp;$\bigO{1}$, while others need a number of steps growing quadratically with&nbsp;$n$, i.e., are in&nbsp;$\bigO{n^2}$&nbsp;[@WCTLTCMY2014BOAAOSFFTTSP].
If an algorithm of the former type can achieve the same quality as an algorithm of the latter type, we could consider it as better even if it would need ten times as many FEs.
Hence, FEs are only fair measurements for comparing two algorithms if they take approximately the same time in both of them.
- Time measured in FEs is harder to comprehend in the context of parallelization and distribution of algorithms.

There exists an idea to *mitigate* the problem with the different per-FE complexities:
counting algorithm steps in a problem-specific method with a higher resolution.
In&nbsp;[@WCTLTCMY2014BOAAOSFFTTSP], for example, it was proposed to count the number of distance evaluations on the TSP and in&nbsp;[@HWHC2013HILSFM], bit flips are counted on the MAX-SAT problem.

### Do not count generations!

As discussed in \text.ref{generationEA} in [@sec:evolutionaryAlgorithmWithoutRecombination], a generation is one iteration of a population-based optimization method.
At first glance, generations seem to be a machine-independent time measure much like FEs.
However, measuring runtime in "generations" is a very bad thing to do.

In one such generation, multiple candidate solutions are generated and evaluated.
How many?
This depends on the population size settings, e.g., $\mu$ and&nbsp;$\lambda$.
So generations are not comparable across different population sizes.

Even more: if we use algorithm enhancements like clearing (see [@sec:eaClearingInObjectiveSpace]), then the number of new points sampled from the search space may be different in each generation.
In other words, the number of consumed generations does not necessarily have a relationship to FEs (and neither to the actual consumed runtime).
Therefore, counting FEs should always be preferred over counting generations.

### Summary

Both ways of measuring time have advantages and disadvantages.
If we are working on a practical application, then we would maybe prefer to evaluate our algorithm implementations based on the clock time they consume.
When implementing a solution for scheduling jobs in an actual factory or for routing vehicles in an actual logistics scenario, what matters is the real, actual time that the operator needs to wait for the results.
Whether these time measurements are valuable ten years from now or not plays no role.
It also does not matter too much how much time our processes would need if executed on a hardware from what we have or if they were re-implemented in a different programming language.

If we are trying to develop a new algorithm in a research scenario, then may counting FEs is slightly more important.
Here we aim to make our results comparable in the long term and we very likely need to compare with results published based on FEs.
Another important point is that a black-box algorithm (or metaheuristic) usually makes very few assumptions about the actual problem to which it will be applied later.
While we tried to solve the JSSP with our algorithms, you probably have seen that we could plug almost arbitrary other search and solution spaces, representation mappings, or objective functions into them.
Thus, we often use artificial problems where FEs can be done very quickly as test problems for our algorithms, because then we can do many experiments.
Measuring the runtime of algorithms solving artificial problems does not make that much sense, unless we are working on some algorithms that consume an unusual amount of time.

That being said, I personally prefer to **measure both FEs and clock time**.
This way, we are on the safe side.

