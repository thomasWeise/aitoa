## Simulated Annealing {#sec:simulatedAnnealing}

So far, we have only discussed one variant of local search: the hill climbing algorithm.
A hill climbing algorithm is likely to get stuck at local optima, which may vary in quality.
We found that we can utilize this variance of the result quality by restarting the optimization process when it could not improve any more in [@sec:stochasticHillClimbingWithRestarts].
Such a restart is costly, as it forces the local search to start completely from scratch (while we, of course, remember the best-ever solution in a variable hidden from the algorithm).

Another way to look at this is the following:
A schedule which is a local optimum probably is somewhat similar to what the globally optimal schedule would look like.
It must, obviously, also be somewhat different.
This difference is shaped such that it cannot be conquered by the unary search operator that we use, because otherwise, the basic hill climber could already move from the local to the global optimum.
If we do a restart, we also dispose of the similarities to the global optimum that we have already discovered.
We will subsequently spend time to re-discover them in the hope that this will happen in a way that allows us to eventually reach the global optimum itself.
But maybe there is a less-costly way?
Maybe we can escape from a local optimum without discarding the entirety good solution characteristics we already have discovered?

### Idea: Accepting Worse Solutions with Decreasing Probability

Simulated Annealing (SA)&nbsp;[@KGV1983OBSA; @C1985TATTTSPAESA; @DPSW1982MCTICO; @P1970AMCMFTASOCTOCOP] is a local search which provides another approach to escape local optima&nbsp;[@WGOEB; @S2003ITSSAO].
The algorithm is inspired by the idea of simulating the thermodynamic process of *annealing* using statistical mechanics, hence the naming&nbsp;[@MRRTT1953EOSCBFCM].
Instead of restarting the algorithm when reaching a local optimum, it tries to preserve the parts of the current solution by permitting search steps towards worsening objective values. 
This algorithm therefore introduces three principles:

1. Worse candidate solutions are sometimes accepted, too.
2. The probability&nbsp;$P$ of accepting them is decreases with increasing differences&nbsp;$\Delta E$ of their objective values to the current solution.
3. The probability also decreases with the number of performed search steps.

These three principles are "injected" into the main loop of the hill climber.
This is realized as follows.

Let us assume that $\sespel\in\searchSpace$&nbsp;is the "current" point that our local search maintains.
$\sespel'\in\searchSpace$&nbsp;is the "newly sampled" point, i.e., the result of the application of the unary search operator to&nbsp;$\sespel$.
Then, $\Delta E$ be the difference between the objective value corresponding to&nbsp;$\sespel'$ and&nbsp;$\sespel$.
In other words, if $\repMap$ is the representation mapping and $\objf$ the objective function, then:

$$ \Delta E = \objf(\repMap(\sespel')) - \objf(\repMap(\sespel)) $$ {#eq:simulatedAnnealingDeltaE}

Clearly, if we try to minimize the objective function&nbsp;$\objf$, then $\Delta E < 0$ means that $\sespel'$ is better than $\sespel$ since $\objf(\repMap(\sespel')) < \objf(\repMap(\sespel))$.
If $\Delta E>0$, on the other hand, the new solution is worse.
The probability&nbsp;$P$ to overwrite&nbsp;$\sespel$ with&nbsp;$\sespel'$ then be

$$ P = \left\{\begin{array}{rl}
1 & \text{if~}\Delta E \leq 0\\
e^{-\frac{\Delta E}{T}} & \text{if~}\Delta E >0 \land T > 0\\
0 & \text{otherwise~}(\Delta E > 0 \land T=0)
\end{array} \right. $$ {#eq:simulatedAnnealingP}

In other words, if the new point&nbsp;$\sespel'$ is actually better (or, at least, not worse) than the current point&nbsp;$\sespel$, i.e., $\Delta E \leq 0$, then we will definitely accept it.
If the new point&nbsp;$\sespel'$ is worse ($\Delta E > 0$), then the acceptance probability

1. gets smaller the larger $\Delta E$ is and
2. gets smaller the smaller the so-called "temperature" $T\geq 0$ is.

Both the temperature&nbsp;$T>0$ and the objective value difference&nbsp;$\Delta E>0$ enter [@eq:simulatedAnnealingP] in the exponential term and the two above points follow from $e^{-a}<e^{-b}\forall a>b$.
We also have $e^{-a}\in(0,1)\forall a>0$, so it can be used as probability value.

The temperature will be changed automatically such that it decreases and approaches zero with a rising number&nbsp;$\iteration$ of algorithm iterations, i.e., the performed objective function evaluations.
The optimization process is initially "hot" and $T$&nbsp;is high.
Then, even significantly worse solutions may be accepted
Over time, the process "cools" down and $T$&nbsp;decreases.
The search slowly accepts fewer and fewer worse solutions and more likely such which are only a bit worse.
Eventually, at temperature&nbsp;$T=0$, the algorithm only accepts better solutions. 
In other words, $T$ is actually a monotonously decreasing function $T(\iteration)$ called the "temperature schedule."
It holds that $\lim_{\iteration\rightarrow+\infty} T(\iteration) = 0$.

### Ingredient: Temperature Schedule

The temperature schedule&nbsp;$T(\iteration)$ determines how the temperature changes over time (where time is measured in algorithm steps&nbsp;$\iteration$).
It begins with an start temperature&nbsp;$T_s$ at $\iteration=1$.
This temperature is the highest, which means that the algorithm is more likely to accept worse solutions.
It will then behave a bit similar to a random walk and put more emphasis on exploring the search space than on improving the objective value.
As time goes by and $\iteration$&nbsp;increases, $T(\iteration)$&nbsp;decreases and may even reach&nbsp;0 eventually.
Once $T$&nbsp;gets small enough, then Simulated Annealing will behave exactly like a hill climber and only accepts a new solution if it is better than the current solution.
This means the algorithm tunes itself from an initial exploration phase to strict exploitation.

Consider the following perspective:
An Evolutionary Algorithm allows us to pick a behavior in between a hill climber and a random sampling algorithm by choosing a small or large population size.
The Simulated Annealing algorithm allows for a smooth transition of a random search behavior towards a hill climbing behavior over time. 

\repo.listing{lst:temperatureSchedule}{An excerpt of the abstract base class for temperature schedules.}{java}{src/main/java/aitoa/algorithms/TemperatureSchedule.java}{}{main}

The ingredient needed for this tuning, the temperature schedule, can be expressed as a class implementing exactly one simple function that translates an iteration index&nbsp;$\iteration$ to a temperature&nbsp;$T(\iteration)$, as defined in [@lst:temperatureSchedule].

The two most common temperature schedule implementations may be the *exponential* and the *logarithmic* schedule.

#### Exponential Temperature Schedule

In an exponential temperature schedule, the temperature decreases exponentially with time (as the name implies).
It follows [@eq:sa:temperatureSchedule:exp] and is implemented in [@lst:temperatureSchedule:exp].
Besides the start temperature&nbsp;$T_s$, it has a parameter&nbsp;$\epsilon\in(0,1)$ which tunes the speed of the temperature decrease.
Higher values of $\epsilon$ lead to a faster temperature decline.

$$ T(\iteration) = T_s * (1 - \epsilon) ^ {\iteration - 1} $$ {#eq:sa:temperatureSchedule:exp}

\repo.listing{lst:temperatureSchedule:exp}{An excerpt of the exponential temperature schedules.}{java}{src/main/java/aitoa/algorithms/TemperatureSchedule.java}{}{exponential}

#### Logarithmic Temperature Schedule

The logarithmic temperature schedule will prevent the temperature from becoming very small for a longer time.
Compared to the exponential schedule, it will thus longer retain a higher probability to accept worse solutions.
It obeys [@eq:sa:temperatureSchedule:log] and is implemented in [@lst:temperatureSchedule:log]..
It, too, has the parameters&nbsp;$\epsilon\in(0,\infty)$ and&nbsp;$T_s$.
Larger values of $\epsilon$ again lead to a faster temperature decline.

$$ T(\iteration) = \frac{T_s}{\ln{\left(\epsilon(\iteration-1)+e\right)}} $$ {#eq:sa:temperatureSchedule:log}

\repo.listing{lst:temperatureSchedule:log}{An excerpt of the logarithmic temperature schedules.}{java}{src/main/java/aitoa/algorithms/TemperatureSchedule.java}{}{logarithmic}

### The Algorithm

Now that we have the blueprints for temperature schedules, we can completely define our SA algorithm and implement it in [@lst:SimulatedAnnealing]. 

1. Create random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ by using the nullary search operator.
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Store&nbsp;$\solspel$ in&nbsp;$\bestSoFar{\solspel}$ and&nbsp;$\obspel$ in&nbsp;$\bestSoFar{\obspel}$, which we will use to preserve the best-so-far results.
5. Set the iteration counter&nbsp;$\iteration$ to&nbsp;$\iteration=1$.
6. Repeat until the termination criterion is met:
    a. Set&nbsp;$\iteration=\iteration+1$.
    b. Apply the unary search operator to&nbsp;$\sespel$ to get the slightly modified copy&nbsp;$\sespel'$ of it.
    c. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
    d. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    e. If&nbsp;$\obspel'\leq \obspel$, then
       i. Store&nbsp;$\sespel'$&nbsp;in&nbsp;$\sespel$ and store&nbsp;$\obspel'$&nbsp;in&nbsp;$\obspel$.
       ii. If&nbsp;$\obspel'\leq \bestSoFar{\obspel}$, then store&nbsp;$\solspel'$&nbsp;in&nbsp;$\bestSoFar{\solspel}$ and store&nbsp;$\obspel'$&nbsp;in&nbsp;$\bestSoFar{\obspel}$.
       iii. Perform next iteration by going to *step&nbsp;6*.
    f. Compute the temperature&nbsp;$T$ according to the temperature schedule, i.e., set&nbsp;$T=T(\iteration)$.
    g. If&nbsp;$T\leq 0$ the perform next iteration by going to *step&nbsp;6*.
    h. Set&nbsp;$\Delta E = \obspel' - \obspel$ (see [@eq:simulatedAnnealingDeltaE]).
    i. Compute&nbsp;$P=e^{-\frac{\Delta E}{T}}$ (see [@eq:simulatedAnnealingP]).
    j. Draw a random number&nbsp;$r$ uniformly distributed in&nbsp;$[0,1)$.
    k. If&nbsp;$r\leq P$, then store&nbsp;$\sespel'$&nbsp;in&nbsp;$\sespel$, store&nbsp;$\obspel'$&nbsp;in&nbsp;$\obspel$, and perform next iteration by going to *step&nbsp;6*.
7. Return best encountered objective value&nbsp;$\bestSoFar{\obspel}$ and the best encountered solution&nbsp;&nbsp;$\bestSoFar{\obspel}$ to the user.

\repo.listing{lst:SimulatedAnnealing}{An excerpt of the implementation of the Simulated Annealing algorithm.}{java}{src/main/java/aitoa/algorithms/SimulatedAnnealing.java}{}{relevant}

There exist a several proofs&nbsp;[@GKR1994SAAPOC; @NS2000ANOTFTBOSA] showing that, with a slow-enough cooling schedule, the probability that Simulated Annealing will find the globally optimal solution approaches&nbsp;1.
However, the runtime one would need to invest to actually "cash in" on this promise exceeds the time needed to enumerate all possible solutions&nbsp;[@NS2000ANOTFTBOSA].
In [@sec:approximationOfTheOptimum] we discussed that we are using metaheuristics because for many problems, we can only guarantee to find the global optimum if we invest a runtime growing exponentially with the problem scale (i.e., proportional to the size of the solution space).
So while we have a proof that SA will eventually find a globally optimal solution, this proof is not applicable in any practical scenario and we instead use SA as what it is: a metaheuristic that will hopefully give us good *approximate* solutions in *reasonable* time.

### The Right Setup {#sec:sa:right_setup}

Our algorithm has four parameters:

- the start temperature&nbsp;$T_s$,
- the parameter&nbsp;$\epsilon$,
- the type of temperature schedule to use (here, logarithmic or exponential), and
- the unary search operator (in our case, we could use `1swap` or `nswap`).

We will only consider `1swap` as choice for the unary operator and focus on the exponential temperature schedule.
We have two more parameters to set: $T_s$ and $\epsilon$ and thus refer to the settings of this algorithm with the naming scheme&nbsp;`sa_exp_Ts_epsilon_1swap`.
 
At first glance, it seems entirely unclear how what to do with these parameters.
However, we may get some ideas about their rough ranges if we consider Simulated Annealing as an improved hill climber.
Then, we can get some leads from our prior experiments with that algorithm.

\relative.input{jssp_hc1_swap_sa_params.md}

: The median of total performed function evaluations and the standard deviation *sd* of the final result qualities of the hill climber `hc_1swap`. {#tbl:jssp_hc1_swap_sa_params}

In [@tbl:jssp_hc1_swap_sa_params], we print the standard deviation&nbsp;*sd* of the final result qualities that our `hc_1swap` algorithm achieved on our four JSSP instances.
This tells us something about how far the different local optima at which `hc_1swap` can get stuck are apart in terms of objective value.
The value of&nbsp;*sd* ranges from&nbsp;28 on&nbsp;`abz7` to&nbsp;137 on&nbsp;`swv15`.
The median standard deviation over all four instances is about&nbsp;50.
Thus, accepting a solution which is worse by 50&nbsp;units of makespan, i.e., with $\Delta E\approx 50$, should be possible at the beginning of the optimization process. 

How likely should accepting such a value be?
Unfortunately, we are again stuck at making an arbitrary choice &ndash; but at least we can make a choice from within a well-defined region:
Probabilities must be in&nbsp;$[0,1]$ and can be understood relatively intuitively, whereas it was completely unclear in what range reasonable "temperatures" would be located.
Let us choose that the probability&nbsp;$P_{50}$ to accept a candidate solution that is 50&nbsp;makespan units worse than the current one, i.e., has&nbsp;$\Delta E = 50$, should be&nbsp;$P_{50}=0.1$ at the beginning of the search.
In other words, there should be a 10% chance to accept such a solution at $\iteration=1$.
At $\iteration=1$, $T(\iteration)=T_s$ for both temperature schedules.
Of course, at $\iteration=1$ we do not really use the probability formula to decide whether or not to accept a solution, but we can expect that the temperature at $\iteration=2$ would still be very similar to&nbsp;$T_s$ and we are using rough and rounded approximations anyway, so let's not make our life unnecessarily complicated here. 
We can now solve [@eq:simulatedAnnealingP] for&nbsp;$T_s$:

$$ \begin{array}{rl}
P_{50} =& e^{-\frac{\Delta E}{T(\iteration)}}\\
0.1 =& e^{-\frac{50}{T_s}}\\
\ln{0.1}=& -\frac{50}{T_s}\\
T_s=&-\frac{50}{\ln{0.1}}\\
T_s\approx&21.7
\end{array} $$

A starting temperature&nbsp;$T_s$ of approximately&nbsp;$T_s=20$ seems to be suitable in our scenario.
Of course, we just got there using very simplified and coarse estimates.
If we would have chosen&nbsp;$P_{50}=0.5$, we would have gotten&nbsp;$T_s\approx 70$ and if we additionally went with the maximum standard deviation&nbsp;137 instead of the median one, we would obtain&nbsp;$T_s\approx200$.
But at least we have a first understanding of the range where we will probably find good values for&nbsp;$T_s$.

But what about the&nbsp;$\epsilon$ parameters?
In order to get an idea for how to set it, we first need to know a proper end temperature&nbsp;$T_e$, i.e., the temperature which should be reached by the end of the run.
It cannot be&nbsp;0, because while both temperature schedules do approach zero for&nbsp;$\iteration\rightarrow\infty$, they will not actually become&nbsp;0 for any finite number&nbsp;$\iteration$ of iterations.

So we are stuck with the task to pick a suitably small value for&nbsp;$T_e$.
Maybe here our previous findings from back when we tried to restart the hill climber can come in handy.
In [@sec:hillClimberWithRestartSetup], we learned that it makes sense to restart the hill climber after $L=16'384$ unsuccessful search steps.
So maybe a terminal state for our Simulated Annealing could be a scenario where the probability&nbsp;$P_e$ of accepting a candidate solution which is $\Delta E=1$&nbsp;makespan unit worse than the current one should be&nbsp;$P_e=1/16'384$?
This would mean that the chance to accept a candidate solution being marginally worse than the current one would be about as large as making a complete restart in&nbsp;`hcr_16384_1swap`.
Of course, this is again an almost arbitrary choice, but it at least looks like a reasonable terminal state for our Simulated Annealing algorithm.
We can now solve [@eq:simulatedAnnealingP] again to get the end temperature&nbsp;$T_e$:

$$ \begin{array}{rl}
P_e =& e^{-\frac{\Delta E}{T(\iteration)}}\\
1/16'384 =& e^{-\frac{1}{T_e}}\\
\ln{(1/16'384)}=& -\frac{1}{T_e}\\
T_e=&-\frac{1}{\ln{(1/16'384)}}\\
T_e\approx&0.103
\end{array} $$
 
We choose a final temperature of&nbsp;$T_e=0.1$. 
But when should it be reached?
In [@tbl:jssp_hc1_swap_sa_params], we print the total number of function evaluations (FEs) that our `hc_1swap` algorithm performed on the different problem instances.
We find that it generated and evaluated between 22&nbsp;million on&nbsp;`swv15` and 71&nbsp;million on&nbsp;`la24` candidate solutions.^[Notice that back in [@tbl:jssp_hc_1swap_results], we printed the median number FEs until the best solution was discovered, not until the algorithm has terminated.]
The overall median is at about 30&nbsp;million FEs within the 3&nbsp;minute computational budget.
From this, we can conclude that after about 30&nbsp;million FEs, we should reach approximately&nbsp;$T_e=0.1$.
We can solve [@eq:sa:temperatureSchedule:exp] for&nbsp;$\epsilon$ to configure the exponential schedule:

$$ \begin{array}{rl}
T(\iteration) =& T_s * (1 - \epsilon) ^ {\iteration - 1} \\
T(30'000'000) =& 20 * (1 - \epsilon) ^ {30'000'000 - 1} \\
0.1 =& 20 * (1 - \epsilon) ^ {29'999'999} \\
0.1/20 =& (1 - \epsilon) ^ {29'999'999} \\
0.005^{1/29'999'999} =& 1 - \epsilon \\
\epsilon =& 1 - 0.005^{1/29'999'999}\\
\epsilon \approx& 1.776*10^{-7}
\end{array} $$

We can conclude, for an exponential temperature schedule, settings for&nbsp;$\epsilon$ somewhat between $1!\cdot\!10^{-7}$ and $2\!\cdot\!10^{-7}$ seem to be a reasonable choice if the start temperature&nbsp;$T_s$ is set to&nbsp;20.

In [@fig:sa_temperature_schedules], we illustrate the behavior of the exponential temperature schedule for starting temperature&nbsp;$T_s=20$ and the six values $5\!\cdot\!10^{-8}$, $1\!\cdot\!10^{-7}$, $1.5\!\cdot\!10^{-7}$, $2\!\cdot\!10^{-7}$, $4\!\cdot\!10^{-7}$, and&nbsp;$8\!\cdot\!10^{-7}$.
The sub-figure on top shows how the temperature declines over the performed objective value evaluations.
Starting at&nbsp;$T_s=20$ it reaches close to zero for $\epsilon\geq 1.5\!\cdot\!10^{-7}$ after about $\iteration=30'000'000$&nbsp;FEs.
For the smaller&nbsp;$\epsilon$ values, the temperature would need longer to decline, while for larger values, it declines quicklier.
The next three sub-figures show how the probability to accept candidate solutions which are worse by $\Delta E$ units of the objective value decreases with&nbsp;$\iteration$ for&nbsp;$\Delta E\in\{1, 3, 10\}$.
This decrease is, of course, the direct result of the temperature decrease.
Solutions with larger&nbsp;$\Delta E$ clearly have a lower probability of being accepted.
The larger&nbsp;$\epsilon$, the earlier and faster does the acceptance probability decrease. 

![The temperature progress of six exponential temperature schedules (top) plus their probabilities to accept solutions with objective values worse by&nbsp;1, 3, or&nbsp;10 than the current solution.](\relative.path{sa_temperature_schedules.svgz}){#fig:sa_temperature_schedules width=91%}

![The median result quality of the&nbsp;`sa_exp_20_epsilon_1swap` algorithm, divided by the lower bound $\lowerBound(\objf)^{\star}$ from [@tbl:jsspLowerBoundsTable] over different values of the parameter&nbsp;$\epsilon$. The best values of&nbsp;$L$ on each instance are marked with bold symbols.](\relative.path{jssp_sa_1swap_med_over_epsilon.svgz}){#fig:jssp_sa_1swap_med_over_epsilon width=84%}

In [@fig:jssp_sa_1swap_med_over_epsilon], we illustrate the normalized median result quality that can be obtained by Simulated Annealing with starting temperature&nbsp;$T_s=20$, exponential schedule, and `1swap` operator for different values of the parameter&nbsp;$\epsilon$, including those from [@fig:sa_temperature_schedules].
Interestingly, it turns out that $\epsilon=2$ is the best choice for the instances `abz7`, `swv15`, and `yn4`, which is quite close to what we could expect from our calculation.
Smaller values will make the temperature decrease more slowly and lead to too much exploration and too little exploitation, as we already know from [@fig:sa_temperature_schedules].
They work better on instance `la24`, which is no surprise:
From [@tbl:jssp_hc1_swap_sa_params], we know that on this instance, we can conduct more than twice as many objective value evaluations than on the others within the three minute budget:
On `la24`, we can do enough steps to let the temperature decrease sufficiently even for smaller&nbsp;$\epsilon$.

### Results on the JSSP {#sec:saResultsOnJSSP}

We can now evaluate the performance of our Simulated Annealing approach on the JSSP.
We choose the setup with exponential temperature schedule, the `1swap` operator, the starting temperature&nbsp;$T_s=20$, and the parameter&nbsp;$\epsilon=2\!\cdot\!10^{-7}$.
For simplicity, we refer to it as `sa_exp_20_2_1swap`. 

\relative.input{jssp_sa_results.md}

: The results of the Simulated Annealing setup `sa_exp_20_2_1swap` in comparison with the best EA, `eac_4_5%_nswap`, and the hill climber with restarts&nbsp;`hcr_16384_1swap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_sa_results}

In [@tbl:jssp_sa_results], we compare results of the Simulated Annealing setup `sa_exp_20_2_1swap` to those of our best EA, `eac_4_5%_nswap`, and the hill climber with restarts&nbsp;`hcr_16384_1swap`. 
Simulated Annealing is better than these three algorithms in terms of the best, mean, and median result on almost all instances.
Only on `la24`, `eac_4_5%_nswap` can win in terms of the best discovered solution, which already was the optimum.
Our SA setup also is more reliable than the other algorithms, its standard deviation and only on `la24`, the standard deviation&nbsp;$sd$ of its final result quality is not the lowest.

We know that on `la24`, $\epsilon=2\!\cdot\!10^{-7}$ is not the best choice for SA and smaller values would perform better there.
Interestingly, in the experiment, the settings $\epsilon=4\!\cdot\!10^{-7}$ and $\epsilon=8\!\cdot\!10^{-7}$ (not listed in the table) also each discovered a globally optimal solution on that instance.

![The Gantt charts of the median solutions obtained by the `sa_exp_20_2_1swap` algorithm. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_sa_exp_20_2_1swap_med.svgz}){#fig:jssp_gantt_sa_exp_20_2_1swap_med width=84%}

![The median of the progress of the algorithms `sa_exp_20_2_1swap`, `ea_8192_5%_nswap`, `eac_4_5%_nswap`, and `hcr_16384_1swap` over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_sa_log.svgz}){#fig:jssp_progress_sa_log width=84%}

If we compare our `sa_exp_20_2_1swap` with the related work, we find its best and mean solution quality on `abz7` surpass those of the original Fast Simulated Annealing algorithm and its improved version HFSAQ from&nbsp;[@AKZ2016FSAHWQFSJSSP].
Its mean and best results of `sa_exp_20_2_1swap` on `la24` outperform the algorithms proposed in&nbsp;[@JZ2018AOGWOFSCPJSAFJSSC; @A2015ALSGAFTJSSPWIA; @JPDS2014CAODRIGAFJSSP; @A2010RIGAFTJSPACS; @ODP2010STJSPWARKGAWIP; @OV2004LSGAFTJSSP]. 
On `yn4`, it outperforms all four AntGenSA algorithms (complex hybrids of three algorithms including SA and EAs) from&nbsp;[@HRSCVGBTVMR2019AHSAFJSSP] in mean and best result quality.
Since this is an educational book, we are not really aiming for solving the JSSP outstandingly well and only use a very small set of instances.
Our algorithms are not very complicated, but these comparisons indicate that they are at least somewhat working.

We plot the Gantt charts of the median result of `sa_exp_20_2_1swap`  in [@fig:jssp_gantt_sa_exp_20_2_1swap_med].
Especially on instance `swv15`, changes are visible in comparison to the results produced by `eac_4_5%_nswap` and illustrated in [@fig:jssp_gantt_eac_4_0d05_nswap_med].

In [@fig:jssp_progress_sa_log], we plot the progress of `sa_exp_20_2_1swap` over time in comparison to `ea_8192_5%_nswap`, `eac_4_5%_nswap`, and `hcr_16384_1swap`.
Especially for `swv15` and `yn4`, we find that `sa_exp_20_2_1swap` converges towards end results that are very visibly better than the other algorithms. 

We also notice that the median solution quality obtained by `sa_exp_20_2_1swap` looks very similar to the shape of the temperature curve in [@fig:sa_temperature_schedules].
Under the exponential schedule that we use, both the temperature and acceptance probability remain high for some time until they suddenly drop.
Interestingly, the objective value of the best-so-far solution in SA seems to follow that pattern.
Its , it first declines slowly, then there is a sudden transition where many improvements are made, before the curve finally becomes flat.
This relationship between the temperature and the obtained result quality shows us that configuring the SA algorithm correctly is very important.
Had we chosen&nbsp;$\epsilon$ too small or the start temperature&nbsp;$T_s$ too high, then the quick decline could have shifted beyond our three minute budget, i.e., would not take place.
Then the results of Simulated Annealing would have been worse than those of the other three algorithms.
This also explains the worse results for smaller&nbsp;$\epsilon$ shown in [@fig:jssp_sa_1swap_med_over_epsilon]. 

The behavior of SA is different from the hill climber and small-population EA, which do not exhibit such a transition region.
The EA `ea_8192_5%_nswap` with the larger population also shows a transition from slow to faster decline, but there it takes longer and is much less steep.

### Summary

Simulated Annealing is an optimization algorithm which tunes from exploration to exploitation during the optimization process.
Its structure is similar to the hill climber, but different from that simple local search, it also sometimes moves to solutions which are worse than the one it currently holds.
While it will always accept better solutions, the probability to move towards a worse solution depends on how much worse that solution is (via&nbsp;$\Delta E$) and on the number of search steps already performed.
This later relationship is implemented by a so-called "temperature schedule":
At any step&nbsp;$\iteration$, the algorithm has a current temperature&nbsp;$T(\iteration)$.
The acceptance probability of a worse solution is computed based on how bad its objective value is in comparison and based on&nbsp;$T(\iteration)$.
Two temperature schedules are most common: letting&nbsp;$T(\iteration)$ decline either logarithmically or exponentially. 
Both have two parameters, the start temperature&nbsp;$T_s$ and&nbsp;$\epsilon$.

In our experiments, we only considered the exponential schedule.
We then faced the problem of how to set the values of these obscure parameters&nbsp;$T_s$ and&nbsp;$\epsilon$.
We did this by using the experience we already gained from our experiments with the simple hill climber:
We already know something about how different good solutions can be from each other.
This provides us with the knowledge of how "deep" a local optimum may be, i.e., what kind of values we may expect for&nbsp;$\Delta E$.
We also know roughly how many algorithm steps we can perform in our computational budget, i.e., have a rough idea of how large&nbsp;$\iteration$ can become.
Finally, we also know roughly the number&nbsp;$L$ of function evaluations after which it made sense to restart the hill climber.
By setting the probability to accept a solution with $\Delta E=1$ to $1/L$, we got a rough idea of temperature that may be good at the end of the runs.
The word "rough" appeared quite often in the above text.
It is simply not really possible to "compute" the perfect values for&nbsp;$T_s$ and&nbsp;$\epsilon$ (and we could not compute the right values for $\mu$, $\lambda$, nor $cr$ for the Evolutionary Algorithm either).
But the roughly computed values gave us a good idea of suitable settings and we could confirm them in a small experiments.
Using them, our Simulated Annealing algorithm performed quite well.
The very crude calculations in [@sec:sa:right_setup] may serve as rule-of-thumb in other scenarios, too.
