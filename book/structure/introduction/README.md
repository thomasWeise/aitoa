## Introduction {#sec:structure:intro}

From the examples that we have seen, we know that optimization problems come in different shapes and forms.
Without training, it is not directly clear how to identify, define, understand, or solve them.
The goal of this chapter is to bring some order into this mess.
We will approach an optimization task step-by-step by formalizing its components, which will then allow us to apply efficient algorithms to it.
This *structure of optimization* is a blueprint that can be applied in many different scenarios as basis to apply different optimization algorithms.

First, let us clarify what *optimization problems* actually are.

\text.block{definition}{optimizationProblemEconomical}{An *optimization problem* is a situation which requires deciding for one choice from a set of possible alternatives in order to reach a predefined/required benefit at minimal costs.}

\text.ref{optimizationProblemEconomical} presents an economical point of view on optimization in a rather informal manner.
We can refine it to the more mathematical formulation given in \text.ref{optimizationProblemMathematical}.

\text.block{definition}{optimizationProblemMathematical}{The goal of solving an *optimization problem* is finding an input value&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ from a set&nbsp;$\solutionSpace$ of allowed values for which a function $\objf:\solutionSpace\mapsto\realNumbers$ takes on the smallest value.}

From these definitions, we can already deduce a set of necessary components that make up such an optimization problem.
We will look at them from the perspective of a programmer:

1. First, there is the problem instance data&nbsp;$\instance$, i.e., the concrete situation which defines the framework conditions for the solutions we try to find.
   This input data of the optimization algorithm is discussed in [@sec:problemInstance].
2. The second component is the data structure&nbsp;$\solutionSpace$ representing possible solutions to the problem.
   This is the output of the optimization software and is discussed in [@sec:solutionSpace]. 
3. Finally, the objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ rates the quality of the candidate solutions&nbsp;$\solspel\in\solutionSpace$.
   This function embodies the goal that we try to achieve, e.g., (minimize) costs.
   It is discussed in [@sec:objectiveFunction].

If we want to solve a Traveling Salesmen Problem (see [@sec:intro:logistics]), then the instance data includes the names of the cities that we want to visit and a map with the information of all the roads between them (or simply a distance matrix).
The candidate solution data structure could simply be a "city list" containing each city exactly once and prescribing the visiting order.
The objective function would take such a city list as input and compute the overall tour length.
It would be subject to minimization. 

Usually, in order to actually practically implement an optimization approach, there often will also be

1. a search space&nbsp;$\searchSpace$, i.e., a simpler data structure for internal use, which can more efficiently be processed by an optimization algorithm than&nbsp;$\solutionSpace$ ([@sec:searchSpace]),
2. a representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$, which translates "points"&nbsp;$\sespel\in\searchSpace$ from the search space&nbsp;$\searchSpace$ to candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$ ([@sec:searchSpace]),
3. search operators&nbsp;$\searchOp:\searchSpace^n\mapsto\searchSpace$, which allow for the iterative exploration of the search space&nbsp;$\searchSpace$ ([@sec:searchOperators]), and
4. a termination criterion, which tells the optimization process when to stop ([@sec:terminationCriterion]).

At first glance, this looks a bit complicated &ndash; but rest assured, it won't be.
We will explore all of these structural elements that make up an optimization problem in this chapter, based on a concrete example of the Job Shop Scheduling Problem (JSSP) from [@sec:jsspExample]&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP; @BDP1996TJSSPCANST].
This example should give a reasonable idea about how the structural elements and formal definitions involved in optimization can be realized in practice.
While any actual optimization problem can require very different data structures and operations from what we will discuss here, the general approach and ideas that we will discuss on specific examples should carry over to many scenarios.

**At this point, I would like to make explicitly clear that the goal of this book is NOT to solve the JSSP particularly well. Our goal is to have an easy-to-understand yet practical introduction to optimization.**
This means that sometimes I will intentionally and knowingly choose an easy-to-understand approach, algorithm, or data structure over a better but more complicated one.
Also, our aim is to nurture the general ability to come up with a solution approach to a new optimization problem within a reasonably short time, i.e., without being able to conduct research over several years.
That being said, the algorithms and approaches discussed here are not necessarily inefficient.
While having much room for improvement, we eventually reach approaches that find  decent solutions (see, e.g., [@sec:saResultsOnJSSP]).
