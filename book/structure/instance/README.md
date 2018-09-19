## Problem Instance Data

### Definitions

We often implicitly distinguish optimization problems (see \text.ref{optimizationProblemMathematical}) from *problem instances*.
While an optimization problem is the general blueprint of the tasks, e.g., the goal of scheduling production jobs to machines, the problem instance is a concrete scenario of the task, e.g., a concrete lists of tasks, requirements, and machines.

\text.block{definition}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance$.}

A problem instance is related to an optimization problem like an object/instance to a class in an object-oriented programming language.

### Example: Job Shop Scheduling {#sec:jsspInstance}

So how can we characterize a JSSP instance&nbsp;$\instance$?
In the most basic scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS], our factory has&nbsp;$\elementOf{\instance}{m}\in\naturalNumbersO$ machines.
Each machine can perform one job at a time or be idle.
There are&nbsp;$\elementOf{\instance}{n}\in\naturalNumbersO$ jobs that we need to schedule to these machines.
Actually, we have a list&nbsp;$\elementOf{\instance}{jobs}$ of&nbsp;$\elementOf{\instance}{n}$ jobs, where each job&nbsp;$\arrayIndex{\elementOf{\instance}{jobs}}{p}$ (with $p\in1\dots \elementOf{\instance}{n}$), in turn, is a list of&nbsp;$\elementOf{\instance}{m}$ sub-jobs.
Each sub-job&nbsp;$\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{q}$ (with $q\in1\dots \elementOf{\instance}{m}$) must be executed on a specific machine&nbsp;$\elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{q}}{machine}$ and therefore needs a specific time&nbsp;$\elementOf{\arrayIndex{\arrayIndex{\elementOf{\instance}{jobs}}{p}}{q}}{time}$.
This also allow us to represent the situation where a certain job does not need to be executed on some of the machines, because we then can set the corresponding time simply to 0.

Beasley&nbsp;[@B1990OLDTPBEM] manages the  [*OR-Library*](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/jobshopinfo.html), a library of example instances for many optimization problems from the field of operations research.
[Here](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/jobshop1.txt), concrete JSSP instances can be downloaded as text file.
For the sake of simplicity, we created one additional, smaller instance to describe this format, as illustrated in [@fig:jssp_demo_instance].

![The meaning of the text representing our demo instance of the JSSP, as an example of the format used in the OR-Library.](\relative.path{demo_instance.svgz}){#fig:jssp_demo_instance width=90%}

In the simple text format used in OR-Library, each problem instance $\instance$ is delimited by line of several `+` characters.
The next line is a short description or title of the instance.
In the third line, the number&nbsp;$\elementOf{\instance}{n}$ of jobs is specified, followed by the number&nbsp;$\elementOf{\instance}{m}$ of machines.
The actual IDs or indexes of machines and jobs are 0-based, similar to array indexes in Java.
The JSSP instance definition is completed by $\elementOf{\instance}{n}$ lines of text, each of which specifying the sub-jobs of one job, for jobs $0$ to $\elementOf{\instance}{n}-1$.
Here, each sub-job is a pair of two numbers, the ID of the machine that is to be used (violet), from the interval $0\dots\elementOf{\instance}{m}-1$, followed by the number of time units the job will take on that machine.
The order of the sub-jobs defines exactly the order in which the job needs to be passed through the machines.
Each machine can only process at most one job at a time.

In our demo instance illustrated in [@fig:jssp_demo_instance], this means that we have&nbsp;$\elementOf{\instance}{n}=4$ jobs and&nbsp;$\elementOf{\instance}{m}=5$ machines.
Job&nbsp;0 first needs to be processed by machine 0 for 10 time units, it then goes to machine 1 for 20 time units, then to machine 2 for 20 time units, then to machine 3 for 40 time units, and finally to machine 4 for 10 time units.
Job&nbsp;3 first needs to be processed by machine 4 for 50 time units, then by machine 3 for 30 time units, then by machine 2 for 15 time units, then by machine 0 for 20 time units, and finally by machine 1 for 15 time units.
It would not be allowed to first send Job&nbsp;3 to any machine different from machine 4 and after being processed by machine 4, it must be processed by machine 3 &ndash; althoug it may be possible that it has to wait for some time, if machine 3 would currently be busy processing another job.

This structure can be represented by the simple Java class given in [@lst:JSSPInstance].

\repo.listing{lst:JSSPInstance}{Excerpt from a Java class for representing the data of a JSSP instance.}{java}{src/main/java/aitoa/examples/jssp/JSSPInstance.java}{}{relevant}

Here, the member variables `m` and `n` stand for the number&nbsp;$\elementOf{\instance}{m}$ of machines and the number&nbsp;$\elementOf{\instance}{n}$ of jobs, respectively.
The two-dimensional array `jobs` directly receives the data from sub-job lines in the text files, i.e., each row stands for a job and contains machine IDs and processing times in an alternating sequence.
The actual source file also contains additional code, e.g., for reading such data from the text file, which we have omitted here.

The OR-Library contains 82 JSSP instances of varying sizes specified as text files in the format discussed here.
We will try to solve them in this book as an example of optimization problems.
In order to keep the example simple, we will focus on only four instances, namely

1. instance `abz7` by Adams et&nbsp;al.&nbsp;[@ABZ1988TSBPFJSS] with 15 jobs and 20 machines
2. instance `la24` by Lawrence&nbsp;[@L1998RCPSAEIOHSTS] with 15 jobs and 10 machines,
3. instance `yn4` by Yamada and Nakano&nbsp;[@YN1992AGAATLSJSI] with 20 jobs and 20 machines, and
4. instance `swv15` by Storer et&nbsp;al.&nbsp;[@SWV1992NSSFSPWATJSS] with 50 jobs and 10 machines.
