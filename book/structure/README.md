# The Structure of Optimization

We have already seen a few examples of *optimization problems*.
Let us condense their essence into definitions.

\text.block{definition}{optimizationProblemEconomical}{An *optimization problem* is a situation which requires deciding for one choice from a set of possible alternatives in order to reach a predefined/required benefit at minimal costs.}

\text.ref{optimizationProblemEconomical} presents an economical point of view on optimization in a rather informal manner.
We can refine it to the more mathematical formulation given in \text.ref{optimizationProblemMathematical}.

\text.block{definition}{optimizationProblemMathematical}{Solving an *optimization problem* requires finding an input value $\optimum{\solspel}\in\solutionSpace$ from a set of allowed values $\solutionSpace$ for which a function $\objf:\solutionSpace\mapsto\realNumbers$ takes on the smallest possible value.}

Any optimization problem has at least the following components, which we will explore in detail in this chapter.

1. The problem instance&nbsp;$\instance$ data, i.e., the concrete scenario that we will try to solve.
2. The data structure $\solutionSpace$ representing possible solutions to the problem.
3. The objective function $\objf:\solutionSpace\mapsto\realNumbers$ which computes the cost of the candidate solutions $\solspel\in\solutionSpace$.

We will explore all of these structural elements that make up an optimization problem in this chapter, based on a concrete example of the Job Shop Scheduling Problem (JSSP) from [@sec:jsspExample].

\relative.input{instance/README.md}
\relative.input{solutionSpace/README.md}
\relative.input{objective/README.md}
\relative.input{globalOptima/README.md}