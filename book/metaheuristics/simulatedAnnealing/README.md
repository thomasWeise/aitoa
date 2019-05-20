## Simulated Annealing {#sec:simulatedAnnealing}

So far, we have only discussed one variant of local search: the hill climbing algorithm.
A hill climbing algorithm is likely to get stuck at local optima, which may vary in quality.
We found that we can utilize this variance of the result quality by restarting the optimization process when it could not improve any more in [@sec:stochasticHillClimbingWithRestarts].
Such a restart is costly, as it forces the local search to start completely from scratch (while we, of course, remember the best-ever solution in a variable hidden from the algorithm).

### Idea: Accepting Worse Solutions with Decreasing Probability

[Simulated Annealing](http://en.wikipedia.org/wiki/Simulated_annealing) (SA)&nbsp;[@KGV1983OBSA; @C1985TATTTSPAESA; @DPSW1982MCTICO] is a local search which provides a different approach to escape local optima.
This algorithm therefore introduces three principles:

1. Worse candidate solutions are sometimes accepted, too.
2. The probability&nbsp;$P$ of accepting them is decreases with increasing differences&nbsp;$\Delta E$ of the objective values to the current-best solution.
3. The probability also decreases with the number of performed search steps.

The basic idea of SA is as follows:
$\Delta E$ be the difference between the objective value of the freshly sampled point&nbsp;$\sespel$ from the search space and the best-so-far point&nbsp;$\bestSoFar{\sespel}$, where $\repMap$ is the representation mapping and $\objf$ the objective function, i.e.

$$ \Delta E = \objf(\repMap(\sespel)) - \objf(\repMap(\bestSoFar{\sespel})) $$ {#eq:simulatedAnnealingDeltaE}

The probability $P$ to overwrite $\bestSoFar{\sespel}$ with $\sespel$ then be

$$ P = \left\{\begin{array}{ll} 1&\textnormal{if~}\Delta E \leq 0\\ e^{-\frac{\Delta E}{T}}&\textnormal{if~}\Delta E >0 \land T > 0\\ 0&\textnormal{otherwise~}(\Delta E > 0 \land T=0) \end{array} \right. $$ {#eq:simulatedAnnealingP}

In other words, if the new candidate solution is actually better than the current best one, then we will definitely accept it, i.e., if $\Delta E < 0$, which means that $\objf(\repMap(\sespel)) < \objf(\repMap(\bestSoFar{\sespel}))$.
If the new solution is worse, then $\Delta E > 0$.
The acceptance probability then

1. gets smaller the larger $\Delta E$ is and 
2. gets smaller the smaller the so-called "temperature" $T\geq 0$ is.

The algorithm is inspired by simulating the thermodynamic process of *annealing* using statistical mechanics, hence the naming&nbsp;[@MRRTT1953EOSCBFCM].
Both the temperature&nbsp;$T>0$ and the objective value difference&nbsp;$\Delta E>0$ enter [@eq:simulatedAnnealingP] in an exponential term and the two above points follow from $e^{-x_1}<e^{-x_2}\forall x_1>x_2$ and $e^{-x}\in[0,1]\forall x>0$.     

The temperature decreases and approaches zero with the algorithm iteration&nbsp;$\iteration$, i.e., the performed objective function evaluations.
In other words, $T$ is actually a monotonously decreasing function $T(\iteration)$ called the "temperature schedule" and it holds that $\lim_{\iteration\rightarrow\infty} T(\iteration) = 0$.

This means, we can add a third point, namely

3. The acceptance probability decreases over time.


### The Algorithm

The SA algorithm can be summarized as follows:

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
    e. If&nbsp;$\obspel'\leq\bestSoFar{\obspel}$, then
       i. Store&nbsp;$\sespel'$ in the variable&nbsp;$\sespel$ and&nbsp;$\obspel'$ in&nbsp;$\obspel$.
       ii. If&nbsp;$\obspel'\leq\bestSoFar{\obspel}$, then store&nbsp;$\solspel'$ in the variable&nbsp;$\bestSoFar{\solspel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$.
       iii. Perform next iteration by going to step&nbsp;6.
    f. Compute the temperature $T$ according to the temperature schedule, i.e., set $T=T(\iteration)$.
    g. If&nbsp;$T\leq 0$ the perform next iteration by goind to step&nbsp;6.
    h. Set $\Delta E = \objf(\repMap(\sespel)) - \objf(\repMap(\bestSoFar{\sespel}))$ according to [@eq:simulatedAnnealingDeltaE].
    i. Compute $P=e^{-\frac{\Delta E}{T}}$ according to [@eq:simulatedAnnealingP].
    j. Draw a random number $r$ uniformly distributed in $[0,1)$.
    k. If&nbsp;$k\leq P$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\bestSoFar{\sespel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$ and perform next iteration by goind to step&nbsp;6.    
7. Return best-so-far objective value&nbsp;$\bestSoFar{\obspel}$ and best solution&nbsp;&nbsp;$\bestSoFar{\obspel}$ to the user.

This algorithm is implemented in [@lst:SimulatedAnnealing] and we will refer to it as&nbsp;`sa`.

\repo.listing{lst:SimulatedAnnealing}{An excerpt of the implementation of the Simulated Annealing algorithm.}{java}{src/main/java/aitoa/algorithms/SimulatedAnnealing.java}{}{relevant}
