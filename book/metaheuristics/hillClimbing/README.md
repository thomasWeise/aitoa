## Hill Climbing {#sec:hillClimbing}

Our first algorithm, random sampling, is not very efficient.
It does not make any use of the information it "sees" during the optimization process.
Each search step consists of creating an entirely new, entirely random candidate solution.
Each search step is thus independent of all prior steps.
If the problem that we try to solve is entirely without structure, then this is already the best we can do.
But our JSSP problem is not without structure.
For example, we can assume that if we swap the last two jobs in a schedule, the makespan of the resulting new schedule should still be somewhat similar to the one of the original plan. 
Actually, most reasonable optimization problems have a lot of structure.
We therefore should try to somehow make use of the information gained from sampling candidate solutions.

Local search algorithms&nbsp;[@HS2005SLSFAA; @WGOEB] offer one idea for how to do that.
They remember one point&nbsp;$\sespel^m$ in the search space&nbsp;$\searchSpace$.
In every step, a local search algorithm investigates $g\geq1$ points&nbsp;$\sespel_i$ which are derived from and are similar to&nbsp;$\sespel^m$.
From the joined set of these $g$&nbsp;points and&nbsp;$x^m$, only one point is chosen as the (new or old)&nbsp;$x^m$.
All the other points are discarded.

\text.block{definition}{causality}{Causality means that small changes in the features of an object (or candidate solution) also lead to small changes in its behavior (or objective value).}

Local search exploits a property of many optimization problems which is called *causality*&nbsp;[@R1973ES; @R1994ES; @WCT2012EOPABT; @WZCN2009WIOD].
If we have two points in the search space that only differ a little bit, then they likely map to similar schedules, which, in turn, likely have similar makespans.
This means that if we have a good candidate solution, then there may exist similar solutions which are better.
We hope to find one of them and then continue trying to do the same from there.

### Ingredient: Unary Search Operation for the JSSP {#sec:hillClimbingJssp1Swap}

For now, let us limit ourselves to local searches creating&nbsp;$g=1$ new point in each iteration.
The question arises how we can create a candidate solution which is similar to, but also slightly different from, one that we already have?
Our search algorithms are working in the search space&nbsp;$\searchSpace$.
So we need one operation which accepts an existing point&nbsp;$\sespel\in\searchSpace$ and produces a slightly modified copy of it as result.
In other words, we need to implement a unary search operator!

On a JSSP with $\jsspMachines$&nbsp;machines and $\jsspJobs$&nbsp;jobs, our representation&nbsp;$\searchSpace$ encodes a schedule as an integer array of length&nbsp;$\jsspMachines*\jsspJobs$ containing each of the job IDs (from $0\dots(\jsspJobs-1)$) exactly&nbsp;$\jsspMachines$ times.
The sequence in which these job IDs occur then defines the order in which the jobs are assigned to the machines, which is realized by the representation mapping&nbsp;$\repMap$ (see [@lst:JSSPRepresentationMapping]).

One idea to create a slightly modified copy of such a point&nbsp;$\sespel$ in the search space would be to simply swap two of the jobs in it.
Such a&nbsp;`1swap` operator can be implemented as follows:

1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. Pick a random index&nbsp;$i$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
3. Pick a random index&nbsp;$j$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
4. If the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$ are the same, then go back to point&nbsp;3.
5. Swap the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$.
6. Return the now modified copy&nbsp;$\sespel'$ of&nbsp;$\sespel$.

Point&nbsp;4 is important since swapping the same values makes no sense, as we would then get&nbsp;$\sespel'=\sespel$.
Then, also the mappings&nbsp;$\repMap(\sespel)$ and&nbsp;$\repMap(\sespel')$ would be the same, i.e., we would actually not make a "move" and just waste time.

\repo.listing{lst:JSSPUnaryOperator1Swap}{An excerpt of the `1swap` operator for the JSSP, an implementation of the unary search operation interface [@lst:IUnarySearchOperator]. `1swap` swaps two jobs in our encoding of Gantt diagrams.}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1Swap.java}{}{relevant}

We implemented this operator in [@lst:JSSPUnaryOperator1Swap].
Notice that the operator is randomized, i.e., applying it twice to the same point in the search space will likely yield different results.

![An example for the application of `1swap` to an existing point in the search space (top-left) for the `demo` JSSP instance. It yields a slightly modified copy (top-right) with two jobs swapped. If we map these to the solution space (bottom) using the representation mapping&nbsp;$\repMap$, the changes marked with violet frames occur (bottom-right).](\relative.path{jssp_unary_1swap_demo.svgz}){#fig:jssp_unary_1swap_demo width=99%}

In [@fig:jssp_unary_1swap_demo], we illustrate the application of this operator to one point&nbsp;$\sespel$ in the search space for our&nbsp;`demo` JSSP instance.
It swaps the two jobs at index&nbsp;$i=10$ and&nbsp;$j=15$ of&nbsp;$\sespel$.
In the new, modified copy&nbsp;$\sespel'$, the jobs&nbsp;$3$ and&nbsp;$0$ at these indices have thus traded places.
The impact of this modification becomes visible when we map both&nbsp;$\sespel$ and&nbsp;$\sespel'$ to the solution space using the representation mapping&nbsp;$\repMap$.
The&nbsp;$3$ which has been moved forward now means that job&nbsp;$3$ will be scheduled before job&nbsp;$1$ on machine&nbsp;$2$.
As a result, the last two operations of job&nbsp;$3$ can now finish earlier on machines&nbsp;$0$ and&nbsp;$1$, respectively.
However, time is wasted on machine&nbsp;$2$, as we first need to wait for the first two operations of job&nbsp;$3$ to finish before we can execute it there.
Also, job&nbsp;$1$ finishes now later on that machine, which also delays its last operation to be executed on machine&nbsp;$4$.
This pushes back the last operation of job&nbsp;$0$ (on machine&nbsp;$4$) as well.
The new candidate solution&nbsp;$\repMap(\sespel')$ thus has a longer makespan of&nbsp;$\objf(\repMap(\sespel'))=195$ compared to the original solution with&nbsp;$\objf(\repMap(\sespel))=180$.

In other words, our application of&nbsp;`1swap` in [@fig:jssp_unary_1swap_demo] has led us to a worse solution.
This will happen most of the time.
As soon as we have a good solution, the solutions similar to it tend to be worse in average and the number of even better solutions in the neighborhood tends to get smaller.
However, if we would have been at&nbsp;$\sespel'$ instead, an application of `1swap` could well have resulted in&nbsp;$\sespel$.
In summary, we can hope that the chance to find a really good solution by iteratively sampling the neighborhoods of good solutions is higher compared to trying to randomly guessing them (as `rs` does) &nbsp; even if most of our samples are worse.

### Stochastic Hill Climbing Algorithm

#### The Algorithm

Stochastic Hill Climbing&nbsp;[@RN2002AI; @S2008TADM; @WGOEB] is the simplest implementation of local search.
It is also sometimes called localized random search&nbsp;[@S2003ITSSAO].
It proceeds as follows:

1. Create one random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using the nullary search operator.
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\sespel$ to get a slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\obspel$, then store $\sespel'$&nbsp;in&nbsp;$\sespel$, store $\solspel'$&nbsp;in&nbsp;$\solspel$, and store $\obspel'$&nbsp;in&nbsp;$\obspel$.
6. Return the best encountered objective value&nbsp;$\obspel$ and the best encountered solution&nbsp;$\solspel$ to the user.

This algorithm is implemented in [@lst:HillClimber] and we will refer to it as&nbsp;`hc`.

\repo.listing{lst:HillClimber}{An excerpt of the implementation of the Hill Climbing algorithm, which remembers the best-so-far solution and tries to find better solutions in its neighborhood.}{java}{src/main/java/aitoa/algorithms/HillClimber.java}{}{relevant}

#### Results on the JSSP {#sec:hc_1swap:jssp:results}

We now plug our unary operator&nbsp;`1swap` into our `hc`&nbsp;algorithm and apply it to the JSSP.
We will refer to this setup as&nbsp;`hc_1swap` and present its results with those of&nbsp;`rs` in [@tbl:jssp_hc_1swap_results].

\relative.input{jssp_hc_1swap_results.md}

: The results of the hill climber `hc_1swap` in comparison with those of random sampling algorithm&nbsp;`rs`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_hc_1swap_results}

The hill climber outperforms random sampling in almost all aspects.
It produces better mean, median, and best solutions.
Actually, its median and mean solutions are better than the best solutions discovered by&nbsp;`rs`.
Furthermore, it finds its solutions much much faster.
The median time&nbsp;`med(t)` consumed until the algorithm converges is not more than one seconds.
The median number of consumed FEs&nbsp;`med(FEs)` to find the best solutions per run is between 7000 and 105'000, i.e., between one 50^th^ and one 2500^th^ of the number of FEs needed by&nbsp;`rs`.

It may be interesting to know that this simple `hc_1swap`&nbsp;algorithm can already achieve some remotely acceptable performance, even though it is very far from being useful.
For instance, on instance `abz7`, it delivers better best and mean results than all four Genetic Algorithms (GAs) presented in&nbsp;[@JPDS2014CAODRIGAFJSSP].
On `la24`, only one of the four (GA&#8209;PR) has a better best result and all lose in terms of mean result.
On this instance, `hc_1swap` finds a better best solution than all six GAs in [@A2010RIGAFTJSPACS] and better mean results than five of them.
In [@sec:evolutionaryAlgorithm], we will later introduce (better-performing!) Evolutionary Algorithms, to which GAs belong.

The Gantt charts of the median solutions of `hc_1swap` are illustrated in [@fig:jssp_gantt_hc_1swap_med].
They are more compact than those discovered by `rs` and illustrated in [@fig:jssp_gantt_rs_med].

![The Gantt charts of the median solutions obtained by the&nbsp;`hc_1swap` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_hc_1swap_med.svgz}){#fig:jssp_gantt_hc_1swap_med width=84%}

![The median of the progress of the&nbsp;`hc_1swap` and&nbsp;`rs` algorithm over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). Different from [@fig:jssp_progress_rs_log], we do not plot the single runs but only shade areas between quantiles.](\relative.path{jssp_progress_hc_1swap_log.svgz}){#fig:jssp_progress_hc_1swap_log width=84%}

[@fig:jssp_progress_hc_1swap_log] shows how both&nbsp;`hc_1swap` and&nbsp;`rs` progress over time.
In [@fig:jssp_progress_rs_log], we plotted every individual run.
This time, we plot the median (see [@sec:meanVsMedian]) of achieved quality at each time step as thick line.
In the background, we plot the whole range of the values as semi-transparent region.
The more runs fall into one region, the stronger we plot the color:
In the outer borders of the lightest color shade mark the range between the best and worst results of any run at a given time.
The next stronger-shaded region contains about 95% of the runs.
Then follow by 68% of the runs while the strongest-shaded region holds half of the runs.

It should be noted that I designed the experiments in such a way that there were 101 different random seeds per instance.
For each instance, all algorithms use the same random seeds, i.e., the hill climber and random sampling start with the same initial solutions.
Still, the shaded regions of the two algorithms separate almost immediately.
 
We already knew from [@tbl:jssp_hc_1swap_results] that&nbsp;`hc_1swap` converges very quickly.
After initial phases with quick progress, it stops making any further progress, usually before 1000&nbsp;milliseconds have been consumed.
This fits well to the values `med(t)` given in [@tbl:jssp_hc_1swap_results].
With the exception of instance&nbsp;`la24`, where two runs of the hill climber performed exceptionally bad, there is much space between the runs of&nbsp;`rs` and&nbsp;`hc_1swap`.
We can also see again that there is more variance in the end results of&nbsp;`hc_1swap` compared to those of&nbsp;`rs`, as they are spread wider in the vertical direction.

### Stochastic Hill Climbing with Restarts {#sec:stochasticHillClimbingWithRestarts}

Upon close inspection of the results, we notice that we are again in the same situation as with the&nbsp;`1rs` algorithm:
There is some variance between the results and most of the "action" takes place in a short time compared to our total computational budget (1&nbsp;second vs. 3&nbsp;minutes).
Back in [@sec:randomSamplingAlgo] we made use of this situation by simply repeating&nbsp;`1rs` until the computational budget was exhausted, which we called the `rs`&nbsp;algorithm.
Now the situation is a bit different, however.
`1rs`&nbsp;creates exactly one solution and is finished, whereas our hill climber does not actually finish.
It keeps creating modified copies of the current solution, only that these eventually do not mark improvements anymore.
Then, the algorithm has converged into a *local optimum*.

\text.block{definition}{localOptimum}{A *local optimum* is a point&nbsp;$\localOptimum{\sespel}$ in the search space which maps to a better candidate solution than any other points in its neighborhood (see \text.ref{neighborhood}).}

\text.block{definition}{prematureConvergence}{An optimization process has prematurely converged if it has not yet discovered the global optimum but can no longer improve its approximation quality.&nbsp;[@WCT2012EOPABT; @WZCN2009WIOD]}

Due to the black-box nature of our basic hill climber algorithm, it is not really possible to know when the complete neighborhood of the current solution has already been tested.
We thus cannot know whether or not the algorithm is trapped in a local optimum and has *prematurely converged*.
However, we can try to guess it:
If there has not been any improvement for a high number&nbsp;$L$ of steps, then the current point&nbsp;$\sespel$ in the search space is probably a local optimum.
If that happens, we just restart at a new random point in the search space.
Of course, we will remember the *best-so-far* candidate solution in a special variable&nbsp;$\bestSoFar{\solspel}$ over all restarts and return it to the user in the end.

#### The Algorithm {#sec:hillClimberWithRestartAlgo}

1. Set counter&nbsp;$C$ of unsuccessful search steps to&nbsp;$0$.
2. Set the best-so-far objective value&nbsp;$\bestSoFar{\obspel}$&nbsp;to&nbsp;$+\infty$ and the best-so-far candidate solution&nbsp;$\bestSoFar{\solspel}$ to&nbsp;`NULL`. 
3. Create a random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using the nullary search operator.
4. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
5. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
6. If&nbsp;$\obspel<\bestSoFar{\obspel}$, then store&nbsp;$\obspel$&nbsp;in&nbsp;$\bestSoFar{\obspel}$ and store&nbsp;$\solspel$&nbsp;in&nbsp;$\bestSoFar{\solspel}$.
7. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\sespel$ to get the slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\obspel$, then
        i. store&nbsp;$\obspel'$&nbsp;in&nbsp;$\obspel$ and store&nbsp;$\sespel'$&nbsp;in&nbsp;$\sespel$ and
        ii. set&nbsp;$C$ to&nbsp;$0$.
        iii. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\obspel'$&nbsp;in&nbsp;$\bestSoFar{\obspel}$ and store&nbsp;$\solspel'$&nbsp;in&nbsp;$\bestSoFar{\solspel}$.
        
       otherwise to *step&nbsp;7d*, i.e., if&nbsp;$\obspel'\geq \obspel$, then
      
        iv. increment&nbsp;$C$ by&nbsp;$1$.
        v. If&nbsp;$C\geq L$, then perform a restart by going back to *step&nbsp;3*.
8. Return best encountered objective value&nbsp;$\bestSoFar{\obspel}$ and the best encountered solution&nbsp;$\bestSoFar{\solspel}$ to the user.

\repo.listing{lst:HillClimberWithRestarts}{An excerpt of the implementation of the Hill Climbing algorithm with restarts, which remembers the best-so-far solution and tries to find better solutions in its neighborhood but restarts if it seems to be trapped in a local optimum.}{java}{src/main/java/aitoa/algorithms/HillClimberWithRestarts.java}{}{relevant}

Now this algorithm &ndash; implemented in [@lst:HillClimberWithRestarts] &ndash; is a bit more elaborate.
Basically, we embed the original hill climber into a loop.
This inner hill climber will stop after a certain number&nbsp;$L$ of unsuccessful search steps, which then leads to a new round in the outer loop.
In combination with the `1swap`&nbsp;operator, we refer to this algorithm as `hcr_L_1swap`, where `L`&nbsp;is to be replaced with the actual value of the parameter&nbsp;$L$.

#### The Right Setup {#sec:hillClimberWithRestartSetup}

We now realize that we do not know which value of&nbsp;$L$ is good.
If we pick it too low, then the algorithm will restart before it actually converges to a local optimum, i.e., stop while it could still improve.
If we pick it too high, we waste runtime and do fewer restarts than what we could do.

If we do not know which value for a parameter is reasonable, we can always do an experiment to investigate.
Since the order of magnitude of the proper value for&nbsp;$L$ is not yet clear, it makes sense to test exponentially increasing numbers.
Here, we test the powers of two from $2^7=128$ to $2^{18}=262'144$.
For each value, we plot the scaled median result quality over the 101&nbsp;runs in [@fig:jssp_hcr_1swap_med_over_l].
In this diagram, the horizontal axis is logarithmically scaled.

From the plot, we can confirm our expectations:
Small numbers of&nbsp;$L$ perform bad and high numbers of&nbsp;$L$ cannot really improve above the basic hill climber.
Actually, if we would set&nbsp;$L$ to a number larger than the overall budget, then we would obtain exactly the original hill climber, as it would never perform any restart.
For different problem instances, different values of&nbsp;$L$ perform good, but&nbsp;$L\approx2^{14}=16'384$ seems to be a reasonable choice for three of the four instances.

![The median result quality of the&nbsp;`hcr_1swap` algorithm, divided by the lower bound $\lowerBound(\objf)^{\star}$ from [@tbl:jsspLowerBoundsTable] over different values of the restart limit parameter&nbsp;$L$. The best values of&nbsp;$L$ on each instance are marked with bold symbols.](\relative.path{jssp_hcr_1swap_med_over_l.svgz}){#fig:jssp_hcr_1swap_med_over_l width=84%}

#### Results on the JSSP

The performance indicators of three settings of our hill climber with restarts in comparison with the plain hill climber are listed in [@tbl:jssp_hcr_1swap_results].
We know that $L=2^{14}$ seems a reasonable setting.
Additionally, we also list the adjacent setups, i.e., give the results for $L\in\{2^{13},2^{14},2^{15}\}$.

\relative.input{jssp_hcr_1swap_results.md}

: The results of the hill climber `hcr_L_1swap` with restarts for values of&nbsp;$L$ from $2 {13}$, $2^{14}$, and $2^{15}$. `hcr_L_1swap` restarts after $L$&nbsp;unsuccessful search moves. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_hcr_1swap_results}

[@tbl:jssp_hcr_1swap_results] shows us that the restarted algorithms `hcr_L_1swap` almost always provide better best, mean, and median solutions than `hc_1swap`.
Only the overall best result of `hcr_8192_1swap` on `abz7` is worse than for `hc_1swap` &ndash; on all other instances and for all other quality metrics, `hc_1swap` loses.

The standard deviations of the end results of the variants with restarts are also always smaller, meaning that these algorithms perform more reliably.
Their median time until they converge is now higher, which means that we make better use of our computational budget.

As a side note, the median and mean result of the three listed setups of our very basic `hcr_L_1swap` algorithms for instance `la24` are already better than the best result&nbsp;(982) delivered by the Grey Wolf Optimization algorithm proposed in&nbsp;[@JZ2018AOGWOFSCPJSAFJSSC].
In other words, even with such a simple algorithm we can already achieve results not very far from recent publications&hellip; 

![The Gantt charts of the median solutions obtained by the `hcr_16384_1swap` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_hcr_16384_1swap_med.svgz}){#fig:jssp_gantt_hcr_16384_1swap_med width=84%}

![The median of the progress of the algorithms `rs`, `hc_1swap`, and `hcr_16384_1swap` over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_hcr_1swap_log.svgz}){#fig:jssp_progress_hcr_1swap_log width=84%}

The median solutions discovered by `hcr_16384_1swap`, illustrated in [@fig:jssp_gantt_hcr_16384_1swap_med], again show less wasted time.
The scheduled jobs again move a bit closer together.

From the progress diagrams plotted in [@fig:jssp_progress_hcr_1swap_log], we can see that the algorithm version with restart initially behave very similar to the "original" hill climber.
Its median quality is almost exactly the same during the first 100&nbsp;ms.
This makes sense, because until its first restart, `hcr_16384_1swap` is identical to `hc_1swap`.
However, when `hc_1swap` has converged and stops making improvements, `hcr_16384_1swap` still continues to make progress.

Of course, our way of finding the right value for the restart parameter&nbsp;$L$ was rather crude.
Most likely, the right choice could be determined per instance based on the number&nbsp;$\jsspMachines$ of machines and the number&nbsp;$\jsspJobs$ of jobs.
But even with such a coarse way of algorithm configuration, we managed to get rather good results. 

#### Drawbacks of the Idea of Restarts

With our restart method, we could significantly improve the results of the hill climber.
It directly addressed the problem of premature convergence, but it tried to find a remedy for its symptoms, not for its cause. 

Basically, a restarted algorithm is still the same algorithm &ndash; we just restart it again and again.
If there are many more local optima than global optima, every restart will probably end again in a local optimum.
If there are many more ``bad'' local optima than ``good'' local optima, every restart will probably end in a ``bad'' local optimum.
While restarts improve the chance to find better solutions, they cannot solve the intrinsic shortcomings of an algorithm.

Another problem is: With every restart we throw away all accumulated knowledge and information of the current run.
Restarts are therefore also somewhat wasteful.

### Hill Climbing with a Different Unary Operator {#sec:hillClimbingWithDifferentUnaryOperator}

#### Small vs. Large Neighborhoods &ndash; and Uniform vs. Non-Uniform Sampling 

One of issues limiting the performance of our restarted hill climber is the design of the unary operator.
`1swap`&nbsp;will swap two jobs in an encoded solution.
Since the solutions are encoded as integer arrays of length&nbsp;$\jsspMachines*\jsspJobs$, there are&nbsp;$\jsspMachines*\jsspJobs$ possible choices when picking the index of the first job to be swapped.
We swap only with *different* jobs and each job appears&nbsp;$\jsspMachines$ times in the encoding.
This leaves&nbsp;$\jsspMachines*(\jsspJobs-1)$ choices for the second swap index, because we will only use a second index that points to a different job ID.
If we think about the size of the neighborhood spanned by `1swap`, we can also ignore equivalent swaps:
Exchanging the jobs at indexes $(10,5)$ and $(5,10)$, for example, would result in the same outcome.
In total, from any given point in the search space, `1swap` may reach&nbsp;$0.5*(\jsspMachines*\jsspJobs)*[\jsspMachines*(\jsspJobs-1)]=0.5*\jsspMachines^2(\jsspJobs^2-\jsspJobs)$ different other points.
Some of these points might still actually encode the same candidate solutions, i.e., identical schedules.
In other words, the neighborhood spanned by our `1swap`&nbsp;operator equals only a tiny fraction of the big search space (remember [@tbl:jsspSearchSpaceTable]).

This has two implications:
      
1. The chance of premature convergence for a hill climber applying this operator is relatively high, since the neighborhoods are relatively small.
   If the neighborhood spanned by the operator was larger, it would contain more, potentially better solutions.
   Hence, it would take longer for the optimization process to reach a point where no improving move can be discovered anymore.
2. Assume that there is no better solution in the `1swap` neighborhood of the current best point in the search space.
   There might still be a much better, similar solution.
   Finding it could, for instance, require swapping three or four jobs &ndash; but the `hc_1swap` algorithm will never find it, because it can only swap two jobs.
   If the search operator would permit such moves, then even the plain hill climber may discover this better solution.

So let us try to think about how we could define a new unary operator which can access a larger neighborhood.
As we should always do, we first consider the extreme cases.

On the one hand, we have `1swap` which samples from a relatively small neighborhood.
Because the neighborhood is small, the stochastic hill climber will eventually have visited all of the solutions it contains.
If none of them is better than the current best solution, it will not be able to depart from it.

The other extreme could be to use our nullary operator as unary operator:
It would return an entirely random point from the search space&nbsp;$\searchSpace$ and ignore its input.
Then, each point&nbsp;$\sespel\in\searchSpace$ would have the whole&nbsp;$\searchSpace$ as the neighborhood.
Using such a unary operator would turn the hill climber into random sampling (and we do not want that).

From this thought experiment we know that unary operators which indiscriminately sample from very large neighborhoods are probably not very good ideas, as they are "too random."
They also make less use of the causality of the search space, as they make large steps and their produced outputs are very different from their inputs.

Using an operator that creates larger neighborhoods than `1swap`, which are still smaller than&nbsp;$\searchSpace$ would be one idea.
For example, we could always swap three jobs instead of two.
The more jobs we swap in each application, the larger the neighborhood gets.
Then we will be less likely to get trapped in local optima (as there will be fewer local optima).
But we will also make less and less use of the causality property, i.e., the solutions we derive from the current best one will be more and more different from it.
Where should we draw the line?
How many jobs should we swap?

Well, there is one more aspect of the operators that we did not think about yet.
An operator does not just span a neighborhood, but it also defines a *probability distribution* over it.
So far, our `1swap` unary operator samples *uniformly* from the neighborhood of its input.
In other words, all of the $0.5*\jsspMachines^2(\jsspJobs^2-\jsspJobs)$ new points that it could create in one step have exactly the same probability, the same chance to be chosen.

But we do not need to do it like that.
We could construct an operator that often creates outputs very similar to its input (like `1swap`), but also, from time to time, samples points a bit farther away in the search space.
This operator could have a huge neighborhood &ndash; but sample it non-uniformly.

#### Second Unary Search Operator for the JSSP {#sec:jsspUnaryOperator2}

We define the `nswap`&nbsp;operator for the JSSP as follows and implement it in [@lst:JSSPUnaryOperatorNSwap]:

\repo.listing{lst:JSSPUnaryOperatorNSwap}{An excerpt of the `nswap` operator for the JSSP, an implementation of the unary search operation interface [@lst:IUnarySearchOperator]. `nswap` can swap an arbitrary number of jobs in our encoding, while favoring small search steps.}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperatorNSwap.java}{}{relevant}

1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. Pick a random index&nbsp;$i$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
3. Store the job-id at index&nbsp;$i$ in the variable&nbsp;$f$ for holding the very first job, i.e., set&nbsp;$f=\arrayIndex{\sespel'}{i}$.
4. Set the job-id variable&nbsp;$l$ for holding the last-swapped-job to&nbsp;$\arrayIndex{\sespel'}{i}$ as well.
5. Repeat
    a. Decide whether we should continue the loop *after* the current iteration (`TRUE`) or not (`FALSE`) with equal probability and remember this decision in variable&nbsp;$n$.
    b. Pick a random index&nbsp;$j$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
    c. If $l=\arrayIndex{\sespel'}{j}$, go back to point&nbsp;b.
    d. If $f=\arrayIndex{\sespel}{j}$ *and* we will *not* do another iteration ($n=FALSE$), go back to point&nbsp;b.
    e. Store the job-id at index&nbsp;$j$ in the variable&nbsp;$l$.
    f. Copy the job-id at index&nbsp;$j$ to index&nbsp;$i$, i.e., set&nbsp;$\arrayIndex{\sespel'}{i}=\arrayIndex{\sespel'}{j}$.
    g. Set&nbsp;$i=j$.
6. If we should do another iteration ($n=TRUE$), go back to point&nbsp;5.
7. Store the first-swapped job-id&nbsp;$f$ in&nbsp;$\arrayIndex{\sespel'}{i}$.
8. Return the now modified copy&nbsp;$\sespel'$ of&nbsp;$\sespel$.
    
Here, the idea is that we will perform at least one iteration of the loop (*point&nbsp;5*).
If we would do exactly one iteration, then we would pick two indices&nbsp;$i$ and&nbsp;$j$ where different job-ids are stored, as&nbsp;$l$ must be different from&nbsp;$f$ (*point&nbsp;c* and&nbsp;*d*).
We would then swap the jobs at these indices (*points&nbsp;f*, *g*, and&nbsp;*7*).
In the case of exactly one iteration of the main loop, this operator behaves the same as&nbsp;`1swap`.
This takes place with a probability of&nbsp;0.5 (*point&nbsp;a*).

If we do two iterations, i.e., pick `true` the first time we arrive at *point&nbsp;a* and `false` the second time, then we swap three job-ids instead.
Let us say we picked indices&nbsp;$\alpha$ at *point&nbsp;2*, $\beta$ at *point&nbsp;b*, and&nbsp;$\gamma$ when arriving the second time at&nbsp;*b*.
We will store the job-id originally stored at index&nbsp;$\beta$ at index&nbsp;$\alpha$, the job originally stored at index&nbsp;$\gamma$ at index&nbsp;$\beta$, and the job-id from index&nbsp;$\gamma$ to index&nbsp;$\alpha$.
*Condition&nbsp;c* prevents index&nbsp;$\beta$ from referencing the same job-id as index&nbsp;$\alpha$ and index&nbsp;$\gamma$ from referencing the same job-id as what was originally stored at index&nbsp;$\beta$.
*Condition&nbsp;d* only applies in the last iteration and prevents&nbsp;$\gamma$ from referencing the original job-id at&nbsp;$\alpha$.

This three-job swap will take place with probability $0.5*0.5=0.25$.
Similarly, a four-job-swap will happen with half of that probability, and so on.
In other words, we have something like a Bernoulli process, where we decide whether or not to do another iteration by flipping a fair coin, where each choice has probability&nbsp;0.5.
The number of iterations will therefore be geometrically distributed with an expectation of two job swaps.
Of course, we only have&nbsp;$\jsspMachines$ different job-ids in a finite-length array&nbsp;$\sespel'$, so this is only an approximation.
Generally, this operator will most often apply small changes and sometimes bigger steps.
The bigger the search step, the less likely will it be produced.
The operator therefore can make use of the *causality* while &ndash; at least theoretically &ndash; being able to escape from any local optimum.

#### Results on the JSSP

Let us now compare the end results that our hill climbers can achieve using either the `1swap` or the new `nswap`&nbsp;operator after three minutes of runtime on my laptop computer in [@tbl:jssp_hc_nswap_results].

\relative.input{jssp_hc_nswap_results.md}

: The results of the hill climbers `hc_1swap` and `hc_nswap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_hc_nswap_results}

From [@tbl:jssp_hc_nswap_results], we find that `hc_nswap` performs almost always better than `hc_1swap`.
Only on instance `abz7`, `hc_1swap` finds the better best solution.
For all other instances, `hc_nswap` has better best, mean, and median results.
It also converges much later and often performs 7&nbsp;to 15&nbsp;million function evaluations and consumes 14% to&nbsp;25% of the three minute budget before it cannot improve anymore.
Still, the hill climber `hcr_16384_1swap` using the `1swap` operator with restarts tends to outperform `hc_nswap`.  

![Median of the progress of the hill climbers with the `1swap` and `nswap` operators over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_hc_nswap_log.svgz}){#fig:jssp_progress_hc_nswap_log width=84%}

[@fig:jssp_progress_hc_nswap_log] illustrates the progress of the hill climbers with the `1swap` and `nswap` operators.
Initially, both algorithms behave very similar in median.
This may be because half of the time, `hc_nswap` also performs single-swap moves.
However, while `hc_1swap` stops improving even before one second has elapsed, `hc_nswap` can still improve after ten seconds.
Still, these late improvements tend to be small and occur infrequently.
It may be that the algorithm arrives in local optima from which it can only escape with complicated multi-swap moves, which are harder to discover by chance.

### Combining Bigger Neighborhood with Restarts

Both restarts and the idea of allowing bigger search steps with small probability are intended to decrease the chance of premature convergence, while the latter one also can investigate more solutions similar to the current best one.
We have seen that both measures work separately.
The fact that `hc_nswap` improves more and more slowly towards the end of the computational budget means that it could be interesting to try to combine both ideas, restarts and larger neighborhoods.

We plug the `nswap` operator into the hill climber with restarts and obtain algorithm `hcr_L_nswap`.
We perform the same experiment to find the right setting for the restart limit&nbsp;$L$ as for the `hcr_L_1swap` algorithm and illustrate the results in [@fig:jssp_hcr_nswap_med_over_l].

![The median result quality of the&nbsp;`hcr_nswap` algorithm, divided by the lower bound $\lowerBound(\objf)^{\star}$ from [@tbl:jsspLowerBoundsTable] over different values of the restart limit parameter&nbsp;$L$. The best values of&nbsp;$L$ on each instance are marked with bold symbols.](\relative.path{jssp_hcr_nswap_med_over_l.svgz}){#fig:jssp_hcr_nswap_med_over_l width=84%}

The "sweet spot" for the number of unsuccessful FEs before a restart has increased compared to before.
This makes sense, because we already know that `nswap` can keep improving longer.

#### Results on the JSSP

\relative.input{jssp_hcr_nswap_results.md}

: The results of the hill climber `hcr_L_nswap` with restarts. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_hcr_nswap_results}

From [@tbl:jssp_hcr_nswap_results], where we print the results of `hcr_32768_nswap` and `hcr_65536_nswap`, we can find that the algorithm version with restarts performs better in average than the one without.
However, it does not always find the best solution, as can be seen on instance `swv15`, where `hc_nswap` finds a schedule of length&nbsp;3602.
The differences between `hcr_16384_1swap` and `hcr_L_nswap`, however, are quite small.
If we compare the progress over time of `hcr_16384_1swap` and `hcr_65536_nswap`, then the latter seems to have a slight edge over the former &ndash; but only by about half of a percent.
This small difference is almost indistinguishable in the progress diagram [@fig:jssp_progress_hcr_nswap_log].

![Median of the progress of the hill climbers with restarts with the `1swap` and `nswap` operators over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_hcr_nswap_log.svgz}){#fig:jssp_progress_hcr_nswap_log width=84%}

#### Testing for Significance {#sec:hcTestForSignificance}

Still, even small improvements can have a big economical impact.
Saving 0.5% of 10'000'000&nbsp;RMB is still 50'000&nbsp;RMB.
The problem is knowing whether such small improvements are true improvements *or* artifacts of the randomness in the algorithm.

In order to understand the latter situation, consider the following thought experiment.
Assume you have a completely unbiased, uniform source of true random real numbers from the interval&nbsp;$[0,1)$.
You draw 500&nbsp;such numbers, i.e., have a list&nbsp;$A$ containing 500&nbsp;numbers, each from&nbsp;$[0,1)$.
Now you repeat the experiment and get another such list&nbsp;$B$.
Since the numbers stem from a random source, we can expect that&nbsp;$A\neq B$.
If we compute the medians&nbsp;$A$ and&nbsp;$B$, they are likely to be different as well.
Actually, I just did exactly this in the `R`&nbsp;programming language and got `median(A)=0.5101432` and `median(B)=0.5329007`.
Does this mean that the generator producing the numbers in&nbsp;$A$ creates somehow smaller numbers than the generator from which the numbers in&nbsp;$B$ stem?
Obviously not, because we sampled the numbers from the same source.
Also, every time I would repeat this experiment, I would get different results.

So how do we know whether or not the sources of&nbsp;$A$ and&nbsp;$B$ are truly different?
Well, we cannot really know for sure.
But we can we can make a statement which is wrong with at most a given probability.
This is called statistical testing, and we discuss it in detail in [@sec:testForSignificance].
Thus, in order to see whether the observed small performance difference of the `hcr` setups is indeed "real" or just random jitter, we compare their sets of 101&nbsp;end results on each of the problem instances.
For this purpose, we use the Mann-Whitney U test, as prescribed in [@sec:nonParametricTests].

\relative.input{jssp_hcr_comparison.md}

: The end results of `hcr_16384_1swap` and `hcr_65536_nswap` compared with a Mann-Whitney U test with Bonferroni correction and significance level&nbsp;$\alpha=0.02$ on the four JSSP instances. The columns indicate the $p$-values and the verdict (`?` for insignificant). {#tbl:jssp_hcr_comparison}

From [@tbl:jssp_hcr_comparison] we know that if we would claim "`hcr_16384_1swap` tends to produce results with large makspan than `hcr_65536_nswap` on `abz7`," then, from our experimental data, we can estimate our chance to be wrong to be about 30%.
In other words, making that claim would be quite a gamble and we can conclude that here, the differences we observed in the experiment are not statistically significant (marked with `?` in the table).
However, if we would claim the same for `swv15`, our chance to be wrong is about $1\!\cdot\!10^{-10}$, i.e., very small.
So on `swv15`, we find that `hcr_65536_nswap` very likely performs better.

In summary, [@tbl:jssp_hcr_comparison] tells us that it seems that the hill climber with restarts using the `nswap` operator can outperform the one using the `1swap` operator on `swv15` and `yn4`.
For `abz7`, there certainly is no significant difference.
The $p$-value of $3.57\!\cdot\!10^{-3}$ on `la24` is fairly small but still above the Bonferroni-corrected $\alpha'=7.14\!\cdot\!10^{-4}$, so we cannot make any statement here.

We found that the `nswap` operator tends to be better then the `1swap` operator when plugged into the hill climber.
We found that restarts are also beneficial to improve the performance of our hill climber.
While we did not find that combining these two methods will yield a convincing improvement, we can at least conclude that preferring `hcr_65536_nswap` over `hcr_16384_1swap` seems reasonable.
It *might* sometimes give better performance while it is unlikely to perform worse.

### Summary

In this section, we have learned about our first "reasonable" optimization method.
The stochastic hill climbing algorithm always remembers the best-so-far point in the search space.
In each step, it applies the unary operator to obtain a similar but slightly different point.
If it is better, then it becomes the new best-so-far point.
Otherwise, it is forgotten.

The performance of hill climbing depends very much on the unary search operator.
If the operator samples from a very small neighborhood only, like our `1swap` operator does, then the hill climber might quickly get trapped in a local optimum.
A local optimum here is a point in the search space which is surrounded by a neighborhood that does not contain any better solution.
If this is the case, the two conditions for doing efficient restarts may be fulfilled: quick convergence and variance of result quality.

The question when to restart then arises, as we usually cannot find out if we are actually trapped in a local optimum or whether the improving move (application of the unary operator) just has not been discovered yet. 
The most primitive solution is to simply set a limit&nbsp;$L$ for the maximum number of moves without improvement that are permitted.

Our `hcr_L_1swap` was born.
We configured&nbsp;$L$ in a small experiment and found that $L=16384$ seemed to be reasonable.
The setup `hcr_16384_1swap` performed much better than `hc_1swap`.
It should be noted that our experiment used for configuration was not very thorough, but it should suffice at this stage.
We can also note that it showed that different settings of $L$ are better for different instances.
This is probably related to the corresponding search space size &ndash; but we will not investigate this any further here.

A second idea to improve the hill climber was to use a unary operator spanning a larger neighborhood, but which still most often sampled solutions similar to current one.
The `nswap` operator gave better results than than the `1swap` operator in the basic hill climber.
The take-away message is that different search operators may (well, obviously) deliver different performance and thus, testing some different operators can always be a good idea.

Finally, we tried to combine our two improvements, restarts and better operator, into the `hcr_L_nswap` algorithm.
Here we learned the lesson that performance improvements do not necessarily add up.
If we have a method that can deliver an improvement of 10% of solution quality and combine it with another one delivering 15%, we may not get an overall 25% improvement.
Indeed, our `hcr_65536_nswap` algorithm only performed a little bit better than `hcr_16384_1swap`.

From this chapter, we also learned one more lesson:
Many optimization algorithms have parameters.
Our hill climber had two: the unary operator and the restart limit&nbsp;$L$.
Configuring these parameters well can lead to significant improvements.
