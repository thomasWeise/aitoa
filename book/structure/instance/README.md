## Problem Instance Data {#sec:problemInstance}

### Definitions

We implicitly distinguish optimization problems (see \text.ref{optimizationProblemMathematical}) from *problem instances*.
While an optimization problem is the general blueprint of the tasks, e.g., the goal of scheduling production jobs to machines, the problem instance is a concrete scenario of the task, e.g., a concrete lists of tasks, requirements, and machines.

\text.block{definition}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance$.}

The problem instance is the input of the optimization algorithms.
A problem instance is related to an optimization problem in the same way an object/instance is related to its `class` in an object-oriented programming language like Java or a `struct` in&nbsp;C.
The `class` defines which member variables exists and what their valid ranges are.
An instance of the class is a piece of memory which holds concrete values for each member variable.

### Example: Job Shop Scheduling {#sec:jsspInstance}

#### JSSP Instance Structure

So how can we characterize a JSSP instance&nbsp;$\instance$?
In the a basic and yet general scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP], our factory has&nbsp;$\jsspMachines\in\naturalNumbersO$ machines.^[where&nbsp;$\naturalNumbersO$ stands for the natural numbers greater than&nbsp;0, i.e., 1, 2, 3, &hellip;]
At each point in time, a machine can either work on exactly one job or do nothing (be idle).
There are&nbsp;$\jsspJobs\in\naturalNumbersO$ jobs that we need to schedule to these machines.
For the sake of simplicity and for agreement between our notation here, the Java source code, and the example instances that we will use, we reference jobs and machines with zero-based indices from&nbsp;$0\dots(\jsspJobs-1)$ and&nbsp;$0\dots(\jsspMachines-1)$, respectively.

Each of the&nbsp;$\jsspJobs$ jobs is composed of&nbsp;$\jsspMachines$ sub-jobs &ndash; the operations &ndash; one for each machine.
Each job may need to pass through these machines in a different order.
The operation&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ must be executed on machine $\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}\in 0\dots(\jsspMachines-1)$ and doing so needs&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$ time units for completion.

This definition at first seems strange, but upon closer inspection is quite versatile.
Assume that we have a factory that produces exactly one product, but different customers may order different quantities.
Here, we would have JSSP instances where all jobs need to be processed by exactly the same machines in exactly the same sequence.
In this case&nbsp;$\jsspOperationMachine{\jsspJobIndex_1}{\jsspMachineIndex}=\jsspOperationMachine{\jsspJobIndex_2}{\jsspMachineIndex}$ would hold for all jobs&nbsp;$\jsspJobIndex_1$ and&nbsp;$\jsspJobIndex_2$ and all operation indices&nbsp;$\jsspMachineIndex$.
The jobs would pass through all machines in the same order but may have different processing times (due to the different quantities).

We may also have scenarios where customers can order different types of products, say the same liquid soap, but either in bottles or big cannisters.
Then, different machines may be needed for different orders.
This is similar to the situation illustrated in [@fig:jssp_sketch], where a certain job&nbsp;$\jsspJobIndex$ does not need to be executed on a machine&nbsp;$\jsspMachineIndex'$.
We then can simply set the required time&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ to&nbsp;0 for the operation&nbsp;$\jsspMachineIndex$ with&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}=\jsspMachineIndex'$.

In other words, the JSSP instance structure described here already encompasses a wide variety of real-world production situations.
This means that if we can build an algorithm which can solve this general type of JSSP well, it can also automatically solve the above-mentioned special cases.

#### Sources for JSSP Instances

In order to practically play around with optimization algorithms, we need some concrete instances of the JSSP.
Luckily, the optimization community provides "benchmark instances" for many different optimization problems.
Such common, well-known instances are important, because they allow researchers to compare their algorithms.
The eight classical and most commonly used sets of benchmark instances are published in&nbsp;[@FT1963PLCOLJSSR; @ABZ1988TSBPFJSS; @AC1991ACSOTJSSP; @SWV1992NSSFSPWATJSS; @YN1992AGAATLSJSI; @L1998RCPSAEIOHSTS; @DMU1998BFSSP; @T199BFBSP].
Their data can be found (sometimes partially) in several repositories in the internet, such as

- the [*OR&#8209;Library*](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/jobshopinfo.html) managed by Beasley&nbsp;[@B1990OLDTPBEM],
- the comprehensive [set of JSSP instances](http://jobshop.jjvh.nl/) provided by van&nbsp;Hoorn&nbsp;[@vH2015JSIAS; @vH2018TCSOBOBIOTJSSP], where also state-of-the-art results are listed,
- [Oleg Shylo's Page](http://optimizizer.com/jobshop.php)&nbsp;[@S2019JSSPH], which, too, contains up-to-date experimental results,
- [Éric Taillard's Page](http://mistic.heig-vd.ch/taillard/problemes.dir/ordonnancement.dir/ordonnancement.html), or, finally,
- my own repository [jsspInstancesAndResults](http://github.com/thomasWeise/jsspInstancesAndResults)&nbsp;[@W2019JRDAIOTJSSP], where I collect all the above problem instances and many results from existing works.

We will try to solve JSSP instances obtained from these collections.
They will serve as illustrative example of how to approach optimization problems.
In order to keep the example and analysis simple, we will focus on only four instances, namely

1. instance `abz7` by Adams et&nbsp;al.&nbsp;[@ABZ1988TSBPFJSS] with 20&nbsp;jobs and 15&nbsp;machines
2. instance `la24` by Lawrence&nbsp;[@L1998RCPSAEIOHSTS] with 15&nbsp;jobs and 10&nbsp;machines,
3. instance `swv15` by Storer et&nbsp;al.&nbsp;[@SWV1992NSSFSPWATJSS] with 50&nbsp;jobs and 10&nbsp;machines, and
4. instance `yn4` by Yamada and Nakano&nbsp;[@YN1992AGAATLSJSI] with 20&nbsp;jobs and 20&nbsp;machines.

These instances are contained in text files available at <http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/jobshop1.txt>, <http://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/instance-data/instance_data.txt>, and in <http://jobshop.jjvh.nl/>.
Of course, if we really want to solve a new type of problem, we will usually use many benchmark problem instances to get a good understand about the performance of our algorithm(s).
Only for the sake of clarity of presentation, we will here limit ourselves to these above four problems.

#### File Format and `demo` Instance

For the sake of simplicity, we created one additional, smaller instance to describe the format of these files, as illustrated in [@fig:jssp_demo_instance].

![The meaning of the text representing our `demo` instance of the JSSP, as an example of the format used in the OR&#8209;Library.](\relative.path{demo_instance.svgz}){#fig:jssp_demo_instance width=90%}

In the simple text format used in OR&#8209;Library, several problem instances can be contained in one file.
Each problem instance&nbsp;$\instance$ is starts and ends with a line of several `+` characters.
The next line is a short description or title of the instance.
In the third line, the number&nbsp;$\jsspJobs$ of jobs is specified, followed by the number&nbsp;$\jsspMachines$ of machines.
The actual IDs or indexes of machines and jobs are 0-based, similar to array indexes in Java.
The JSSP instance definition is completed by&nbsp;$\jsspJobs$ lines of text, each of which specifying the operations of one job&nbsp;$\jsspJobIndex\in0\dots(\jsspJobs-1)$.
Each operation&nbsp;$\jsspMachineIndex$ is specified as a pair of two numbers, the ID&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}$ of the machine that is to be used (violet), from the interval&nbsp;$0\dots(\jsspMachines-1)$, followed by the number of time units&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ the job will take on that machine.
The order of the operations defines exactly the order in which the job needs to be passed through the machines.
Of course, each machine can only process at most one job at a time.

In our demo instance illustrated in [@fig:jssp_demo_instance], this means that we have&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines.
Job&nbsp;0 first needs to be processed by machine&nbsp;0 for 10&nbsp;time units, it then goes to machine&nbsp;1 for 20&nbsp;time units, then to machine&nbsp;2 for 20&nbsp;time units, then to machine&nbsp;3 for 40&nbsp;time units, and finally to machine&nbsp;4 for 10&nbsp;time units.
This job will thus take at least&nbsp;100 time units to be completed, if it can be scheduled without any delay or waiting period, i.e., if all of its operations can directly be processed by their corresponding machines.
Job&nbsp;3 first needs to be processed by machine&nbsp;4 for 50&nbsp;time units, then by machine&nbsp;3 for 30&nbsp;time units, then by machine&nbsp;2 for 15&nbsp;time units, then by machine&nbsp;0 for&nbsp;20 time units, and finally by machine&nbsp;1 for 15&nbsp;time units.
It would not be allowed to first send Job&nbsp;3 to any machine different from machine&nbsp;4 and after being processed by machine&nbsp;4, it must be processed by machine&nbsp;3 &ndash; althoug it may be possible that it has to wait for some time, if machine&nbsp;3 would already be busy processing another job.
In the ideal case, job&nbsp;3 could be completed after 130&nbsp;time units.

#### A Java Class for JSSP Instances

This structure of a JSSP instance can be represented by the simple Java class given in [@lst:JSSPInstance].

\repo.listing{lst:JSSPInstance}{Excerpt from a Java class for representing the data of a JSSP instance.}{java}{src/main/java/aitoa/examples/jssp/JSSPInstance.java}{}{relevant}

Here, the two-dimensional array&nbsp;`jobs` directly receives the data from operation lines in the text files, i.e., each row stands for a job and contains machine IDs and processing times in an alternating sequence.
The actual source file of the class `JSSPInstance` accompanying our book also contains additional code, e.g., for reading such data from the text file, which we have omitted here as it is unimportant for the understanding of the scenario. 
