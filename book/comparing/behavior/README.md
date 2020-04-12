## Comparing Algorithm Behaviors: Processes over Time

We already discussed that optimization algorithm performance has two dimensions: the required runtime and the solution quality we can get.
However, this is not all.
Many optimization algorithms are *anytime algorithms*.
In [@sec:anytimeAlgorithm] and in our experiments we have learned that they attempt to improve their solutions incrementally.
The performance of an algorithm on a given problem instance is thus not a single point in the two-dimensional "time vs. quality"-space.
It is a curve.
We have plotted several diagrams illustrating exactly this, the progress of algorithms over time, in our JSSP experiments in [@sec:metaheuristics].
However, in all of our previous discussions, we have ignored this fact and concentrated on computing statistics and comparing "end results."

Is this a problem?
In my opinon, yes.
In a practical application, like in our example scenario of the JSSP, we have a clear computational budget.
If this is exhausted, we have an end result.

However, in research, this is not actually true.
If we develop a new algorithm or tackle a new problem in a research setup, we do not necessarily have an industry partner who wants to directly apply our results.
This is not the job of research, the job of research is to find new methods and concepts that are promising, from which concrete practical applications may arise later.
As researchers, we therefore do often not have a concrete application scenario.
We therefore need to find results which should be valid in a wide variety of scenarios defined by the people who later use our research.

This means we do not have a computational budget fixed due to constraints arising from an application.
Anytime optimization algorithms, such as metaheuristics, do usually not guarantee that they will find the global optimum.
Often we cannot determine whether the current best solution is a global optimum or not either.
This means that such algorithms do not have a "natural" end point &ndash; we could let them run forever. 
Instead, we define termination criteria that we deem reasonable.

### Why reporting only end results is bad.

As a result, many publications only provide statistics about the results they have measured at these self-selected termination criteria in form of tables in their papers.
When doing so, the imaginary situation illustrated in [@fig:points_vs_lines] could occur.

!["End results" experiments with algorithms versus how the algorithms could actually have performed.](\relative.path{points_vs_lines.svgz}){#fig:points_vs_lines width=84%}

Here, three imaginary researchers have applied three imaginary algorithms to an imaginary problem instance.
Independently, they have chosen three different computational budgets and report the median "end results" of their algorithms.
From the diagram on the left-hand side, *it looks as if* we have three incomparable algorithms.
Algorithm&nbsp;$\algorithmStyle{C}$ needs a long time, but provides the best median result quality.
Algorithm&nbsp;$\algorithmStyle{B}$ is faster, but we pay for it by getting worse results.
Finally, algorithm&nbsp;$\algorithmStyle{A}$ is the fastest, but has the worst median result quality.
We could conclude that, if we would have much time, we would choose algorithm&nbsp;$\algorithmStyle{C}$ while for small computational budgets, algorithm&nbsp;$\algorithmStyle{A}$ looks best.

In reality, the actual course of the optimization algorithms could have looked as illustrated in the diagram on the right-hand side.
Here, we find that algorithm&nbsp;$\algorithmStyle{C}$ is always better than algorithm&nbsp;$\algorithmStyle{B}$, which, in turn, is always better than algorithm&nbsp;$\algorithmStyle{A}$. 
However, we cannot get this information as only the "end results" were reported.

**Takeaway-message:** Analyzing end results is normally not enough, you need to analyze the whole algorithm behavior&nbsp;[@WCTLTCMY2014BOAAOSFFTTSP; @WWCTL2016GVLSTIOPSOEAP; @WWQLT2018ADCOAAPIBAWATCFEDASAIF].

### Progress Plots

We, too, provide tables for the average achieved result qualities in our JSSP examples.
However, we always provide diagrams that illustrate the progress of our algorithms over time, too.
Visualizations of the algorithm behavior over runtime can provide us important information.

![Different algorithms may perform best at different points in time.](\relative.path{performance_cuts.svgz}){#fig:performance_cuts width=74%}

[@fig:performance_cuts], for instance, illustrates a scenario where the best algorithm to choose depends on the available computational budget.
Initially, an algorithm&nbsp;$\algorithmStyle{B}$ produces the better median solution quality.
Eventually, it is overtaken by another algorithm&nbsp;$\algorithmStyle{A}$, which initially is slower but converges to better results later on.
Such a scenario would be invisible if only results for one of the two computational budgets are provided.

Hence, such progress diagrams thus cannot only tell us which algorithms to choose in an actual application scenario later on, where an exact computational budget is defined.
During our research, they can also tell us if it makes sense to, e.g., restart our algorithms.
If the algorithm does not improve early on but we have time left, a restarting may be helpful &ndash; which is what we did for the hill climbing algorithm in [@sec:stochasticHillClimbingWithRestarts], for instance.
