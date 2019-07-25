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

[Simulated Annealing](http://en.wikipedia.org/wiki/Simulated_annealing) (SA)&nbsp;[@KGV1983OBSA; @C1985TATTTSPAESA; @DPSW1982MCTICO; @P1970AMCMFTASOCTOCOP] is a local search which provides another approach to escape local optima&nbsp;[@WGOEB; @S2003ITSSAO].
The algorithm is inspired by the idea of simulating the thermodynamic process of *annealing* using statistical mechanics, hence the naming&nbsp;[@MRRTT1953EOSCBFCM].
Instead of restarting the algorithm when reaching a local optima, it tries to preserve the parts of the current best solution by permitting search steps towards worsening objective values. 
This algorithm therefore introduces three principles:

1. Worse candidate solutions are sometimes accepted, too.
2. The probability&nbsp;$P$ of accepting them is decreases with increasing differences&nbsp;$\Delta E$ of the objective values to the current best solution.
3. The probability also decreases with the number of performed search steps.

This basic idea is realized as follows.
First, $\Delta E$ be the difference between the objective value of the freshly sampled point&nbsp;$\sespel'$ from the search space and the "current" best point&nbsp;$\sespel$, where $\repMap$ is the representation mapping and $\objf$ the objective function, i.e.

$$ \Delta E = \objf(\repMap(\sespel')) - \objf(\repMap(\sespel)) $$ {#eq:simulatedAnnealingDeltaE}

Clearly, if we try to minimize the objective function&nbsp;$\objf$, then $\Delta E < 0$ means that $\sespel'$ is better than $\sespel$ since $\objf(\repMap(\sespel')) < \objf(\repMap(\sespel))$.
If $\Delta E>0$, on the other hand, the new solution is worse.
The probability&nbsp;$P$ to overwrite&nbsp;$\sespel$ with&nbsp;$\sespel'$ then be

$$ P = \left\{\begin{array}{rl}
1 & \text{if~}\Delta E \leq 0\\
e^{-\frac{\Delta E}{T}} & \text{if~}\Delta E >0 \land T > 0\\
0 & \text{otherwise~}(\Delta E > 0 \land T=0)
\end{array} \right. $$ {#eq:simulatedAnnealingP}

In other words, if the new candidate solution is actually better than the current best one, i.e., $\Delta E <0$, then we will definitely accept it.
If the new solution is worse ($\Delta E > 0$), the acceptance probability then

1. gets smaller the larger $\Delta E$ is and
2. gets smaller the smaller the so-called "temperature" $T\geq 0$ is.

Both the temperature&nbsp;$T>0$ and the objective value difference&nbsp;$\Delta E>0$ enter [@eq:simulatedAnnealingP] in an exponential term and the two above points follow from $e^{-a}<e^{-b}\forall a>b$ and $e^{-a}\in[0,1]\forall a>0$.     

The temperature decreases and approaches zero with the algorithm iteration&nbsp;$\iteration$, i.e., the performed objective function evaluations.
The optimization process is initially "hot."
Then, the search progresses wildly any may accept even significantly worse solutions.
As the process "cools" down, the search tends to accept fewer and fewer worse solutions and more likely such which are only a bit worse.
Eventually, at temperature&nbsp;$T=0$, the algorithm only accepts better solutions. 
In other words, $T$ is actually a monotonously decreasing function $T(\iteration)$ called the "temperature schedule" and it holds that $\lim_{\iteration\rightarrow\infty} T(\iteration) = 0$.

### Ingredient: Temperature Schedule

The temperature schedule&nbsp;$T(\iteration)$ determines how the temperature changes over time (where time is measured in algorithm steps&nbsp;$\iteration$).
It begins with an start temperature&nbsp;$T_s$ at $\iteration=1$.
Then, the temperature is the highest, which means that the algorithm is more likely to accept worse solutions.
It will then behave a bit similar to a random walk and put more emphasis on exploring the search space than on improving the objective value.
As time goes by and $\iteration$&nbsp;increases, $T(\iteration)$ decreases and may even reach&nbsp;0 eventually.
Once $T$ gets small enough, then Simulated Annealing will behave exactly like a hill climber and only accepts a new solution if it is better than the best-so-far solution.
This means the algorithm tunes itself from an initial exploration phase to strict exploitation.

Consider the following perspective:
An Evolutionary Algorithm allows us to pick a behavior in between a hill climber and a random sampling algorithm by choosing a small or large population size.
The Simulated Annealing algorithm allows for a smooth transition of a random search behavior towards a hill climbing behavior over time. 

\repo.listing{lst:temperatureSchedule}{An excerpt of the abstract base class for temperature schedules.}{java}{src/main/java/aitoa/algorithms/TemperatureSchedule.java}{}{main}

The ingredient needed for this tuning, the temperature schedule, can be expressed as a class implementing exactly one simple function that translates an iteration index&nbsp;$\iteration$ to a temperature&nbsp;$T(\iteration)$, as defined in [@lst:temperatureSchedule].

If we want to apply Simulated Annealing to a given problem, we would like that the probability to accept worse solutions declines smoothly during the optimization process.
It should not go down close to 0 too quickly, because then we essentially have a hill climber.
It should also not stay too high for too long, because then we waste too much time investigating worse solutions.
This means that the right temperature schedule to select will depend on the problem (namely, the range of the objective values) and the computational budget at hand.

Our SA is basically an improved hill climber and, here, we want to solve the JSSP with it.
We therefore consider how many iterations the `hc_1swap` from [@sec:hc_1swap:jssp:results] performed within the three minutes of runtime.
The median total steps range from about 30&nbsp;million on `swv15` to 97&nbsp;million on `abz7`.
We also know that our objective function is discrete and reasonable values for $\Delta E$ are maybe somewhere in the range of&nbsp;1 to&nbsp;10.
This rough estimate of scale can be can be seen if we look at the differences between the best or median solutions of different algorithm settings in our previous experiments.
Hence, we should select temperature schedules that tune the probability of accepting such slightly worse solutions gracefully from relatively high to close-to-zero within 30&nbsp;million algorithms steps.
But how can we do that?

Two common ways to decrease the temperature over time are the *exponential* and the *logarithmic* temperature schedules, examples for both of which with the desired properties are illustrated in [@fig:sa_temperature_schedules].  

![The temperature progress of six example temperature schedules (top) plus their probabilities to accept solutions with objective values worse by&nbsp;1, 3, or&nbsp;5 than the current solution.](\relative.path{sa_temperature_schedules.svgz}){#fig:sa_temperature_schedules width=96%}

#### Exponential Temperature Schedule

In an exponential temperature schedule, the temperature decreases exponentially with time (as the name implies).
It follows [@eq:sa:temperatureSchedule:exp] and is implemented in [@lst:temperatureSchedule:exp].
Besides the start temperature&nbsp;$T_s$, it has a parameter&nbsp;$\epsilon\in(0,1)$ which tunes the speed of the temperature decrease.

$$ T(\iteration) = T_s * (1 - \epsilon) ^ {\iteration - 1} $$ {#eq:sa:temperatureSchedule:exp}

\repo.listing{lst:temperatureSchedule:exp}{An excerpt of the exponential temperature schedules.}{java}{src/main/java/aitoa/algorithms/TemperatureSchedule.java}{}{exponential}

Higher values of $\epsilon$ lead to a faster temperature decline.
In [@fig:sa_temperature_schedules], we choose the values $\epsilon\in\{2*10^{-7}, 4^{-7}, 8*10^{-7}\}$ and a starting temperature of&nbsp;$T_s=20$.
As can be seen, they yield a nice and smooth decline of the probabilities to accept solutions slightly worse than the current solution.
The probability curves corresponding to the exponential schedules eventually effectively become&nbsp;0 after about half of the predicted 30&nbsp;million steps. 
Notice that we chose the starting temperature&nbsp;$T_s$ and the parameter&nbsp;$\epsilon$ in such a way that solutions which are "reasonably worse" in our JSSP scenario are acceptable for a reasonable time in our optimization process, based on our knowledge of the range of objective values that may occur and the number of algorithm steps that will probably be performed.
The values of&nbsp;$T_s$ and&nbsp;$\epsilon$ are not chosen arbitrarily!
They play an important role in the algorithm.

#### Logarithmic Temperature Schedule

The logarithmic temperature schedule will prevent the temperature from becoming very small for a longer time.
Compared to the exponential schedule, it will thus longer retain a higher probability to accept worse solutions.
It obeys [@eq:sa:temperatureSchedule:log] and is implemented in [@lst:temperatureSchedule:log]..
It, too, has the parameters&nbsp;$\epsilon\in(0,\infty)$ and&nbsp;$T_s$.

$$ T(\iteration) = \frac{T_s}{\ln{\left(\epsilon(\iteration-1)+e\right)}} $$ {#eq:sa:temperatureSchedule:log}

\repo.listing{lst:temperatureSchedule:log}{An excerpt of the logarithmic temperature schedules.}{java}{src/main/java/aitoa/algorithms/TemperatureSchedule.java}{}{logarithmic}

Larger values of $\epsilon$ again lead to a faster temperature decline and we investigated logarithmic schedules with $\epsilon=1$ for three starting temperatures&nbsp;$T_s\in\{5,10,20\}$ in [@fig:sa_temperature_schedules].
Compared to our selected exponential schedules, the temperatures decline earlier but then remain at a higher value.
This means that the probability to accept worse candidates in logarithmic schedules remains almost constant (and above&nbsp;0) after some time.
Notice again that the settings of&nbsp;$T_s$ and&nbsp;$\epsilon$ are not arbitrary, they are selected so that the probability curve gives a not-too-high and not-too-low acceptance probability to solutions which are not too much worse than the current best solution.

### The Algorithm

Now that we have temperature schedules, we can completely define our SA algorithm and implement it in [@lst:SimulatedAnnealing]. 

1. Create random point&nbsp;$\sespel$ in search space&nbsp;$\searchSpace$ (using the nullary search operator).
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the representation mapping&nbsp;$\solspel=\repMap(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Store&nbsp;$\solspel$ in&nbsp;$\bestSoFar{\solspel}$ and&nbsp;$\obspel$ in&nbsp;$\bestSoFar{\obspel}$.
5. Set the iteration counter&nbsp;$\iteration$ to $\iteration=1$.
6. Repeat until the termination criterion is met:
    a. Set&nbsp;$\iteration=\iteration+1$.
    b. Apply the unary search operator to&nbsp;$\sespel$ to get the slightly modified copy&nbsp;$\sespel'$ of it.
    c. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
    d. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    e. If&nbsp;$\obspel'\leq \bestSoFar{\obspel}$, then
       i. Store&nbsp;$\sespel'$ in the variable&nbsp;$\sespel$ and&nbsp;$\obspel'$ in&nbsp;$\obspel$.
       ii. If&nbsp;$\obspel'\leq \bestSoFar{\obspel}$, then store&nbsp;$\solspel'$ in the variable&nbsp;$\bestSoFar{\solspel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$.
       iii. Perform next iteration by going to step&nbsp;6.
    f. Compute the temperature $T$ according to the temperature schedule, i.e., set $T=T(\iteration)$.
    g. If&nbsp;$T\leq 0$ the perform next iteration by goind to step&nbsp;6.
    h. Set $\Delta E = \objf(\repMap(\sespel)) - \objf(\repMap(\bestSoFar{\sespel}))$ according to [@eq:simulatedAnnealingDeltaE].
    i. Compute $P=e^{-\frac{\Delta E}{T}}$ according to [@eq:simulatedAnnealingP].
    j. Draw a random number $r$ uniformly distributed in $[0,1)$.
    k. If&nbsp;$k\leq P$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\bestSoFar{\sespel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$ and perform next iteration by goind to step&nbsp;6.    
7. Return best-so-far objective value&nbsp;$\bestSoFar{\obspel}$ and best solution&nbsp;&nbsp;$\bestSoFar{\obspel}$ to the user.

\repo.listing{lst:SimulatedAnnealing}{An excerpt of the implementation of the Simulated Annealing algorithm.}{java}{src/main/java/aitoa/algorithms/SimulatedAnnealing.java}{}{relevant}

There exist a several proofs&nbsp;[@GKR1994SAAPOC; @NS2000ANOTFTBOSA] showing that, with a slow-enough cooling schedule, the probability that Simulated Annealing will find the globally optimal solution approaches&nbsp;1.
However, the runtime one would need to invest to actually "cash in" on this promise exceeds the time needed to enumerate all possible solutions&nbsp;[@NS2000ANOTFTBOSA].
In [@sec:approximationOfTheOptimum] we discussed that we are using metaheuristics because for many problems, we can only guarantee to find the global optimum if we invest a runtime growing exponentially with the problem scale (i.e., proportional to the size of the solution space).
So while we have a proof that SA will eventually find a globally optimal solution, this proof is not applicable in any practical scenario and we instead use SA as what it is: a metaheuristic that will hopefully give us good *approximate* solutions in *reasonable* time.

### Results on the JSSP {#sec:saResultsOnJSSP}

|$\instance$|$\lowerBound{\objf}$|setup|best|mean|med|sd|med(t)|med(FEs)|
|:-:|--:|:--|--:|--:|--:|--:|--:|--:|
|`abz7`|656|`hcr_256+5%_nswap`|707|733|734|7|64s|17'293'038|
|||`ea4096_nswap_5`|685|706|706|10|**29**s|**5'933'332**|
|||`sa_e_20_2e-7_1swap`|663|673|672|5|92s|22'456'822|
|||`sa_e_20_4e-7_1swap`|**658**|674|675|5|55s|13'388'301|
|||`sa_e_20_8e-7_1swap`|663|675|675|6|36s|8'625'161|
|||`sa_l_5_1swap`|**658**|675|675|6|63s|15'745'842|
|||`sa_l_10_1swap`|659|**672**|**671**|4|86s|21'271'077|
|||`sa_l_20_1swap`|675|682|682|**3**|125s|30'740'378|
|`la24`|935|`hcr_256+5%_nswap`|945|981|984|9|57s|29'246'097|
|||`ea4096_nswap_5`|941|974|971|13|**6**s|**22'77'833**|
|||`sa_e_20_2e-7_1swap`|938|949|946|**8**|27s|12'358'941|
|||`sa_e_20_4e-7_1swap`|**935**|949|946|9|16s|7'135'423|
|||`sa_e_20_8e-7_1swap`|**935**|951|950|8|9s|4'044'217|
|||`sa_l_5_1swap`|940|956|950|13|6s|2'873'837|
|||`sa_l_10_1swap`|938|953|950|11|7s|3'210'824|
|||`sa_l_20_1swap`|938|**946**|**941**|10|19s|9'097'608|
|`swv15`|2885|`hcr_256+5%_nswap`|3645|3804|3811|44|**91**s|**14'907'737**|
|||`ea4096_nswap_5`|3440|3543|3537|51|177s|22'603'785|
|||`sa_e_20_2e-7_1swap`|2937|**2990**|**2988**|28|148s|21'949'073|
|||`sa_e_20_4e-7_1swap`|2941|2993|2993|28|128s|18'244'751|
|||`sa_e_20_8e-7_1swap`|**2936**|3000|3002|28|111s|16'029'528|
|||`sa_l_5_1swap`|2963|3032|3029|33|135s|20'087'431|
|||`sa_l_10_1swap`|2964|3021|3018|30|141s|21'252'052|
|||`sa_l_20_1swap`|2985|3017|3016|**12**|153s|22'596'946|
|`yn4`|929|`hcr_256+5%_nswap`|1081|1117|1119|14|55s|11'299'461|
|||`ea4096_nswap_5`|1017|1058|1058|18|**52**s|**8'248'627**|
|||`sa_e_20_2e-7_1swap`|973|**985**|**985**|5|113s|20'676'041|
|||`sa_e_20_4e-7_1swap`|**971**|987|986|7|68s|12'193'934|
|||`sa_e_20_8e-7_1swap`|972|988|988|7|58s|10'178'219|
|||`sa_l_5_1swap`|980|1005|1006|13|75s|13'732'297|
|||`sa_l_10_1swap`|975|997|996|11|108s|19'850'143|
|||`sa_l_20_1swap`|979|990|990|**4**|116s|21'108'153|

: The results of different Simulated Annealing setups compared to the best plain hill climber with restarts and the best basic EA. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:saVsHCAndEAJSSP}

In [@tbl:saVsHCAndEAJSSP], we now present the results of different setups of our Simulated Annealing algorithm in comparison with the hill climbers with restarts and the best pure EA setup, `ea4096_nswap_5`.
The setups are named after the pattern `sa_e_TS_EP_unary` have an exponential temperature schedule with the start temperature $T_s=TS$ and $\epsilon=EP$.
`sa_e_20_8e-7_1swap`, for instance, is SA with an exponential temperature schedule with $T_s=20$ and $\epsilon=8*10^{-7}$ and the `1swap` unary operator.
The setups named after the pattern `sa_l_TS_unary` use logarithmic schedules with $\epsilon=1$, the start temperature $T_s=TS$, and the named unary operator.

What we find from the table is that Simulated Annealing here consistently and significantly outperforms the hill climbers and the best plain EA.
On `ab7`, `swv15`, and `yn4`, its mean and median solutions are better than the best solutions offered by these algorithms.
Over all, instance `la24` could even be solved to optimality and on `abz7`, we are only 0.3% worse than the lower bound of the objective function.
The median solutions of `sa_e_20_4e-7_1swap` are illustrated in [@fig:jssp_gantt_sa_e_20_4em7_1swap_med].
For `abz7`, they are only 3% longer than the theoretical lower bound (656), 1.1% for `la24`, 4% for `swv15`, and 6% for `yan4`.
We also tested the Simulated Annealing setups with the unary `nswap` operator, but this did not yield further improvements.

If we compare our `sa_e_20_4e-7_1swap` with the related work, we find its best and mean solution quality on `abz7` surpass those of the four Genetic Algorithms in&nbsp;[@JPDS2014CAODRIGAFJSSP] as well as those of the original Fast Simulated Annealing algorithm and its improved version HFSAQ from&nbsp;[@AKZ2016FSAHWQFSJSSP].
The best result is better than the one of the TGA in&nbsp;[@AZ2015AEAGAFSTJSSP].
Its mean and best results of `sa_e_20_4e-7_1swap` on `la24` outperform all algorithms from [@JPDS2014CAODRIGAFJSSP; @A2010RIGAFTJSPACS; @JZ2018AOGWOFSCPJSAFJSSC]. 
On `yn4`, it outperforms all four AntGenSA algorithms (complex hybrids of three algorithms including SA and EAs) in&nbsp;[@HRSCVGBTVMR2019AHSAFJSSP] in mean and best result quality.
So while we are not shooting for solving the JSSP outstandingly well using very complicated algorithms, our simple take on the problem seems to work.

In [@fig:jssp_progress_sa_log], we compare the progress over time of our Simulated Annealing setups with those of the best hill climber with restarts.
We find a very significant difference on three of the four problem instancee.
The higher similarity of the end result distribution on `la24` results from the fact that even `hcr_256+5%_nswap` produces schedules which are less than 5% longer than the best possible one (objective function lower bound) in median.

We also find that the two SA approaches have qualitatively different behavior.
The setup with the logarithmic schedule improves the solution quality a bit similar to the hill climber but eventually yields better results, as it can escape from local optima.
The setup with the exponential schedule progresses initially more slowly, but at some point suddenly speeds up.
These two behaviors fit exactly the temperature schedule and acceptance probability illustrations in [@fig:sa_temperature_schedules]:
While the temperature and acceptance probability of the logarithmic schedule slowly decrease and remain at a slightly higher level, there is a clear phase transition in the exponential schedule.
Both the temperature and acceptance probability remain higher for some time until they suddenly drop.
Interestingly, the objective value of the best-so-far solution in SA seems to follow that pattern.

This also means: It is very important to have the right temperature schedule.
We obtained the right temperature schedule because we know *a)*&nbsp;the reasonable range of good objective values and *b)*&nbsp;roughly how many algorithm steps we can perform within our computational budget.

![The Gantt charts of the median solutions obtained by the&nbsp;`sa_e_20_4e-7_1swap` setup. The x-axes are the time units, the y-axes the machines, and the labels at the center-bottom of each diagram denote the instance name and makespan.](\relative.path{jssp_gantt_sa_e_20_4em7_1swap_med.svgz}){#fig:jssp_gantt_sa_e_20_4em7_1swap_med width=84%}

![The progress of the two Simulated Annealing setups&nbsp;`sa_e_20_4e-7_1swap` and&nbsp;`sa_l_10_1swap` compared with the
 best basic hill climber with restarts&nbsp;`hcr_256+5%_nswap`, over time, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis).](\relative.path{jssp_progress_sa.svgz}){#fig:jssp_progress_sa_log width=84%}