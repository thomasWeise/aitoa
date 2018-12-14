## Problem Instance Data {#sec:problemInstance}

### Definitions

We implicitly distinguish optimization problems (see \text.ref{optimizationProblemMathematical}) from *problem instances*.
While an optimization problem is the general blueprint of the tasks, e.g., the goal of scheduling production jobs to machines, the problem instance is a concrete scenario of the task, e.g., a concrete lists of tasks, requirements, and machines.

\text.block{definition}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance$.}

A problem instance is related to an optimization problem in the same way an object/instance is related to its class in an object-oriented programming language like Java.

### Example: Job Shop Scheduling {#sec:jsspInstance}

So how can we characterize a JSSP instance&nbsp;$\instance$?
In the most basic scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @E199BFBSP], our factory has&nbsp;$\jsspMachines\in\naturalNumbersO$ machines.
Each machine can perform one job at a time or be idle.
There are&nbsp;$\jsspJobs\in\naturalNumbersO$ jobs that we need to schedule to these machines.
For the sake of simplicity and agreement between our notation here and the Java source code examples, we will index jobs and machines with zero-based indices, i.e., indexes from&nbsp;$0\dots(\jsspJobs-1)$ and&nbsp;$0\dots(\jsspMachines-1)$, respectively.

Each of these&nbsp;$\jsspJobs$ jobs is composed of&nbsp;$\jsspMachines$ sub-jobs, one for each machine.
The sub-job&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ must be executed on machine&nbsp;$\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex}$ and there needs&nbsp;$\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ time units for completion.
This setup also allow us to represent the situation where a certain job&nbsp;$\jsspJobIndex$ does not need to be executed on a machine&nbsp;$\jsspMachineIndex'$, because we then can set the required time&nbsp;$\jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex}$ to 0 for the sub-job&nbsp;$\jsspMachineIndex$ with&nbsp;$\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex}=\jsspMachineIndex'$.

Beasley&nbsp;[@B1990OLDTPBEM] manages the  [*OR-Library*](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/jobshopinfo.html), a library of example instances for many optimization problems from the field of operations research.
An even more [comprehensive set of JSSP instances](http://jobshop.jjvh.nl/) is provided by van Hoorn&nbsp;[@vH2015JSIAS; @vH2018TCSOBOBIOTJSSP].
[Here](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/jobshop1.txt) and [here](http://jobshop.jjvh.nl/), the concrete JSSP instances which we will use can be downloaded as text file.
For the sake of simplicity, we created one additional, smaller instance to describe this format, as illustrated in [@fig:jssp_demo_instance].

![The meaning of the text representing our `demo` instance of the JSSP, as an example of the format used in the OR-Library.](\relative.path{demo_instance.svgz}){#fig:jssp_demo_instance width=90%}

In the simple text format used in OR-Library, each problem instance&nbsp;$\instance$ is delimited by line of several `+` characters.
The next line is a short description or title of the instance.
In the third line, the number&nbsp;$\jsspJobs$ of jobs is specified, followed by the number&nbsp;$\jsspMachines$ of machines.
The actual IDs or indexes of machines and jobs are 0-based, similar to array indexes in Java.
The JSSP instance definition is completed by&nbsp;$\jsspJobs$ lines of text, each of which specifying the sub-jobs of one job&nbsp;$\jsspJobIndex\in0\dots(\jsspJobs-1)$.
Each sub-job&nbsp;$\jsspMachineIndex$ is specified as a pair of two numbers, the ID&nbsp;$\jsspJobMachine{\jsspJobIndex}{\jsspMachineIndex}$ of the machine that is to be used (violet), from the interval&nbsp;$0\dots(\jsspMachines-1)$, followed by the number of time units&nbsp;$\jsspJobTime{\jsspJobIndex}{\jsspMachineIndex}$ the job will take on that machine.
The order of the sub-jobs defines exactly the order in which the job needs to be passed through the machines.
Each machine can only process at most one job at a time.

In our demo instance illustrated in [@fig:jssp_demo_instance], this means that we have&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines.
Job&nbsp;0 first needs to be processed by machine 0 for 10 time units, it then goes to machine 1 for 20 time units, then to machine 2 for 20 time units, then to machine 3 for 40 time units, and finally to machine 4 for 10 time units.
Job&nbsp;3 first needs to be processed by machine 4 for 50 time units, then by machine 3 for 30 time units, then by machine 2 for 15 time units, then by machine 0 for 20 time units, and finally by machine 1 for 15 time units.
It would not be allowed to first send Job&nbsp;3 to any machine different from machine 4 and after being processed by machine 4, it must be processed by machine 3 &ndash; althoug it may be possible that it has to wait for some time, if machine 3 would currently be busy processing another job.

This structure can be represented by the simple Java class given in [@lst:JSSPInstance].

\repo.listing{lst:JSSPInstance}{Excerpt from a Java class for representing the data of a JSSP instance.}{java}{src/main/java/aitoa/examples/jssp/JSSPInstance.java}{}{relevant}

Here, the two-dimensional array `jobs` directly receives the data from sub-job lines in the text files, i.e., each row stands for a job and contains machine IDs and processing times in an alternating sequence.
The actual source file also contains additional code, e.g., for reading such data from the text file, which we have omitted here.

The *OR-Library* contains 82 JSSP instances of varying sizes specified as text files in the format discussed here, even more instances can be found on van Hoorn's website.
We will try to solve them in this book as an example of optimization problems.
In order to keep the example simple, we will focus on only four instances, namely

1. instance `abz7` by Adams et&nbsp;al.&nbsp;[@ABZ1988TSBPFJSS] with 15 jobs and 20 machines
2. instance `la24` by Lawrence&nbsp;[@L1998RCPSAEIOHSTS] with 15 jobs and 10 machines,
3. instance `yn4` by Yamada and Nakano&nbsp;[@YN1992AGAATLSJSI] with 20 jobs and 20 machines, and
4. instance `swv15` by Storer et&nbsp;al.&nbsp;[@SWV1992NSSFSPWATJSS] with 50 jobs and 10 machines.
