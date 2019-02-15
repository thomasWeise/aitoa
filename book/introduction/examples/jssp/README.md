## Example: Job Shop Scheduling Problem {#sec:jsspExample}

Another typical optimization task arises in manufacturing, namely the assignment ("scheduling") of tasks ("jobs") to machines and start times&nbsp;[@P2016STAAS].
In the basic *Job Shop Scheduling Problem* (JSSP)&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP], we have factory ("shop") with several machines.
We receive a set of customer orders for products which we have to produce.
We know the exact sequence in which each product/order needs to pass through the machines and how long it will need at each machine.
So each production job has one sub-job for each machine on which it needs to be processed.
We need to execute these sub-jobs in the right sequence.
Of course, no machine can process more than one order at once.
We can decide when which sub-job should begin and we are looking for the starting times that lead to the earliest completion of all jobs, i.e., the shortest makespan.
A very simplified version of this is sketched in [@fig:manufacturing], while we introduce the problem in detail in [@sec:jsspInstance].

![Illustrative sketch of a single production line where work pieces pass through 3 machines sequentially. The JSSP allows for more complex setups, where the order of machines can freely be chosen (but this is harder to paint).](\relative.path{manufacturing.svgz}){#fig:manufacturing width=99%}

