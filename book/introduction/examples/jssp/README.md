### Example: Job Shop Scheduling Problem {#sec:jsspExample}

Another typical optimization task arises in manufacturing, namely the assignment ("scheduling") of tasks ("jobs") to machines and start times&nbsp;[@P2016STAAS].
In the basic *Job Shop Scheduling Problem* (JSSP)&nbsp;[@CGLL1995STAIA; @GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP], we have a factory ("shop") with several machines.
We receive a set of customer orders for products which we have to produce.
We know the exact sequence in which each product/order needs to pass through the machines and how long it will need at each machine.
So each production job has one sub-job for each machine on which it needs to be processed.
We need to execute these sub-jobs in the right sequence.
Of course, no machine can process more than one order at the same time.
We can decide when which sub-job should begin and we are looking for the starting times that lead to the earliest completion of all jobs, i.e., the shortest makespan.

This general scenario "contains" many simpler problems.
For example, if we only produce one single product, then all jobs would pass through the same machines in the same order.
Clearly, since the JSSP allows for an *arbitrary* machine order per job, being able to solve the JSSP would also enable us to solve the easier problem where the machine order is fixed.
A very simplified example of a JSSP scenario is sketched in [@fig:manufacturing], while we introduce the problem in detail in [@sec:jsspInstance].

![Illustrative sketch of a single production line where work pieces pass through 3 machines sequentially. The JSSP allows for more complex setups, where the order of machines can freely be chosen (but this is harder to paint).](\relative.path{manufacturing.svgz}){#fig:manufacturing width=99%}

The three examples we have discussed so far are, actually, quite related.
They all fit into the broad area of [smart manufacturing](http://en.wikipedia.org/wiki/Smart_manufacturing)&nbsp;[@DEPBS2012SMMIADDP; @HPO2016DPFI4S].
The goal of smart manufacturing is to optimize development, production, and logistics in the industry.
Therefore, computer control is applied to achieve high levels of adaptability in the multi-phase process of creating a product from raw material.
The manufacturing processes and maybe even whole supply chains are networked.
The need for flexibility and a large degree of automation require automatic intelligent decisions.
The key technology necessary to propose such decisions are optimization algorithms.
In a perfect world, the whole production process as well as the warehousing, packaging, and logistics of final and intermediate products would take place in an *optimized* manner.
No time or resources would be wasted as production gets cleaner, faster, and cheaper while the quality increases.
