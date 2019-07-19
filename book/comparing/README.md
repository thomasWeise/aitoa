# Evaluating and Comparing Optimization Algorithms {#sec:comparingOptimizationAlgorithms}

We have now learned quite a few different approaches for solving optimization problems.
Whenever we have introduced a new algorithm, we have compared it with some of the methods we have discussed before.

Clearly, when approaching an optimization problem, our goal is to solve it in the best possible way.
What the best possible way is will depend on the problem itself as well as the framework conditions applying to us, say, the computational budget we have available.

It is important that *performance* is almost always relative.
If we have only a single method that can be applied to an optimization problem, then it is neither good nor bad, because we can either take it or leave it. 
Instead, we often start by first developing one idea and then try to improve it.
Of course, we need to compare each new approach with the ones we already have.
Alternatively, especially if we work in a research scenario, maybe we have a new idea which then needs to be compared to a set of existing state-of-the-art algorithms.
Let us now discuss here how such comparisons can be conducted in a rigorous, reliable, and reproducible way.

\relative.input{coding/README.md}
\relative.input{time/README.md}
\relative.input{performanceIndicators/README.md}
\relative.input{statistics/README.md}
\relative.input{tests/README.md}
\relative.input{behavior/README.md}
