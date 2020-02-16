## Hill Climbing {#sec:hillClimbing}

Our first algorithm, random sampling, was not very efficient.
It does not make any use of the information it "sees" during the optimization process.
Each search step consists of creating an entirely new, entirely random candidate solution.
Each search step is thus independent of all prior steps.

[Local search algorithms](http://en.wikipedia.org/wiki/Local_search_(optimization))&nbsp;[@HS2005SLSFAA; @WGOEB] offer an alternative.
They remember the current best point&nbsp;$\bestSoFar{\sespel}$ in the search space&nbsp;$\searchSpace$.
In every step, a local search algorithm investigates a point&nbsp;$\sespel$ similar to&nbsp;$\bestSoFar{\sespel}$.
If it is better, it is accepted as the new best-so-far solution.
Otherwise, it is discarded.

\text.block{definition}{causality}{Causality means that small changes in the features of an object (or candidate solution) also lead to small changes in its behavior (or objective value).}

Local search exploits a property of many optimization problems called *causality*&nbsp;[@R1973ES; @R1994ES; @WCT2012EOPABT; @WZCN2009WIOD].
The idea is that if we have a good candidate solution, then there may exist similar solutions which are better.
We hope to find one of them and then continue trying to do the same from there.

### Ingredient: Unary Search Operation for the JSSP {#sec:hillClimbingJssp1Swap}

So the question arises how we can create a candidate solution which is similar to, but also slightly different from, one we already have?
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
4. If the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$ are the same, then go back to point&nbsp;3. (Swapping the same values makes no sense, since then the value of&nbsp;$\sespel'$ and&nbsp;$\sespel$ would be the same at the end, so also their mappings&nbsp;$\repMap(\sespel)$ and&nbsp;$\repMap(\sespel')$ would be the same, i.e., we would actually not make a "move".)
5. Swap the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$.
6. Return the now modified copy&nbsp;$\sespel'$ of&nbsp;$\sespel$.

\repo.listing{lst:JSSPUnaryOperator1Swap}{An excerpt of the `1swap` operator for the JSSP, an implementation of the unary search operation interface [@lst:IUnarySearchOperator]. `1swap` swaps two jobs in our encoding of Gantt diagrams.}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1Swap.java}{}{relevant}

We implemented this operator in [@lst:JSSPUnaryOperator1Swap].
Notice that the operator is randomized, i.e., applying it twice to the same point in the search space will likely yield different results.

![An example for the application of `1swap` to an existing point in the search space (top-left) for the `demo` JSSP instance. It yields a slightly modified copy (top-right) with two jobs swapped. If we map these to the solution space (bottom) using the representation mapping&nbsp;$\repMap$, the changes marked with violet frames occur (bottom-right).](\relative.path{jssp_unary_1swap_demo.svgz}){#fig:jssp_unary_1swap_demo width=99%}

In [@fig:jssp_unary_1swap_demo], we illustrate the application of this operator to one point&nbsp;$\sespel$ in the search space for our&nbsp;`demo` JSSP instance.
It swaps the two jobs at index&nbsp;$i=10$ and&nbsp;$j=15$ of&nbsp;$\sespel$.
In the new, modified copy&nbsp;$\sespel'$, the jobs&nbsp;$3$ and&nbsp;$0$ at these indices have thus traded places.
The impact of this modification becomes visible when we map both&nbsp;$\sespel$ and&nbsp;$\sespel'$ to the solution space using the representation mapping&nbsp;$\repMap$.
The&nbsp;$3$ which has been moved forward now means that job&nbsp;$3$ will be scheduled before job&nbsp;$1$ on machine&nbsp;$2$.
As a result, the last two sub-jobs of job&nbsp;$3$ can now finish earlier on machines&nbsp;$0$ and&nbsp;$1$, respectively.
However, time is wasted on machine&nbsp;$2$, as we first need to wait for the first two sub-jobs of job&nbsp;$3$ to finish before we can execute it there.
Also, job&nbsp;$1$ finishes now later on that machine, which also delays its last sub-job to be executed on machine&nbsp;$4$.
This pushes back the last sub-job of job&nbsp;$0$ (on machine&nbsp;$4$) as well.
The new candidate solution&nbsp;$\repMap(\sespel')$ thus has a longer makespan of&nbsp;$\objf(\repMap(\sespel'))=195$ compared to the original solution with&nbsp;$\objf(\repMap(\sespel))=180$.

In other words, our application of&nbsp;`1swap` in [@fig:jssp_unary_1swap_demo] has led us to a worse solution.
This will happen most of the time.
As soon as we have a good solution, the solutions similar to it tend to be worse.
However, if we would have been at&nbsp;$\sespel'$ instead, an application of `1swap` could well have resulted in&nbsp;$\sespel$.
Often, the chance to find a really good solution by iteratively sampling the neighborhoods of good solutions is higher than trying to randomly guessing them (as `rs` does) &nbsp; even if most of our samples are worse.

### Stochastic Hill Climbing Algorithm

#### The Algorithm

[Stochastic](http://en.wikipedia.org/wiki/Stochastic_hill_climbing) Hill Climbing](http://en.wikipedia.org/wiki/Hill_climbing)&nbsp;[@RN2002AI; @S2008TADM; @WGOEB] is the simplest implementation of local search.
It is also sometimes called localized random search&nbsp;[@S2003ITSSAO].
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

This algorithm is implemented in [@lst:HillClimber] and we will refer to it as&nbsp;`hc`.

\repo.listing{lst:HillClimber}{An excerpt of the implementation of the Hill Climbing algorithm, which remembers the best-so-far solution and tries to find better solutions in its neighborhood.}{java}{src/main/java/aitoa/algorithms/HillClimber.java}{}{relevant}

#### Results on the JSSP {#sec:hc_1swap:jssp:results}

We now apply our&nbsp;`hc` algorithm together with the `1swap` to the JSSP.
We will refer to this setup as `hc_1swap` and present its results with those of&nbsp;`rs` in [@tbl:hillClimbing1SwapJSSP].

|$\instance$|$\lowerBound(\objf)$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hc_1swap`|**717**|**800**|**798**|28|**0**s|16'978|
|||`rs`|895|945|948|**12**|77s|8'246'019|
|`la24`|935|`hc_1swap`|**999**|**1095**|**1086**|56|**0**s|6612|
|||`rs`|1154|1206|1207|**15**|81s|17'287'329|
|`swv15`|2885|`hc_1swap`|**3837**|**4108**|**4108**|137|**1**s|104'598|
|||`rs`|4988|5165|5174|**49**|85s|5'525'082|
|`yn4`|929|`hc_1swap`|**1109**|**1222**|**1220**|48|**0**s|31'789|
|||`rs`|1459|1496|1498|**15**|83s|6'549'694|

: The results of the hill climber `hc_1swap` in comparison with those of random sampling algorithm&nbsp;`rs`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:hillClimbing1SwapJSSP}

The hill climber outperforms random sampling in almost all aspects.
It produces better mean, median, and best solutions.
Actually, its median and mean solutions are better than the best solutions discovered by&nbsp;`rs`.
Furthermore, it finds its solutions much much faster.
The time consumed until convergence is not more than one seconds and the number of consumed FEs to find the best solutions per run is between 7000 and 105'000, i.e., between one 50^th^ and one 2500^th^ of the number of FEs needed by&nbsp;`rs`.

It may be interesting to know that this simple `hc_1swap` algorithm can already achieve some remotely acceptable performance.
For instance, on instance `abz7`, it delivers better best and mean results than all four Genetic Algorithms (GAs) presented in&nbsp;[@JPDS2014CAODRIGAFJSSP] and on `la24`, only one of the four (GA&#8209;PR) has a better best result and all lose in terms of mean result.
On this instance, `hc_1swap` finds a better best solution than all six GAs in [@A2010RIGAFTJSPACS] and better mean results than four of them.
In [@sec:evolutionaryAlgorithm], we will later introduce Evolutionary Algorithms, to which GAs belong.

The Gantt charts of the median solutions of `hc_1swap` are illustrated in [@fig:jssp_gantt_hc_1swap_med] are also more compact than those in [@fig:jssp_gantt_rs_med].

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

### Stochastic Hill Climbing with Restarts {#sec:stochasticHillClimbingWithRestarts}

We now are in the same situation as with the&nbsp;`1rs` algorithm:
There is some variance between the results and most of the "action" takes place in a short time compared to our total computational budget (1s vs. 3min).
Back in [@sec:randomSamplingAlgo] we made use of this situation by simply repeating&nbsp;`1rs` until the computational budget was exhausted, which we called the `rs`&nbsp;algorithm.
Now the situation is a bit different, however.
`1rs`&nbsp;creates exactly one solution and is finished, whereas our hill climber does not actually finish.
It keeps creating modified copies of the current best solution, only that these happen to not be better.
The algorithm has converged into a *local optimum*.

\text.block{definition}{localOptimum}{A *local optimum* is a point&nbsp;$\localOptimum{\sespel}$ in the search space which maps to a better candidate solution than any other points in its neighborhood (see \text.ref{neighborhood}).}

\text.block{definition}{prematureConvergence}{An optimization process has prematurely converged if it has not yet discovered the global optimum but can no longer improve its approximation quality.&nbsp;[@WCT2012EOPABT; @WZCN2009WIOD]}

Of course, our hill climber does not really know that it is trapped in a local optimum, that it has *prematurely converged*.
However, we can try to guess it: If there has not been any improvement for many steps, then the current-best candidate solution is probably a local optimum.
If that happens, we just restart at a new random point in the search space.
Of course, we will remember the **best ever encountered** candidate solution over all restarts and return it to the user in the end.

#### The Algorithm {#sec:hillClimberWithRestartAlgo}

1. Set counter&nbsp;$C$ of unsuccessful search steps to&nbsp;$0$, initialize limit&nbsp;$L$ for the maximally allowed unsuccessful search steps.
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
            (1) Maybe: increase&nbsp;$L$ (see later).
            (2) Go back to step&nbsp;3.
9. Return **best ever encountered** objective value&nbsp;$\obspel_B$ and solution&nbsp;$\solspel_B$ to the user.

\repo.listing{lst:HillClimberWithRestarts}{An excerpt of the implementation of the Hill Climbing algorithm with restarts, which remembers the best-so-far solution and tries to find better solutions in its neighborhood but restarts if it seems to be trapped in a local optimum.}{java}{src/main/java/aitoa/algorithms/HillClimberWithRestarts.java}{}{relevant}

Now this algorithm &ndash; implemented in [@lst:HillClimberWithRestarts] &ndash; is a bit more elaborate.
Basically, we embed the original hill climber into a loop.
This hill climber will stop after a certain number of unsuccessful search steps, which then leads to a new round in the outer loop.
The problem that we have is that we do not know which "certain number" is right.
If we pick it too low, then the algorithm will restart before it actually converges to a local optimum.
If we pick it too much, we waste runtime and do fewer restarts than what we could do.
To deal with this dilemma, we can slowly increase the number of allowed unsuccessful search moves.

#### Results on the JSSP

In [@tbl:hillClimbing1SwapRSJSSP] we present the performance indicators of the two versions of our hill climber with restarts in comparison with the plain hill climber.
We implement `hcr_256_1swap`, which begins at a new random point in the search space after&nbsp;$L=256$ applications of the unary operator to the same current-best solution did not yield any improvement.
`hcr_256+5%_1swap` does the same, but increases&nbsp;$L$ by 5% after each restart, i.e., initially waits 256 steps, then $round(1.05*256)=267$ steps, then 280, and so on.
Of course, the actual search procedure of both algorithms is still the same as the one of the plain hill climber `hc_1swap`.
What we can expect is therefore mainly an utilization of the variance in the end results and the time "wasted" after `hc_1swap` has converged.

|$\instance$|$\lowerBound(\objf)$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hc_1swap`|**717**|800|798|28|**0**s|16'978|
|||`hcr_256_1swap`|738|765|766|**7**|82s|22'881'557|
|||`hcr_256+5%_1swap`|723|**742**|**743**|7|21s|5'681'591|
|`la24`|935|`hc_1swap`|999|1095|1086|56|**0**s|6612|
|||`hcr_256_1swap`|975|1001|1002|**6**|91s|49'588'742|
|||`hcr_256+5%_1swap`|**970**|**997**|**998**|9|6s|3'470'368|
|`swv15`|2885|`hc_1swap`|3837|4108|4108|137|**1**s|104'598|
|||`hcr_256_1swap`|4069|4173|4177|**32**|92s|15'351'798|
|||`hcr_256+5%_1swap`|**3701**|**3850**|**3857**|40|60s|9'874'102|
|`yn4`|929|`hc_1swap`|1109|1222|1220|48|**0**s|31'789|
|||`hcr_256_1swap`|1153|1182|1184|**12**|90s|18'843'991|
|||`hcr_256+5%_1swap`|**1095**|**1129**|**1130**|14|22s|4'676'669|

: The results of the hill climber `hc_1swap` with restarts. `hcr_256_1swap` restarts after 256 unsuccessful search moves, `hcr_256+5%_1swap` does the same but increases the allowed number of unsuccessful moves by 5% after each restart. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:hillClimbing1SwapRSJSSP}

[@tbl:hillClimbing1SwapRSJSSP] shows us that the restarted algorithms offer improved median and mean results.
The standard deviation of their end results is also reduced, so they have become more reliable.
Also, their median time until they converge is now higher, which means that we make better use of our computational budget.
The best solution from all 101 runs they discover does not necessarily improve, which makes sense because they are still essentially the same algorithms.
Slowly increasing the time until restart turns out to be a good idea: `hcr_256+5%_1swap` outperforms `hcr_256_1swap` in almost all aspects.

This could also mean that waiting 256 steps until a restart is not enough, of course.
If this was an actual, practical application scenario we should experiment with more settings.
For the sake of demonstrating the basic ideas in this book, however, we will not do that.

The best result of our still quite basic `hcr_256_1swap` and `hcr_256+5%_1swap` for instance `la24` can both surpass the best result (982) delivered by the Gray Wolf Optimization algorithm in&nbsp;[@JZ2018AOGWOFSCPJSAFJSSC]. 

![The Gantt charts of the median solutions obtained by the `hcr_256+5%_1swap` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_hcr_256_5_1swap_med.svgz}){#fig:jssp_gantt_hcr_256_5_1swap_med width=84%}

![The progress of the algorithms `rs`, `hc_1swap`, `hcr_256_1swap`, and `hcr_256+5%_1swap` over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_rs_hc_hcr_1swap_log.svgz}){#fig:jssp_progress_rs_hc_hcr_1swap_log width=84%}

The average solutions discovered by `hcr_256+5%_1swap`, illustrated in [@fig:jssp_gantt_hcr_256_5_1swap_med], again show less wasted time.
The scheduled jobs again move a bit closer together.

From the progress diagrams plotted in [@fig:jssp_gantt_hcr_256_5_1swap_med], we can see that the algorithm versions with restart initially behave exactly the same as the "normal" hill climber.
They should do that, because until they do their first restart, the are identical to `hc_1swap`.
However, when `hc_1swap` has converged and stops making improvements, `hcr_256_1swap` and `hcr_256+5%_1swap` still continue to make progress.
On all problem instances except `la24`, `hcr_256+5%_1swap` provides visible better end results compared to `hcr_256_1swap` as well, confirming the findings from [@tbl:hillClimbing1SwapRSJSSP].

### Hill Climbing with a Different Unary Operator {#sec:hillClimbingWithDifferentUnaryOperator}

With our restart method could significantly improve the results of the hill climber.
It directly addressed the problem of premature convergence, but it tried to find a remedy for its symptoms, not its cause.

One cause for this problem in our hill climber is the design of unary operator.
`1swap` will swap two jobs in an encoded solution.
Since the solutions are encoded as integer arrays of length&nbsp;$\jsspMachines*\jsspJobs$, there are&nbsp;$\jsspMachines*\jsspJobs$ choices to pick the index of the first job to be swapped.
Since we swap only with *different* jobs and each job appears&nbsp;$\jsspMachines$ times in the encoding, this leaves&nbsp;$\jsspMachines*(\jsspJobs-1)$ choices for the second swap index.
We can also ignore equivalent swaps, e.g., exchanging the jobs at indexes $(10,5)$ and $(5,10)$ would result in the same outcome.
In total, from any given point in the search space, `1swap` may reach&nbsp;$0.5*\jsspMachines*\jsspJobs*\jsspMachines*(\jsspJobs-1)=0.5*(\jsspMachines^2 \jsspJobs^2-\jsspJobs)$ different other points (some of which may still actually encode the same candidate solutions).
These are only tiny fractions of the big search space (remember [@tbl:jsspSearchSpaceTable]?).

This has two implications:

1. The chance of premature convergence for a hill climber applying this operator is relatively high, since the neighborhoods are relatively small.
   If the neighborhood spanned by the operator was larger, it would contain more, potentially better solutions.
   Hence, it would take longer for the optimization process to reach a point where no improving move can be discovered anymore.
2. Assume that there is no better solution in the `1swap` neighborhood of the current best point in the search space.
   There might still be a much better, similar solution which could, for instance, require swapping three or four jobs &ndash; but the algorithm will never find it, because it can only swap two jobs.
   If the search operator would permit such moves, the hill climber may discover this better solution.

Now we need to think about how we could define a new unary operator which can access a larger neighborhood.
Here we first should consider the extreme cases.
On the one hand, we have `1swap` which samples from a relatively small neighborhood.
The other extreme could be to use our nullary operator as unary operator: It would return an entirely random point from the search space&nbsp;$\searchSpace$ and ignore its input.
It would span&nbsp;$\searchSpace$ as its neighborhood and uniformly sample from it, effectively turning the hill climber into random sampling.
From this thought experiment we know that unary operators which indiscriminately sample from very large neighborhoods are not very good ideas, as they are "too random."
They also make less use of the causality of the search space, as they make large steps and their produced outputs are very different from their inputs.
What we would like is an operator that often creates outputs very similar to its input (like `1swap`), but also from time to time samples points a bit farther away in the search space.

#### Second Unary Search Operator for the JSSP {#sec:jsspUnaryOperator2}

We define the `nswap` operator for the JSSP as follows and implement it in [@lst:JSSPUnaryOperatorNSwap]:

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
    
The idea of this operator is that we will perform at least one iteration of the loop (*point&nbsp;5*).
If we would do exactly one iteration, then we would pick two indices&nbsp;$i$ and&nbsp;$j$, then we will pick two indices where different job-ids are stored, as&nbsp;$l$ must be different from&nbsp;$f$ (*point&nbsp;c* and&nbsp;*d*).
We would then would swap the jobs at these indices (*points&nbsp;f*, *g*, and&nbsp;*7*).
So in the case of exactly one iteration of the main loop, this operator behaves exactly the same as&nbsp;`1swap`.
This takes place with a probability of&nbsp;0.5 (*point&nbsp;a*).

If we do two iterations, i.e., pick `TRUE` the first time we arrive at *point&nbsp;a* and `FALSE` the second time, then we swap three job ids-instead.
Let us say we picked indices&nbsp;$\alpha$ at *point&nbsp;2*, $\beta$ at *point&nbsp;b*, and&nbsp;$\gamma$ when arriving the second time at&nbsp;*b*.
We will store the job-id originally stored at index&nbsp;$\beta$ at index&nbsp;$\alpha$, the job originally stored at index&nbsp;$\gamma$ at index&nbsp;$\beta$, and the job-id from index&nbsp;$\gamma$ to index&nbsp;$\alpha$.
*Condition&nbsp;c* prevents index&nbsp;$\beta$ from referencing the same job-id as index&nbsp;$\alpha$ and index&nbsp;$\gamma$ from referencing the same job-id as what was originally stored at index&nbsp;$\beta$.
*Condition&nbsp;d* only applies in the last iteration and prevents&nbsp;$\gamma$ from referencing the original job-id at&nbsp;$\alpha$.

This three-job swap will take place with probability $0.5*0.5=0.25$.
Similarly, a four-job-swap will happen with half of that probability, and so on.
In other words, we have something like a [Bernoulli process](http://en.wikipedia.org/wiki/Bernoulli_process), where we decide whether or not to do another iteration by flipping a fair coin, where each choice has probability&nbsp;0.5.
The number of iterations will therefore be [geometrically distributed](http://en.wikipedia.org/wiki/Geometric_distribution) with an expectation of two job swaps.
Of course, we only have&nbsp;$\jsspMachines$ different job-ids in a finite-length array&nbsp;$\sespel'$, so this is only an approximation.
Generally, this operator will most often apply small changes and sometimes bigger steps.
The bigger the search step, the less likely will it be produced.
The operator therefore can make use of the *causality* while &ndash; at least theoreticaly &ndash; being able to escape from any local optimum.

#### Results on the JSSP

Let us now compare the end results that our hill climbers can achieve using either the `1swap` or the new `nswap` operator after three minutes of runtime on my little laptop computer in [@tbl:hillClimbingNSwapRSJSSP].

|$\instance$|$\lowerBound(\objf)$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hc_1swap`|717|800|798|28|**0**s|16978|
|||`hc_nswap`|724|757|757|17|30s|8145596|
|||`hcr_256_1swap`|738|765|766|7|82s|22881557|
|||`hcr_256_nswap`|756|774|774|**6**|101s|27375920|
|||`hcr_256+5%_1swap`|723|742|743|7|21s|5681591|
|||`hcr_256+5%_nswap`|**707**|**733**|**734**|7|64s|17293038|
|`la24`|935|`hc_1swap`|999|1095|1086|56|**0**s|6612|
|||`hc_nswap`|**945**|1017|1015|29|21s|11123744|
|||`hcr_256_1swap`|975|1001|1002|**6**|91s|49588742|
|||`hcr_256_nswap`|986|1008|1008|7|100s|52711888|
|||`hcr_256+5%_1swap`|970|997|998|9|6s|3470368|
|||`hcr_256+5%_nswap`|**945**|**981**|**984**|9|57s|29246097|
|`swv15`|2885|`hc_1swap`|3837|4108|4108|137|**1**s|104598|
|||`hc_nswap`|**3599**|3867|3859|113|70s|11559667|
|||`hcr_256_1swap`|4069|4173|4177|32|92s|15351798|
|||`hcr_256_nswap`|4118|4208|4214|**29**|95s|15746919|
|||`hcr_256+5%_1swap`|3701|3850|3857|40|60s|9874102|
|||`hcr_256+5%_nswap`|3645|**3804**|**3811**|44|91s|14907737|
|`yn4`|929|`hc_1swap`|1109|1222|1220|48|**0**s|31789|
|||`hc_nswap`|1087|1160|1156|33|63s|13111115|
|||`hcr_256_1swap`|1153|1182|1184|12|90s|18843991|
|||`hcr_256_nswap`|1163|1198|1199|**11**|91s|18700214|
|||`hcr_256+5%_1swap`|1095|1129|1130|14|22s|4676669|
|||`hcr_256+5%_nswap`|**1081**|**1117**|**1119**|14|55s|11299461|

: The results of the hill climbers `hc_1swap` and `hc_nswap` with and without restarts. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:hillClimbingNSwapRSJSSP}

When comparing two setups which only differ in the unary operator, we find that in most cases, `nswap` performs better when applied without restarts (`hc_*`) or with restarts after increasing periods of time (`hcr_256+5%_*`).
Indeed, all the best results we have obtained so far stem from `nswap` setups and the setups with best mean and median performance use `nswap` as well.
When being restarted, the standard deviations of their results are similar to those with `1swap`, meaning that these setups are similarly reliable.
Interestingly, for instance `la24`, the makespan of the best discovered solution is now only 1% longer than the lower bound (945 vs. 935).
For instance `swv15`, however, there is still a 20% gap.

As can be seen when comparing the hill climbers without restart, the `nswap` operator needs longer to converge because half of its steps are bigger than those of `1swap`.
It utilizes the causality in the search space a bit less.
This may be the reason why `hcr_256_1swap` tends to be better than `hcr_256_nswap` while `hcr_256+5%_nswap` outperforms `hcr_256+5%_1swap` &nbsp; the restarts happen too early for `nswap`.
The setups with `nswap` tend to converge later, both in terms of runtime med(t) and med(FEs).

[@fig:jssp_progress_hc_1swap_nswap_rs_log] illustrates the progress of the hill climbers with the `1swap` and `nswap` operators.
While there is quite an improvement when comparing the non-restarting algorithms, the difference between `hcr_256+5%_1swap` and `hcr_256+5%_nswap` does not look that big.
From [@tbl:hillClimbingNSwapRSJSSP] we know that the `nswap` operator here can squeeze out around 1% of solution quality.
The Gantt charts of the median solutions obtained with `hcr_256+5%_nswap` setup, illustrated in [@fig:jssp_gantt_hcr_256_5_nswap_med], do thus look similar to those obtained with `hcr_256+5%_1swap` in [@fig:jssp_gantt_hcr_256_5_1swap_med], although there are some slight differences.
Although 1% savings in makespan does not look much, but in a practical application, even a small improvement can mean a lot of benefit.

Both restarts and the idea of allowing bigger search steps with small probability are intended to decrease the chance of premature convergence, while the latter one also can investigate more solutions similar to the current best one.
We have seen that both measures work separately and in this case, we were lucky that they also work hand-in-hand.
This is not necessarily always the case, in optimization sometimes two helpful measures combined may lead to worse results, as we can see when comparing `hcr_256_1swap` with `hcr_256_nswap`.

![The progress of the hill climbers (without and with restarts) with the `1swap` and `nswap` operators over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_hc_1swap_nswap_rs_log.svgz}){#fig:jssp_progress_hc_1swap_nswap_rs_log width=84%}

![The Gantt charts of the median solutions obtained by the&nbsp;`hcr_256+5%_nswap` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_hcr_256_5_nswap_med.svgz}){#fig:jssp_gantt_hcr_256_5_nswap_med width=84%}
