## Problem Instance Data {#sec:problemInstance}

### Definitions

We implicitly distinguish optimization problems (see \text.ref{optimizationProblemMathematical}) from *problem instances*.
While an optimization problem is the general blueprint of the tasks, e.g., the goal of scheduling production jobs to machines, the problem instance is a concrete scenario of the task, e.g., a concrete lists of tasks, requirements, and machines.

\text.block{definition}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance$.}

A problem instance is related to an optimization problem in the same way an object/instance is related to its class in an object-oriented programming language like Java.

### Example: Job Shop Scheduling {#sec:jsspInstance}

So how can we characterize a JSSP instance&nbsp;$\instance$?
In the most basic scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP], our factory has&nbsp;$\jsspMachines\in\naturalNumbersO$ machines.
Each machine can perform one job at a time or be idle.
There are&nbsp;$\jsspJobs\in\naturalNumbersO$ jobs that we need to schedule to these machines.
For the sake of simplicity and for agreement between our notation here, the Java source code, and the example instances that we will use, we reference jobs and machines with zero-based indices from&nbsp;$0\dots(\jsspJobs-1)$ and&nbsp;$0\dots(\jsspMachines-1)$, respectively.

Each of the&nbsp;$\jsspJobs$ jobs is composed of&nbsp;$\jsspMachines$ sub-jobs, one for each machine.
The sub-job&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ must be executed on machine&nbsp;$\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex}$ and doing so needs&nbsp;$\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ time units for completion.
This setup also allows us to represent the situation where a certain job&nbsp;$\jsspJobIndex$ does not need to be executed on a machine&nbsp;$\jsspMachineIndex'$.
We then can simply set the required time&nbsp;$\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ to&nbsp;0 for the sub-job&nbsp;$\jsspMachineIndex$ with&nbsp;$\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex}=\jsspMachineIndex'$.
The scenario also allows us to represent problems such as those illustrated in [@fig:manufacturing], where all jobs need to be processed by exactly the same machines in exactly the same sequence.
In this case&nbsp;$\jsspSubJobMachine{\jsspJobIndex_1}{\jsspMachineIndex}=\jsspSubJobMachine{\jsspJobIndex_2}{\jsspMachineIndex}$ would hold for all jobs&nbsp;$\jsspJobIndex_1$ and&nbsp;$\jsspJobIndex_2$ and all sub-job indices&nbsp;$\jsspMachineIndex$.
In other words, the JSSP described here already encompasses a wide variety of real-world production situations.

Let us now look at some example instances for the JSSP.
Beasley&nbsp;[@B1990OLDTPBEM] manages the  [*OR-Library*](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/jobshopinfo.html), a library of example instances for many optimization problems from the field of operations research.
An even more [comprehensive set of JSSP instances](http://jobshop.jjvh.nl/) is provided by van&nbsp;Hoorn&nbsp;[@vH2015JSIAS; @vH2018TCSOBOBIOTJSSP].
[Here](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/jobshop1.txt) and [here](http://jobshop.jjvh.nl/), the concrete JSSP instances which we will use can be downloaded as text file.
For the sake of simplicity, we created one additional, smaller instance to describe this format, as illustrated in [@fig:jssp_demo_instance].

![The meaning of the text representing our `demo` instance of the JSSP, as an example of the format used in the OR-Library.](\relative.path{demo_instance.svgz}){#fig:jssp_demo_instance width=90%}

In the simple text format used in OR-Library, several problem instances can be contained in one file.
Each problem instance&nbsp;$\instance$ is starts and ends with a line of several `+` characters.
The next line is a short description or title of the instance.
In the third line, the number&nbsp;$\jsspJobs$ of jobs is specified, followed by the number&nbsp;$\jsspMachines$ of machines.
The actual IDs or indexes of machines and jobs are 0-based, similar to array indexes in Java.
The JSSP instance definition is completed by&nbsp;$\jsspJobs$ lines of text, each of which specifying the sub-jobs of one job&nbsp;$\jsspJobIndex\in0\dots(\jsspJobs-1)$.
Each sub-job&nbsp;$\jsspMachineIndex$ is specified as a pair of two numbers, the ID&nbsp;$\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex}$ of the machine that is to be used (violet), from the interval&nbsp;$0\dots(\jsspMachines-1)$, followed by the number of time units&nbsp;$\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ the job will take on that machine.
The order of the sub-jobs defines exactly the order in which the job needs to be passed through the machines.
Of course, each machine can only process at most one job at a time.

In our demo instance illustrated in [@fig:jssp_demo_instance], this means that we have&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines.
Job&nbsp;0 first needs to be processed by machine&nbsp;0 for 10&nbsp;time units, it then goes to machine&nbsp;1 for 20&nbsp;time units, then to machine&nbsp;2 for 20&nbsp;time units, then to machine&nbsp;3 for 40&nbsp;time units, and finally to machine&nbsp;4 for 10&nbsp;time units.
This job will thus take at least&nbsp;100 time units to be completed, if it can be scheduled without any delay or waiting period, i.e., if all of its sub-jobs can directly be processed by their corresponding machines.
Job&nbsp;3 first needs to be processed by machine&nbsp;4 for 50&nbsp;time units, then by machine&nbsp;3 for 30&nbsp;time units, then by machine&nbsp;2 for 15&nbsp;time units, then by machine&nbsp;0 for&nbsp;20 time units, and finally by machine&nbsp;1 for 15&nbsp;time units.
It would not be allowed to first send Job&nbsp;3 to any machine different from machine&nbsp;4 and after being processed by machine&nbsp;4, it must be processed by machine&nbsp;3 &ndash; althoug it may be possible that it has to wait for some time, if machine&nbsp;3 would already be busy processing another job.
In the ideal case, job&nbsp;3 could be completed after 130&nbsp;time units.

This structure of a JSSP instance can be represented by the simple Java class given in [@lst:JSSPInstance].

\repo.listing{lst:JSSPInstance}{Excerpt from a Java class for representing the data of a JSSP instance.}{java}{src/main/java/aitoa/examples/jssp/JSSPInstance.java}{}{relevant}

Here, the two-dimensional array `jobs` directly receives the data from sub-job lines in the text files, i.e., each row stands for a job and contains machine IDs and processing times in an alternating sequence.
The actual source file of the class `JSSPInstance` accompanying our book also contains additional code, e.g., for reading such data from the text file, which we have omitted here as it is unimportant for the understanding of the scenario.

The *OR-Library* contains 82&nbsp;JSSP instances of varying sizes specified as text files in the format discussed here.
Even more instances can be found on [van&nbsp;Hoorn's website](http://jobshop.jjvh.nl/).
We will try to solve them in this book as an illustrative example of how to approach optimization problems.
In order to keep the example simple, we will focus on only four instances, namely

1. instance `abz7` by Adams et&nbsp;al.&nbsp;[@ABZ1988TSBPFJSS] with 20&nbsp;jobs and 15&nbsp;machines
2. instance `la24` by Lawrence&nbsp;[@L1998RCPSAEIOHSTS] with 15&nbsp;jobs and 10&nbsp;machines,
3. instance `yn4` by Yamada and Nakano&nbsp;[@YN1992AGAATLSJSI] with 20&nbsp;jobs and 20&nbsp;machines, and
4. instance `swv15` by Storer et&nbsp;al.&nbsp;[@SWV1992NSSFSPWATJSS] with 50&nbsp;jobs and 10&nbsp;machines.
