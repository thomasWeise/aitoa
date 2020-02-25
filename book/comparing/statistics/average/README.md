### Averages: Arithmetic Mean vs. Median

Assume that we have obtained a sample&nbsp;$A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ of $n$&nbsp;observations from an experiment, e.g., we have measured the quality of the best discovered solutions of 101 independent runs of an optimization algorithm.
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

#### Outliers

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

![Illustrative example for outliers in our JSSP experiment: sometimes the first function evaluation takes unusually long, although this did not have an impact on the end result.](\relative.path{outlier_first_fe_time.svgz}){#fig:outlier_first_fe_time width=80%}

We often call such odd values outliers&nbsp;[@G1969PFDOOIS; @M1992ITE].
They may be important, real data, e.g., represent some unusual side-effect in a clinical trial of a new medicine.
However, they also often represent measurement errors or observations which have been been disturbed by unusual effects.
In our experiments on the JSSP, for instance, a run with surprisingly bad performance may occur when, for whatever reason, the operating system was busy with other things (e.g., updating itself) during the run and thus took away much of the 3&nbsp;minute computation budget.
[@fig:outlier_first_fe_time] illustrates that this situation may be possible in our JSSP experiment.
On rare occasions, the time needed for creating and evaluating the first candidate solution was much longer than usual.
This may have been caused by some management procedures inside the Java Virtual Machine executing our experiments.
It did not have an impact on the final result, but if we would have computed something like the "mean time until the first solution is constructed," it might give us a wrong impression. 
Usually, we prefer statistical measures which do not suffer too much from anomalies in the data.

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

#### Summary

Take-away message: It makes sense to prefer the median over the mean, because:

- The median it is a more robust against outliers than the arithmetic mean.
- The arithmetic mean is useful especially for symmetric distributions while it does not really represent an intuitive average for skewed distributions while the median is, per definition, suitable for both kinds of distributions.
- Median values are either actually measured outcomes (if we have an odd number of observations) or are usually very close to such (if we have an even number of observations), while arithmetic means may not be similar to any measurement.

The later point is obvious in our example above: $\mean(B)=533$ is far away from any of the actual samples in&nbsp;$B$.
By the way: We did 101 runs of our optimization algorithms in each of our JSSP experiments instead of one so that there would be an odd number of observations.
I thus could always pick a candidate solution of median quality for illustration purposes.
There is no guarantee whatsoever that a solution of mean quality exists in an experiment.

It should be noted that it is very common in literature to report arithmetic means of results.
While I personally think we should emphasize reporting medians over means, I suggest to report both to be on the safe side &ndash; as we did in our JSSP experiments.
