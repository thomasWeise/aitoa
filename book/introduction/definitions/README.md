# Basic Definitions

All the above examples represent *optimization problems*.
Let us condense their essence into definitions.

\text.block{definition}{optimizationProblemEconomical}{An *optimization problem* is a situation which requires deciding for one choice from a set of possible alternatives in order to reach a predefined/required benefit at minimal costs.}

\text.ref{optimizationProblemEconomical} presents an economical point of view on optimization in a rather informal manner.
We can refine it to the more mathematical formulation given in \text.ref{optimizationProblemMathematical}.

\text.block{definition}{optimizationProblemMathematical}{Solving an *optimization problem* requires finding an input value $\optimum{\solspel}\in\solutionSpace$ from a set of allowed values $\solutionSpace$ for which a function $\objf:\solutionSpace\mapsto\realNumbers$ takes on the smallest possible value.}

Generally, we have a set $\solutionSpace$ of possible elements $\solspel\in\solutionSpace$ to choose from.
Each element $\solspel$ comes with a cost $\objf(\solspel)$ attached and we want to pick the one with the smallest cost.

\text.block{definition}{candidateSolution}{The elements $\solspel\in\solutionSpace$ of an optimization problem are called *candidate solutions*.}

\text.block{definition}{objectiveFunction}{The function $\objf:\solutionSpace\mapsto\realNumbers$ which rates the quality of the candidate solutions is called *objective function* in an objective function.}

Here, we do not make any assumption here about what $\solutionSpace$ is nor about the nature of the objective function $\objf$.
