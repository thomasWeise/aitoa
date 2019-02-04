## Random Sampling {#sec:randomSampling}

If we have our optimization problem and its components properly defined according to [@sec:structure], then we have the proper tools to solve the problem.
We know

- how a solution can internally be represented as "point"&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ ([@sec:searchSpace]),
- how we can map such a point&nbsp;$\sespel\in\searchSpace$ to a candidate solution&nbsp;$\solspel$ in the solution space&nbsp;$\solutionSpace$ ([@sec:solutionSpace]) via the representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ ([@sec:searchSpace]), and
- how to rate a candidate solution&nbsp;$\solspel\in\solutionSpace$ with the objective function&nbsp;$\objf$ ([@sec:objectiveFunction]).

Basically, all what we need now is to somehow "create" a point&nbsp;$\sespel$ in the search space.
We can then apply&nbsp;$\repMap(\sespel)$ and get a candidate solution&nbsp;$\solspel$ whose quality we can assess via&nbsp;$\objf(\solspel)$.
If we look at the problem as a black box ([@sec:blackbox]), i.e., don't really know what "makes a candidate solution good," then the best we can do is just create the solutions randomly.

### Ingredient: Nullary Search Operation for the JSSP

For this purpose, we need to implement the nullary search operation from [@lst:INullarySearchOperator].
We create a new search operator which needs no input and returns a point in the search space.
Recall that our representation ([@sec:jsspSearchSpace]) requires that each index&nbsp;$\jsspJobIndex\in 0\dots(\jsspJobs-1)$ of the&nbsp;$\jsspJobs$ must occur exactly&nbsp;$\jsspMachines$ times in the integer array of length&nbsp;$\jsspMachines*\jsspJobs$, where&nbsp;$\jsspMachines$ is the number of machines in the JSSP instance.
In [@lst:JSSPNullaryOperator], we achieve this by first creating the sequence&nbsp;$(\jsspJobs-1,\jsspJobs-2,\dots,0)$ and then copy it&nbsp;$\jsspMachines$ times in the destination array `dest`.
We then randomly shuffle `dest` by applying the [Fisher–Yates shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle) algorithm [@FY1948STFBAAMR; @K1969SA], which simply brings the array into an entirely random order.

\repo.listing{lst:JSSPNullaryOperator}{An excerpt of the implementation of the nullary search operation interface [@lst:INullarySearchOperator] for the JSSP, which will create one random point in the search space.}{java}{src/main/java/aitoa/examples/jssp/JSSPNullaryOperator.java}{}{relevant}

By calling the `apply` method of our implemented operator, it will create one random point in the search space.
We can then pass this point through the representation mapping that we already implemented in [@lst:JSSPRepresentationMapping] and have a Gantt diagram.
Easily we then obtain the quality, i.e., makespan, of this candidate solution as the right-most edge of any an job assignment in the diagram, as defined in [@sec:jsspObjectiveFunction].

### Single Random Sample

#### The Algorithm

Now that we have all ingredients ready, we can test the idea.
In [@lst:SingleRandomSample], we implement this algorithm `1rs` which creates exactly one random point&nbsp;$\sespel$ in the search space.
It then takes this point and passes it to the evaluation function of our black-box `process`, which will perform the representation mapping&nbsp; $\solspel=\repMap(\sespel)$ and compute the objective value&nbsp;$\objf(\solspel)$.
It makes sense to implement this function in such a way that it automatically remembers the best candidate solution it encountered.
Then, we do not need to take care of this in our algorithm, which makes the implementation so short.

\repo.listing{lst:SingleRandomSample}{An excerpt of the implementation of an algorithm which creates a single random candidate solution.}{java}{src/main/java/aitoa/algorithms/SingleRandomSample.java}{}{relevant}

#### Results on the JSSP

Of course, since the algorithm is *randomized*, it may give us a different result every time we run it.
In order to understand what kind of solution qualities we can expect, we hence have to run it a couple of times and compute result statistics.
We therefore execute our program 101&nbsp;times and the results are summarized in [@tbl:singleRandomSampleJSSP].

|$\instance$|$\lowerBound{\objf}$|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|--:|--:|--:|--:|--:|--:
|`abz7`|656|1131|1334|1326|106|0s|1|
|`la24`|935|1487|1842|1814|165|0s|1|
|`swv15`|2885|5935|6600|6563|346|0s|1|
|`yn4`|929|1754|2036|2039|125|0s|1|

: The results of the single random sample algorithm&nbsp;`1rs` for each instance $\instance$ in comparison to the lower bound&nbsp;$\lowerBound{\objf}$ of the makespan&nbsp;$\objf$ over 101&nbsp;runs: the *best*, *mean*, and median (*med*) result quality, the standard deviation *sd* of the result quality, as well as the median time&nbsp;*med(t)* and FEs&nbsp;*med(FEs)* until a run was finished. {#tbl:singleRandomSampleJSSP}

![The Gantt charts of the median solutions obtained by the&nbsp;`1rs` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_1rs_med.svgz}){#fig:jssp_gantt_1rs_med width=90%}

What we can find in [@tbl:singleRandomSampleJSSP] is that the makespan of best solution that any of the 101&nbsp;runs has delivered for each of the four JSSP instances is between 60% and 100% longer than the lower bound.
The [arithmetic mean](http://en.wikipedia.org/wiki/Arithmetic_mean) and [median](http://en.wikipedia.org/wiki/Median) of the solution qualities are even between 10% and 20% worse.
In the Gantt charts of the median solutions depicted in [@fig:jssp_gantt_1rs_med], we can find big gaps between the sub-jobs.
This all is expected.
After all, we just create a single random solution.
We can hardly assume that doing all jobs of a JSSP in a random order would even be good idea.

But we also notice more.
The time&nbsp;*t(med)* that the top-50% of the runs need to get their result is approximately&nbsp;0s.
The reason is that we only perform one single objective function evaluation per run, i.e., 1&nbsp;FE.
Creating, mapping, and evaluating a solution can be very fast, actually within a few milliseconds.
However, we had originally planned to use up to three minutes for optimization.
Hence, almost all of our time budget remains unused.
At the same time, we already know that that there is a 10-20% difference between the best and the median solution quality among the 101&nbsp;random solutions we created.
The standard deviation&nbsp;$sd$ of the solution quality also is always above 100&nbsp;time units of makespan.
So why don't we try to make use of this variance and the high speed of solution creation?

### Random Sampling Algorithm

#### The Algorithm

The actual random sampling algorithm repeats creating random solutions until the computational budget is exhausted.
In our corresponding Java implementation given in [@lst:RandomSampling], we therefore only needed to add a loop around the code from the single random sampling algorithm from [@lst:SingleRandomSample].

\repo.listing{lst:RandomSampling}{An excerpt of the implementation of the random sampling algorithm which keeps createing random candidate solutions and remembering the best encountered on until the computational budget is exhausted.}{java}{src/main/java/aitoa/algorithms/RandomSampling.java}{}{relevant}

The algorithm can be described as follows:

1. set best-so-far objective value to infinity
2. create random point&nbsp;$\sespel$ in search space&nbsp;$\searchSpace$
3. map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
4. compute objective value by invoking the objective function&nbsp;$z=\objf(\solspel)$.
5. if&nbsp;$z$ is better than best-so-far-objective value, then
    a. set best-so-far objective value to&nbsp;$z$
    b. store&nbsp;$\solspel$ in a special variable and remember it
6. if termination criterion is not met, return to point 1.
7. return best-so-far objective value and best solution to the user

In actual program code, points&nbsp;3 to&nbsp;5 can actually be encapsulate by a wrapper around the objective function.
This reduces a lot of potential programming mistakes and makes the code much shorter.
This is what we did with the implementations of the black-box process interface `IBlackBoxProcess` given in [@lst:IBlackBoxProcess].

#### Results on the JSSP

Let us now compare the performance of this iterated random sampling with our initial method.
[@tbl:randomSamplingJSSP] shows us that the iterated random sampling algorithm is better in virtually all relevant aspects than the single random sampling method.
Its best, mean, and median result quality are siginificantly better.
Since creating random points in the search space is so fast that we can sample many more than 101&nbsp;candidate solutions, even the median and mean result quality of the&nbsp;`rs` algorithm are better than the best quality obtainable with&nbsp;`1rs`.
Matter of fact, each run of our&nbsp;`rs` algorithm can create and test several million candidate solutions within the three minute time window, i.e., perform several million FEs.
Furthermore, the standard deviation of the results becomes lower as well.
This means that this algorithm has a more reliable performance, we are more likely to get results close to the mean or median performance when we use&nbs;`rs` compared to&nbsp;`1rs`.

|$\instance$|$\lowerBound{\objf}$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:-:|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`1rs`|1131|1334|1326|106|**0**s|**1**|
|||`rs`|**895**|**945**|**948**|**12**|77s|8246019|
|`la24`|935|`1rs`|1487|1842|1814|165|**0**s|**1**|
|||`rs`|**1154**|**1206**|**1207**|**15**|81s|17287329|
|`swv15`|2885|`1rs`|5935|6600|6563|346|**0**s|**1**|
|||`rs`|**4988**|**5165**|**5174**|**49**|85s|5525082|
|`yn4`|929|`1rs`|1754|2036|2039|125|**0**s|**1**|
|||`rs`|**1459**|**1496**|**1498**|**15**|83s|6549694|

: The results of the single random sample algorithm&nbsp;`1rs` and the random sampling algorithm&nbsp;`rs`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation *sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:randomSamplingJSSP}

In [@fig:jssp_gantt_rs_med], we now again plot the solutions of median quality, i.e., those which are "in the middle" of the results, quality-wise.
The improved performance becomes visible when comparing [@fig:jssp_gantt_rs_med] with [@fig:jssp_gantt_1rs_med].
The spacing between the jobs on the machines has significantly reduced.
Still, the schedules clearly have a lot of unused time, visible as white space between the sub-jobs on the machines.
We are also still relatively far away from the lower bounds of the objective function, so there is lots of room for improvement.

![The Gantt charts of the median solutions obtained by the&nbsp;`rs` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_rs_med.svgz}){#fig:jssp_gantt_rs_med width=90%}

#### Progress over Time and the Law of Diminishing Returns

![The progress of the&nbsp;`rs` algorithm over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_rs_log.svgz}){#fig:jssp_progress_rs_log width=90%}

Another new feature of our&nbsp;`rs` algorithm is that it is truly an Anytime Algorithm ([@sec:anytimeAlgorithm]).
It begins with an entirely random solution and tries to find better solutions as time goes by.
Let us take a look at [@fig:jssp_progress_rs_log], which illustrates how the solution quality of the runs improves over time.
At first glance, this figure looks quite nice.
For each of the four problem instances we investigate, our algorithms steadily and nicely improve the solution quality.
Each single line (one per run) keeps slowly going down, which means that the makespan (objective value) of its best-so-far solution decreases steadily.

However, upon closer inspection, we notice that the time axes in the plots are logarithmically scaled.
The first of the equally-spaces axis tick marks is at 1s, the second one at 10s, the third one at 100s, and so on.
The progress curves plotted over these logarithmically scaled axes seem to progress more or less like straight linear lines, maybe even slower.
A linear progress over a logarithmic time scale could mean, for instance, that we may make the same improvements in the time intervals $1s\dots 9s$, $10s\dots 99s$, $100s\dots 999s$, and so on.
In other words: We are getting slower and slower.

This is the first time we witness a manifestation of a very basic law in optimization.
When trying to solve a problem, we need to invest resources, be it software development effort, research effort, computational budget, or expenditure for hardware, etc.
If you invest a certain amount&nbsp;$a$ of one of these resources, you may be lucky to improve the solution quality that you can get by, say, $b$&nbsp;units.
Investing&nbsp;$2a$ of the resources, however, will rarely lead to an improvement by $2b$&nbsp;units.
Instead, the improvements will become smaller and smaller the more you invest.
This is exactly the *[Law of Diminishing Returns](http://en.wikipedia.org/wiki/Diminishing_returns)*[@SN2001M] known from the field of economics.

And this makes a lot of sense here.
On one hand, the maximal possible improvement of the solution quality is bounded by the global optimum &ndash; once we have obtained it, we cannot improve the quality further, even if we invest infinitely much of an resource.
On the other hand, in most practical problems, the amount of solutions that have a certain quality gets smaller and smaller, the closer said quality is to the optimal one.
This is actually what we see in [@fig:jssp_progress_rs_log]: The chance of randomly guessing a solution of quality&nbsp;$F$ becomes the smaller the better (smaller)&nbsp;$F$ is.
