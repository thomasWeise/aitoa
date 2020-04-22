### Example: Job Shop Scheduling Problem {#sec:jsspExample}

Another typical optimization task arises in manufacturing, namely the assignment ("scheduling") of tasks ("jobs") to machines in order to optimize a given performance criterion ("objective").
Scheduling&nbsp;[@P2016STAAS; @PS2009FYOSASOM] is one of the most active areas of operational research for more than  six decades.

In the *Job Shop Scheduling Problem* (JSSP)&nbsp;[@CGLL1995STAIA; @GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP; @BDP1996TJSSPCANST], we have a factory ("shop") with several machines.
We receive a set of customer orders for products which we have to produce.
We know the exact sequence in which each product/order needs to pass through the machines and how long it will need at each machine.
Each production job has one sub-job ("operation") for each machine on which it needs to be processed.
These operations must be performed in the right sequence.
Of course, no machine can process more than one operation at the same time.
While we must obey these constraints, we can decide about the time at which each of the operations should begin.
Often, we are looking for the starting times that lead to the earliest completion of all jobs, i.e., the shortest makespan.

Such a scenario is sketched in [@fig:jssp_sketch], where four orders for different types of shoe should be produced.
The resulting jobs pass through different workshops (or machines, if you want) in different order.
Some, like the green sneakers, only need to be processed by a subset of the workshops.

![Illustrative sketch of a JSSP scenario with four jobs where four different types of shoe should be produced, which require different workshops ("machines") to perform different production steps.](\relative.path{jssp_sketch.svgz}){#fig:jssp_sketch width=70%}

This general scenario encompasses many simpler problems.
For example, if we only produce one single product, then all jobs would pass through the same machines in the same order.
Customers may be able to order different quantities of the product, so the operations of the different jobs for the same machine may need different amounts of time.
This is the so-called Flow Shop Scheduling Problem (FSSP) &ndash; and it has been defined back in 1954&nbsp;[@J1954OTATSPSWSTI]!

Clearly, since the JSSP allows for an *arbitrary* machine order per job, being able to solve the JSSP would also enable us to solve the FSSP, where the machine order is fixed.
We will introduce the JSSP in detail in [@sec:jsspInstance] and use it as the main example in this book on which we will step-by-step excercise different optimization methods.
