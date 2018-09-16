## Problem Instance Data

We often implicitly distinguish optimization problems (see \text.ref{optimizationProblemMathematical}) from *problem instances*.
While an optimization problem is the general blueprint of the tasks, e.g., the goal of scheduling production jobs to machines, the problem instance is a concrete scenario of the task, e.g., a concrete lists of tasks, requirements, and machines.

\text.block{definition}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance$.}

A problem instance is related to an optimization problem like an object/instance to a class in an object-oriented programming language.

So how can we characterize a JSSP instance&nbsp;$\instance$?
In the most basic scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS], our factory ("shop") has&nbsp;$\elementOf{\instance}{m}\in\naturalNumbersO$ machines.
There are&nbsp;$\elementOf{\instance}{n}\in\naturalNumbersO$ jobs that we need to schedule to these machines.
Actually, we have a list&nbsp;$\elementOf{\instance}{j}$ of&nbsp;$\elementOf{\instance}{n}\in\naturalNumbersO$ jobs, where each job&nbsp;$\arrayIndex{\elementOf{\instance}{j}}{p}$ (with $p\in1\dots n$), in turn, is a list of&nbsp;$\elementOf{\instance}{m}\in\naturalNumbersO$ sub-jobs.
Each sub-job~$\arrayIndex{\arrayIndex{\elementOf{\instance}{j}}{p}}{q}$ (with $q\in1\dots m$) must be executed on a specific machine&nbsp;$\elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{j}}{p}}{q}}{machine}$ and therefore needs a specific time&nbsp;$\elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{j}}{p}}{q}}{time}$.
This also models the situation where a certain job does not need to be executed on some of the machines, because we then can set the corresponding time simply to 0.