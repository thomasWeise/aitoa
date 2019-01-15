# The Structure of Optimization {#sec:structure}

From the examples that we have seen, we know that optimization problems come in different forms.
It is not directly clear how to identify, define, understand, or solve them.
The goal of this first chapter is to bring order some order into this mess.
We will approach an optimization task by step-by-step formalizing its components, which will then allow us to apply efficient algorithms to it.
This *structure of optimization* is a blueprint that can be applied in many different scenarios to obtain at least an initial, working optimization approach.

So far, we have already seen a few examples of *optimization problems*.
Let us begin our quest to bring structure into the chaos by condensing their essence into definitions.

\text.block{definition}{optimizationProblemEconomical}{An *optimization problem* is a situation which requires deciding for one choice from a set of possible alternatives in order to reach a predefined/required benefit at minimal costs.}

\text.ref{optimizationProblemEconomical} presents an economical point of view on optimization in a rather informal manner.
We can refine it to the more mathematical formulation given in \text.ref{optimizationProblemMathematical}.

\text.block{definition}{optimizationProblemMathematical}{The goal of solving an *optimization problem* is finding an input value $\globalOptimum{\solspel}\in\solutionSpace$ from a set of allowed values&nbsp;$\solutionSpace$ for which a function $\objf:\solutionSpace\mapsto\realNumbers$ takes on the smallest value.}

From these definitions, we can already deduce a set of necessary components that make up such an optimization problem.

1. The problem instance data&nbsp;$\instance$, i.e., the concrete situation which defines the framework conditions for the solutions we try to find ([@sec:problemInstance]).
2. The data structure $\solutionSpace$ representing possible solutions to the problem ([@sec:solutionSpace]).
3. The objective function $\objf:\solutionSpace\mapsto\realNumbers$ which rates the quality of the candidate solutions $\solspel\in\solutionSpace$ ([@sec:objectiveFunction]).

Usually, in order to actually implement an optimization approach, there also will be

1. A search space&nbsp;$\searchSpace$ which can more easily be processed by an optimization algorithm under the hood than&nbsp;$\solutionSpace$ ([@sec:searchSpace]).
2. A representation mapping $\repMap:\searchSpace\mapsto\solutionSpace$ which translates the points&nbsp;$\sespel$ of the search space&nbsp;$\searchSpace$ to candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$ ([@sec:searchSpace]).
3. Search operators&nbsp;$\searchOp:\searchSpace^n\mapsto\searchSpace$, which allow for the iterative exploration of the search space&nbsp;$\searchSpace$ ([@sec:searchOperators]).
4. A termination criterion&nbsp;$\shouldTerminate$ which tells the optimization algorithm when to stop ([@sec:terminationCriterion]).

We will explore these structural elements that make up an optimization problem in this chapter, based on a concrete example of the Job Shop Scheduling Problem (JSSP) from [@sec:jsspExample].
This example should give a reasonable idea about how the general definitions can be applied in practice.
While any actual optimization problem can require very different data structures and operations from what we will discuss here, the general approach should carry over to many scenarios while also clarifying the above-mentioned key components.

\relative.input{instance/README.md}
\relative.input{solutionSpace/README.md}
\relative.input{objective/README.md}
\relative.input{globalOptima/README.md}
\relative.input{searchSpace/README.md}
\relative.input{searchOperators/README.md}
\relative.input{termination/README.md}
