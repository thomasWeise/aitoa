## Hill Climbing

Our first algorithm, random sampling, was not very efficient.
It does not make any use of the information it "sees" during the optimization process.
A search step consists of creating an entirel new, entirely random candidate solution.
Every search step is thus independent of all prior steps.

[Local search algorithms](http://en.wikipedia.org/wiki/Local_search_(optimization))&nbsp;[@HS2005SLSFAA; @WGOEB] offer an alternative.
They remember the current best point&nbsp;$\bestSoFar{\sespel}$ in the search space&nbsp;$\searchSpace$.
In every step, a local search algorithm investigates a point&nbsp;$\sespel$ similar to&nbsp;$\bestSoFar{\sespel}$.
If it is better, it is accepted as the new best-so-far solution.
Otherwise, it is discarted.

\text.block{definition}{causality}{Causality means that small changes in the features of an object (or candidate solution) also lead to small changes in its behavior (or objective value).}

Local search exploits a property of many optimization problems called *causality*&nbsp;[@R1973ES; @R1994ES; @WCT2012EOPABT; @WZCN2009WIOD].
The idea is that if we have a good candidate solution, then there may exist similar solutions which are better.
We hope to find one of them and then continue trying to do the same from there.

### Ingredient: Unary Search Operation for the JSSP

So the question arises how we can create a candidate solution which is similar to &nbsp; but also slightly different from one &nbsp; we already have?
Our search algorithms are working in the search space&nbsp;$\searchSpace$.
So we need one operation which accepts an existing point&nbsp;$\sespel\in\searchSpace$ and produces a slightly modified copy of it as result.
In other words, we need to implement a unary search operator!

On a JSSP with $\jsspMachines$&nbsp;machines and $\jsspJobs$&nbsp;jobs, our representation&nbsp;$\searchSpace$ encodes a schedule as an integer arry of length&nbsp;$\jsspMachines*\jsspJobs$ containing each of the job IDs (from $0\dots(\jsspJobs-1)$) exactly&nbsp;$\jsspMachines$ times.
The sequence in which these job IDs occur then defines the order in which the jobs are assigned to the machines, which is realized by the representation mapping&nbsp;$\repMap$ (see [@lst:JSSPRepresentationMapping]).

One idea to create a slightly modified copy of such a point&nbsp;$\sespel$ in the search space would be to simply swap two of the jobs in it.
Such a&nbsp;`1swap` operator can be implemented as follows:

1. Make a copy&nbsp;$\sespel'$ of&nbsp;$\sespel$
2. Pick a random index&nbsp;$i$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
3. Pick a random index&nbsp;$j$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
4. If the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$ are the same, then go back to point&nbsp;3. (Swapping the same values makes no sense, since then the value of&nbsp;$\sespel'$ and&nbsp;$\sespel$ would be the same at the end, so also their mappings&nbsp;$\repMap(\sespel)$ and&nbsp;$\repMap(\sespel')$ would be the same, i.e., we would actually not make a "move".)
5. Swap the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$.

We implement this operator in [@lst:JSSPUnaryOperator1Swap].
Notice that the operator is randomized, i.e., appling it twice to the same point in the search space will likely yield different results.

\repo.listing{lst:JSSPUnaryOperator1Swap}{An excerpt of the `1swap` operator for the JSSP, an implementation of the unary search operation interface [@lst:IUnarySearchOperator]. `1swap` swaps two jobs in our encoding of Gantt diagrams.}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1Swap.java}{}{relevant}

In [@fig:jssp_unary_1swap_demo], we illustrate the application of this operator to one point&nbsp;$\sespel$ in the search space for our&nbsp;`demo` JSSP instance.
It swaps the two jobs at index&nbsp;$i=10$ and&nbsp;$j=15$ of&nbsp;$\sespel$.
In the new, modified copy&nbsp;$\sespel'$, the jobs&nbsp;$3$ and&nbsp;$0$ at these indices have thus traded places.
The impact of this modification becomes visible when we map both&nbsp;$\sespel$ and&nbsp;$\sespel'$ to the solution space using the representation mapping&nbsp;$\repMap$.
The&nbsp;$3$ which has been moved forward now means that job&nbsp;$3$ will be scheduled before job&nbsp;$1$ on machine&nbsp;$2$.
As a result, the last two sub-jobs of job&nbsp;$3$ can now finish earlier on machines&nbsp;$0$ and&nbsp;$1$, respectively.
However, time is wasted on machine&nbsp;$2$, as we first need to wait for the first two sub-jobs of job&nbsp;$3$ to finish before we can execute it there.
Also, job&nbsp;$1$ finishes now later on that machine, which also delays its last sub-job to be executed on machine&nbsp;$4$.
This pushes back the last sub-job of job&nbsp;$0$ (on machine&nbsp;$4$) as well.
The new candidate solution&nbsp;$\repMap(\sespel')$ thus has a longer makespan of&nbsp;$\objf(\repMap(\sespel'))=195$ compared to the original solution with&nbsp;$\objf(\repMap(\sespel'))=180$.

![An example for the application of `1swap` to an existing point in the search space (top-left) for the `demo` JSSP instance. It yields a slightly modified copy (top-right) with two jobs swapped. If we map these to the solution space (bottom) using the representation mapping&nbsp;$\repMap$, the changes marked with violet frames occur (bottom-right).](\relative.path{jssp_unary_1swap_demo.svgz}){#fig:jssp_unary_1swap_demo width=99%}

In other words, our application of&nbsp;`1swap` in [@fig:jssp_unary_1swap_demo] has led us to a worse solution.
This will happen most of the time.
As soon as we have a good solution, the solutions similar to it tend to be worse.
However, if we would have been at&nbsp;$\sespel'$ instead, an application of `1swap` could well have resulted in&nbsp;$\sespel$.
Often, the chance to find a really good solution by iteratively sampling the neighborhoods of good solutions is higher than trying to randomly guessing them (as `rs` does) &nbsp; even if most of our samples are worse.

### Hill Climbing Algorithm

#### The Algorithm

Hill Climbing&nbsp;[@RN2002AI; @WGOEB] is the simplest implementation of local search.
It proceeds as follows:

1. Create random point&nbsp;$\sespel$ in search space&nbsp;$\searchSpace$ (using the nullary search operator).
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Store&nbsp;$\sespel$ in the variable&nbsp;$\bestSoFar{\sespel}$ and&nbsp;$\obspel$ in&nbsp;$\bestSoFar{\obspel}$.
5. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\bestSoFar{\sespel}$ to get the slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\bestSoFar{\sespel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$.
6. Return best-so-far objective value and best solution to the user.

This algorithm is implemented in [@lst:HillClimber] and will refer to it as&nbsp;`hc`.

\repo.listing{lst:HillClimber}{An excerpt of the implementation of the Hill Climbing algorithm, which remembers the best-so-far solution and tries to find better solutions in its neighborhood.}{java}{src/main/java/aitoa/algorithms/HillClimber.java}{}{relevant}

#### Results on the JSSP

We now apply our&nbsp;`hc` algorithm together with the `1swap` to the JSSP.
We will refer to this setup as `hc_1swap` and present its results with those of&nbsp;`rs` in [@tbl:hillClimbing1SwapJSSP].

|$\instance$|$\lowerBound{\objf}$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hc_1swap`|**717**|**800**|**798**|28|**0**s|16978|
|||`rs`|895|945|948|**12**|77s|8246019|
|`la24`|935|`hc_1swap`|**999**|**1095**|**1086**|56|**0**s|6612|
|||`rs`|1154|1206|1207|**15**|81s|17287329|
|`swv15`|2885|`hc_1swap`|**3837**|**4108**|**4108**|137|**1**s|104598|
|||`rs`|4988|5165|5174|**49**|85s|5525082|
|`yn4`|929|`hc_1swap`|**1109**|**1222**|**1220**|48|**0**s|31789|
|||`rs`|1459|1496|1498|**15**|83s|6549694|

: The results of the hill climber `hc_1swap` in comparison with those of random sampling algorithm&nbsp;`rs`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:hillClimbing1SwapJSSP}

The hill climber outperforms random sampling in almost all aspects.
It produces better mean, median, and best solutions.
Actually, its median and mean solutions are better than the best solutions discovered by&nbsp;`rs`.
Furthermore, it finds its solutions much much faster.
The time consumed until convergence is not more than one seconds and the number of consumed FEs to find the best solutions per run is between 7000 and 105'000, i.e., between one 50^th^ and one 2500^th^ of the number of FEs needed by&nbsp;`rs`.
The Gantt charts of the median solutions illustrated in [@fig:jssp_gantt_hc_1swap_med] are also more compact than those in [@fig:jssp_gantt_rs_med].

![The Gantt charts of the median solutions obtained by the&nbsp;`hc_1swap` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_hc_1swap_med.svgz}){#fig:jssp_gantt_hc_1swap_med width=84%}

![The progress of the&nbsp;`hc_1swap` and&nbsp;`rs` algorithm over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_rs_hc_1swap_log.svgz}){#fig:jssp_progress_rs_hc_1swap_log width=84%}

[@fig:jssp_progress_rs_hc_1swap_log] shows how both&nbsp;`hc_1swap` and&nbsp;`rs` progress over time.
It should be noted that I designed the experiments in such a way that there were 101 different initial solutions and the runs of the hill climber and random sampling started *at the same points*.
On the logarithmically scaled plots, this is almost invisible.
The runs of the two different algorithms separate almost immediately.
We already knew from [@tbl:hillClimbing1SwapJSSP] that&nbsp;`hc_1swap` converges very quickly.
After initial phases with quick progress, it stops making any further progress.
With the exception of instance&nbsp;`la24`, there is much space between the runs of&nbsp;`rs` and&nbsp;`hc_1swap`.
We can also see again that there is more variance in the end results of&nbsp;`hc_1swap` compared to those of&nbsp;`rs`, as they are spread wider in the vertical direction.

### Hill Climbing with Restarts

We now are in the same situation as with the&nbsp;`1rs` algorithm:
There is some variance between the results and most of the "action" takes place in a short time compared to our total computational budget (1s vs. 3min).
Back in [@sec:randomSamplingAlgo] we made use of this situation by simply repeating&nbsp;`1rs` until the computational budget was exhausted, which we called the `rs`&nbsp;algorithm.
Now the situation is a bit different, however.
`1rs`&nbsp;creates exactly one solution and is finished, whereas our hill climber does not actually finish.
It keeps creating modified copies of the current best solution, only that these happen to not be better.
The algorithm has converged into a *local optimum*.

\text.block{definition}{localOptimum}{A *local optimum* is a point&nbsp;$\localOptimum{\sespel}$ in the search space which maps to a better candidate solution than any other points in its neighborhood (see \text.ref{neighborhood}).}

Of course, our hill climber does not really know that it is trapped in a local optimum.
However, we can guess it: If there has not been any improvement for many steps, then the current-best candidate solution is probably a local optimum.
If that happens, we just restart at a new random point in the search space.
Of course, we will remember the **best ever encountered** candidate solution over all restarts and return it to the user in the end.

#### The Algorithm

1. Set counter&nbsp;$C$ of unsuccessful search steps to&nbsp;$0$, initialize limit&nbsp;$L$ for the maximally allowed unsucessfuly search steps.
2. Set the overall-best objective value&nbsp;$\obspel_B$ to infinity and the overall-best candidate solution&nbsp;$\solspel_B$ to `NULL`. 
3. Create random point&nbsp;$\sespel$ in search space&nbsp;$\searchSpace$ (using the nullary search operator).
4. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
5. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
6. Store&nbsp;$\sespel$ in the variable&nbsp;$\bestSoFar{\sespel}$ and&nbsp;$\obspel$ in&nbsp;$\bestSoFar{\obspel}$.
7. If $\bestSoFar{\obspel}<\obspel_B$, then set&nbsp;$\obspel_B$ to&nbsp;$\bestSoFar{\obspel}$ and store&nbsp;$\solspel_B=\repMap{\sespel}$.
8. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\bestSoFar{\sespel}$ to get the slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then
        i. store&nbsp;$\sespel'$ in the variable&nbsp;$\bestSoFar{\sespel}$,
        ii. $\obspel'$ in&nbsp;$\bestSoFar{\obspel}$, and
        iii. set&nbsp;$C$ to&nbsp;$0$.
        iv. If $\obspel'<\obspel_B$, then set&nbsp;$\obspel_B$ to&nbsp;$\obspel'$ and store&nbsp;$\solspel_B=\repMap{\sespel'}$.
        
       otherwise
      
        i. increment&nbsp;$C$ by&nbsp;$1$
        ii. if $C\geq L$ then
            A. Maybe: increase&nbsp;$L$ (see later).
            B. Go back to step&nbsp;3.
9. Return **best ever encountered**  objective value&nbsp;$\obspel_B$ and solution&nbsp;$\solspel_B to the user.

\repo.listing{lst:HillClimberWithRestarts}{An excerpt of the implementation of the Hill Climbing algorithm with restarts, which remembers the best-so-far solution and tries to find better solutions in its neighborhood but restarts if it seems to be trapped in a local optimum.}{java}{src/main/java/aitoa/algorithms/HillClimberWithRestarts.java}{}{relevant}

Now this algorithm &ndash; implemented in [@lst:HillClimberWithRestarts] &ndash; is a bit more elaborate.
Basically, we embedd the original hill climber into a loop.
This hill climber will stop after a certain number of unsuccessful search steps, which then leads to a new round in the outer loop.
