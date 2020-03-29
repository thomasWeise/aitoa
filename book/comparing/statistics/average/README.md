### Averages: Arithmetic Mean vs. Median {#sec:meanVsMedian}

Assume that we have obtained a sample&nbsp;$A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ of $n$&nbsp;observations from an experiment, e.g., we have measured the quality of the best discovered solutions of 101&nbsp;independent runs of an optimization algorithm.
We usually want to get reduce this set of numbers to a single value which can give us an impression of what the "average outcome" (or result quality is).
Two of the most common options for doing so, for estimating the "center" of a distribution, are to either compute the *arithmetic mean* or the *median*.

#### Mean and Median

\text.block{definition}{arithmeticMean}{The arithmetic mean $\mean(A)$ is an estimate of the expected value of a data sample $A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$. It is computed as the sum of all&nbsp;$n$ elements&nbsp;$\arrayIndex{a}{i}$ in the sample data&nbsp;$A$ divided by the total number&nbsp;$n$ of values.}

$$ \mean(A) = \frac{1}{n} \sum_{i=0}^{n-1} \arrayIndex{a}{i} $$
 
\text.block{definition}{median}{The median $\median(A)$ is the value separating the bigger half from the lower half of a data sample or distribution. It is the value right in the middle of a *sorted* data sample $A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ where $\arrayIndex{a}{i-1}\leq \arrayIndex{a}{i} \; \forall i \in 1\dots (n-1)$.}

$$ \median(A) = \left\{\begin{array}{ll}
\arrayIndex{a}{\frac{n-1}{2}} & \text{if }n\text{ is odd}\\
\frac{1}{2}\left(\arrayIndex{a}{\frac{n}{2}-1} + \arrayIndex{a}{\frac{n}{2}}\right) & \text{otherwise}
\end{array}\right. \quad \text{if~}\arrayIndex{a}{i-1}\leq \arrayIndex{a}{i} \; \forall i \in 1\dots (n-1) $$ {#eq:median}

Notice the zero-based indices in our formula, i.e., the data samples&nbsp;$A$ start with&nbsp;$\arrayIndex{a}{0}$.
Of course, any data sample can be transformed to a sorted data sample fulfilling the above constraints by, well, sorting it.

#### Outliers are Important but Robustness too

In order to understand the difference between these two average measures, let us consider two example data sets&nbsp;$A$ and&nbsp;$B$, both with $n_A=n_B=19$ values, only differing in their largest observation:

- $A=(1, 3, 4, 4, 4, 5, 6, 6, 6, 6, 7, 7, 9, 9, 9, 10, 11, 12, 14)$
- $B=(1, 3, 4, 4, 4, 5, 6, 6, 6, 6, 7, 7, 9, 9, 9, 10, 11, 12, 10008)$

We find that:

- $\mean(A)=\frac{1}{19}\sum_{i=0}^{18} \arrayIndex{a}{i} = \frac{133}{19} = 7$ and
- $\mean(B)=\frac{1}{19}\sum_{i=0}^{18} \arrayIndex{b}{i} = \frac{10127}{19} = 553$, while
- $\median(A)=\arrayIndex{a}{9} = 6$ and
- $\median(B)=\arrayIndex{b}{9} = 6$.

The value $\arrayIndex{b}{18}=10008$ is an unusual value in&nbsp;$B$.
It is about three orders of magnitude larger than all other measurements.
Its appearance has led to a complete change in the average computed based on the arithmetic mean in comparison to dataset&nbsp;$A$, while it had no impact on the median.

![Illustrative example for outliers in our JSSP experiment: sometimes the first function evaluation takes unusually long, although this did not have an impact on the end result (clipping from [@fig:jssp_progress_rs_log]).](\relative.path{outlier_first_fe_time.svgz}){#fig:outlier_first_fe_time width=80%}

We often call such odd values outliers&nbsp;[@G1969PFDOOIS; @M1992ITE].
They may be important information, e.g., represent some unusual side-effect in a clinical trial of a new medicine.
When analyzing algorithm performance, they may be important hints towards implementation bugs or bad worst-case behavior.
However, they also often represent measurement errors or observations which have been been disturbed by unusual effects.

In our experiments on the JSSP, for instance, some runs may perform unexpectedly few function evaluations, maybe due to scheduling issues.
In [@fig:outlier_first_fe_time], this becomes visible in some cases where the first FE was delayed for some reason &ndash; while it would not be visible if somewhere during the run an unusual delay would occur.
As a result, some runs might perform worse, because they receive fewer FEs.
Usually, we prefer statistical measures which do not suffer too much from anomalies in the data.

However, outliers can be important, too.
When we measure the performance of an algorithm implementation, there are few possible sources of "measurement errors" apart from unusual delays and even these cannot occur if we measure runtime in FEs.
If there are unusually behaving runs, then the most likely source is a bug in the algorithm implementation!
Therefore, it is important to check whether the mean and the median "fit to each other".

#### Skewed Distributions

The arithmetic mean has another inherent "vulnerability."
When thinking about the mean of a data set, we often implicitly assume that the distribution is symmetric.
For example, in&nbsp;[@R2011WDEGMFA] we find that the annual average income of all families in US grew by&nbsp;1.2% per year from 1976 to 2007.
This mean growth, however, is not distributed evenly, as the top-1% of income recipients had a 4.4%&nbsp;per-year growth while the bottom&nbsp;99% could only improve by&nbsp;0.6% per year.
The arithmetic mean does not necessarily give an indicator of the range of the most likely observations to encounter.

In optimization, the quality of good results is limited by the lower bound of the objective function and most reasonable algorithms will give us solutions not too far from it.
In such a case, the objective function appears almost "unbounded" towards worse solutions, because only the upper bound will be very far away. 
This means that we may likely encounter algorithms that often give us very good results (close to the lower bound) but rarely also bad results, which can be far from the bound.
Thus, the result distribution might be skewed, too.

However, we can also make an argument for the opposite:
Let us take the MAX&#8209;SAT problem, an \NPprefix&#8209;hard problem.
If we apply a local search algorithm to a set of different MAX&#8209;SAT instances, it may well be that the algorithm requires exponential runtime on 25% of them while solving the others in polynomial time&nbsp;[@HS2000LSAFSAEE]!
This would mean that if we consider only the median runtime, it would appear that we could solve an \NPprefix&#8209;hard problem in polynomial time, as the median would not be impacted by the worst 25% of the runs&hellip;
In other words, our conclusion would be quite spectacular, but also quite wrong.
Here, we would have a better chance to pick up that, while having found a cool algorithm, it would be too early to apply for the Turing Award.  

#### Summary

Both the arithmetic mean and median carry useful information.
The median tells us about values we are likely to encounter if we perform an experiment once and it is robust against outliers and unusual behaviors.
The mean tells us about the average performance if we perform the experiment many times, i.e., if we try to solve 1000 problem instances, the overall time we will need will probably be similar to 1000 times the average time we observed in previous experiments.
It also incorporates information about odd, rarely occurring situations while the median may "ignore" phenomena even if they occur in one third of the samples.
If the outcome in such situations is bad, then it is good having this information.

Today, the median is often preferred over the mean because it is a robust statistic.
The fact that skewed distributions and outliers have little impact on it makes it very attractive to report average result qualities.
By the way: We did always 101&nbsp;runs of our optimization algorithms in each of our JSSP experiments so that there would be an odd number of observations.
I thus could always pick a candidate solution of median quality for illustration purposes.
There is no guarantee whatsoever that a solution of mean quality exists in an experiment.

However, the weakness of the arithmetic mean, i.e., the fact that every single measured value does have an impact on it, can also be its strength:
If we have a bug in our algorithm implementation that very rarely leads to unexpectedly bad results, this will show up in the mean but not in the median.
If our algorithm on a few problem instances needs particularly long to converge, we will see it in the mean but not in the median.

While it is very common in literature to report arithmetic means of results, I think there is no reason for us to limit ourselves to only one measure of the average.
I suggest to report both to be on the safe side &ndash; as we did in our JSSP experiments.
Indeed, personally, the maybe best idea would be to consider both the mean and median value and then take the worst of the two.
This should provide a conservative and robust outlook on algorithm performance. 
