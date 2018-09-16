## Problem Instance Data

We often implicitly distinguish optimization problems (see \text.ref{optimizationProblemMathematical}) from *problem instances*.
While an optimization problem is the general blueprint of the tasks, e.g., the goal of scheduling production jobs to machines, the problem instance is a concrete scenario of the task, e.g., a concrete lists of tasks, requirements, and machines.

\text.block{definition}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance.}

A problem instance is related to an optimization problem like an object/instance to a class in an object-oriented programming language.

So how can we characterize a JSSP instance?
In the most basic scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS], our factory ("shop") has&nbsp;$\elementOf{\instance}{m}\in\naturalNumbersO$ machines.
There are&nbsp;$\elementOf{\instance}{n}\in\naturalNumbersO$ jobs that we need to schedule to these machines.

```{#lst.ref .java caption="blabla blabla. [src](http://www.github.com/thomasWeise/blabla/blob/master/file.java)"}
class xyz {
...
}