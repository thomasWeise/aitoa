## Performance Indicators {#sec:basicPerformanceIndicators}

Unfortunately, many optimization problems are computationally hard.
If we want to guarantee that we can solve them to optimality, this would often incur an unacceptably long runtime.
Assume that an algorithm&nbsp;$\mathcal{A}$ can solve a problem instance in ten million years while algorithm&nbsp;$\mathcal{B}$ only needs one million.
In a practical scenario, usually neither is useful nor acceptable and the fact that&nbsp;$\mathcal{B}$ is better than&nbsp;$\mathcal{A}$ would not matter.^[From a research perspective, it does matter, though.]

As mentioned in [@sec:approximationOfTheOptimum], heuristic and metaheuristic optimization algorithms offer a trade-off between runtime and solution quality.
This means we have two measurable performance dimensions, namely:

1. the *time*, possibly measured in different ways (see [@sec:measuringTime]), and
2. the *solution quality*, measured in terms of the best objective value achieved.

If we want to break down performance to single-valued performance indicators, this leads us to two possible choices&nbsp;[@HAFR2010RPBBOB2ES; @FHRA2015CDR1], which are:

1. the solution quality we can get within a pre-defined time and
2. the time we need to reach a pre-defined solution quality.

We illustrate these two options, which corresponds to define vertical and horizontal cuts through the progress diagrams, respectively, in [@fig:performance_indicators_cuts].

![Illustration of the two basic forms to measure performance from raw data, based on a fraction of the actual experimental results illustrated in [@fig:jssp_progress_hc_1swap_log] and inspired by&nbsp;[@HAFR2010RPBBOB2ES; @FHRA2015CDR1].](\relative.path{performance_indicators_cuts.svgz}){#fig:performance_indicators_cuts width=84%}

### Vertical Cuts: Best Solution Quality Reached within Given Time

What we did in our simple experiments so far was mainly to focus on the quality that we could achieve within a certain time, i.e., to proceed according to the "vertical cut" scenario.
In a practical application, we have a limited computational budget and what counts is the quality of the solutions that we can produce within this budget.
The vertical cuts correspond directly to this goal.
When creating the final version of an actual implementation of an optimization method, we will have to focus on this measure.
Since we then will also have to measure time in clock time, this means that our results will depend on the applied hardware and software configuration as well as on the way we implemented our algorithm, down to the choice of the programming language or even compiler.
The advantage of the vertical cut approach is that it can capture all of these issues, as well as performance gains from parallelization or distribution of the algorithms.
Our results obtained with vertical cuts will, however not necessarily carry over to other system configurations or problems.

The "vertical cuts" approach is applied in quite a few competitions and research publications, including, for instance, [@TLSYW2010BFFTC2SSACOLSGO].

### Horizontal Cuts: Runtime Needed until Reaching a Solution of a Given Quality

The idea horizontal cuts corresponds to defining fixed goal qualities and measuring the runtime needed to get there.
For a given problem instance, we would define the target solution quality at which we would consider the problem as solved.
This could be a globally optimal quality or a threshold at which the user considers the solution quality as satisfying.
This approach is preferred in&nbsp;[@HAFR2010RPBBOB2ES; @FHRA2015CDR1] for benchmarking algorithms.

It has the advantage that the number of algorithm steps or seconds needed to solve the problem is a meaningful and interpretable quantity.
We can then make statements such as "Algorithm&nbsp;$\mathcal{B}$ is ten times faster than algorithm&nbsp;$\mathcal{A}$ [in solving this problem]."
An improvement in the objective value, as we could measure in the vertical cut approach, has no such interpretable meaning, since we do not know whether it is hard or easy to, for instance, squeeze out 10 more time units of makespan in a JSSP instance.

The "horizontal cuts" idea is applied, for instance, in the [COCO Framework](http://coco.lri.fr/) for benchmarking numerical optimization algorithms&nbsp;[@HAFR2010RPBBOB2ES; @FHRA2015CDR1].

One disadvantage of this method is that we cannot guarantee that a run will reach the specified goal quality.
Maybe sometimes the algorithm will get trapped in a local optimum before that. 
This is also visible in [@fig:performance_indicators_cuts], where one of the runs did not reach the horizontal cut.
How to interpret such a situation is harder.^[This can be done by assuming that the algorithms would be restarted after consuming certain FEs, but this will be subject to another section (not yet written).]
In the vertical cut scenario, all runs will always reach the pre-defined maximum runtimes, as long as we do not artificially abort them earlier, so we always have a full set of measurements. 

### Determining Goal Values

Regardless of whether we choose vertical or horizontal cuts through the progress diagrams as performance indicators, we will need to define corresponding target values.
In some cases, e.g., in a practical application with fixed budgets and/or upper bounds for the acceptable solution quality, we may trivially know them as parts of the specified requirements.
In other cases, we may:

- first conduct a set of smaller experiments and get an understand of time requirements or obtainable solution qualities,
- know reasonable defaults from experience,
- set goal objective values based on known lower bounds or even known global optima (e.g., from literature), or 
- set them based on what is used in current literature.

Especially in a research setup, the latter is advised.
Here, we need to run experiments that produce outputs which are comparable to what we can find in literature, so we need to have the same goal thresholds.

### Summary

Despite its major use in research scenarios, the horizontal cut method can also make sense in practical applications.
Remember that it is our goal to develop algorithms that can solve the optimization problems within the computational budget, where "solve" again means "reaching a solution of a quality that the user can accept".
If we fail to do so, then our software will probably be rejected.
If we succeed, then the vertical view would allow us to distinguish algorithms which can *over-achieve* the user requirements.
The horizontal view would allow us to distinguish algorithms which can achieve the user requirements *earlier*.

In my opinion, it makes sense to use both indicators.
In&nbsp;[@WCTLTCMY2014BOAAOSFFTTSP; @WNT2010AAOAB; @WWQLT2018ADCOAAPIBAWATCFEDASAIF], for example, we voted for defining a couple of horizontal and vertical cuts to describe the performance of algorithms solving the Traveling Salesman Problem.
By using both horizontal and vertical cuts *and* measure runtime both in FEs and milliseconds, we can get a better understanding of the performance and behavior of our algorithms.

Finally, it should be noted that the goal thresholds for horizontal or vertical cuts can directly lead us to defining termination criteria (see [@sec:terminationCriterion]).
