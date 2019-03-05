## Testing for Significance {#sec:testForSignificance}

We can now e.g., perform 20 runs each with two different optimization algorithms&nbsp;$\mathcal{A}$ and&nbsp;$\mathcal{B}$ on one problem instance and compute the median of one of the two performance measures for each set of runs.
Likely, they will be different.
Actually, most the performance indicators in the result tables we looked at in our experiments on the JSSP were different.
Almost always, one of the two algorithms will have better results.
What does this mean?

It means that one of the two algorithms is better &ndash; with a certain probability.
We could get the results we get either because $\mathcal{A}$ is really better than $\mathcal{B}$ or &ndash; as mentioned in [@sec:eaTestForSignificance] &ndash; by pure coincidence, as artifact from the randomness of our algorithms. 

If we say "$\mathcal{A}$ is better than $\mathcal{B}$" because this is what we saw in our experiments, we have a certain probabilitys&nbsp;$p$ to be wrong.
Strictly speaking, the statement "$\mathcal{A}$ is better than $\mathcal{B}$" makes only sense if we can give an upper bound&nbsp;$\alpha$ for the error probability.

Assume that we compare two data samples&nbsp;$A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n_A-1})$ and&nbsp;$B=(\arrayIndex{b}{0},\arrayIndex{b}{1}, \dots, \arrayIndex{b}{n_B-1})$.
We observe that the elements in&nbsp;$A$ tend to be bigger than those in&nbsp;$B$, for instance, $\median(A)>\median(B)$.
Of course, just claiming that the algorithm&nbsp;$\mathcal{A}$ from which the data sample&nbsp;$A$ stems tends to produce bigger results than&nbsp;$\mathcal{B}$ which has given us the observations in&nbsp;$B$, we would run the risk of being wrong.
Instead of doing this directly, we try to compute the probability&nbsp;$p$ that our conclusion is wrong.
If&nbsp;$p$ is lower than a small threshold&nbsp;$\alpha$, say, $\alpha=0.02$, then we can accept the conclusion.
Otherwise, the differences are not significant and we do not make the claim.

### Example for the Underlying Idea (Binomial Test)

Let's say I invited you to play a game of coin tossing.
We flip a coin.
If it shows up as heads, then you win 1&nbsp;RMB and if it is tails, you give me 1&nbsp;RMB instead.
We play 160&nbsp;times and I win 128&nbsp;times, as illustrated in [@fig:coin_toss]. 

![The results of our coin tossing game, where I win 128&nbsp;times (red) and you only 32&nbsp;times (green).](\relative.path{coin_toss.svgz}){#fig:coin_toss width=74%} 

This situation makes you suspicious, as it seems unlikely to you that I would win four times as often as you with a fair coin.
You wonder ifI cheated on you, i.e., if used a "fixed" coin with a winning probability different from 0.5.
So your hypothesis&nbsp;$H_1$ is that I cheated.
Unfortunately, it is impossible to make any useful statement about my winning probability if I cheated apart from that it should be bigger than 0.5. 

What you can do is use make the opposite hypothesis&nbsp;$H_0$: I did not cheat, the coin is fair and both of us have winning probability of&nbsp;$q=0.5$.
Under this assumption you can compute the probability that I would win at least $m=128$&nbsp;times out of $n=160$&nbsp;coin tosses.
Flipping a coin $n$&nbsp;times is a [Bernoulli process](http://en.wikipedia.org/wiki/Bernoulli_process)
The probability&nbsp;$\probability[k|n]$ to win *exactly* $k$&nbsp;times in $n$&nbsp;coin tosses is then: 

$$ \probability[k|n] = \binom{n}{k} q^k (1-q)^{n-k} = \binom{n}{k} 0.5^k 0.5^{n-k} = \binom{n}{k} 0.5^n = \binom{n}{k} \frac{1}{2^n} $$

where $\binom{n}{k}=\frac{n!}{k!(n-k)!}$ is the [binomial coefficient](http://en.wikipedia.org/wiki/Binomial_coefficient) "$n$&nbsp;over&nbsp;$k$".
Of course, if winning 128&nbsp;times would be an indication of cheating, winning even more often would have been, too.
Hence we compute the probability&nbsp;$\probability[k\geq m|n]$ for me to win *at least* $m$&nbsp;times if we had played with a fair coin, which is:

$$ \probability[k\geq m|n] = \sum_{k=m}^n \binom{n}{k} \frac{1}{2^n} = \frac{1}{2^n} \sum_{k=m}^n \binom{n}{k} $$

In our case, we get

$$ \begin{array}{rcl}
\probability[k\geq 128|160] &=& \frac{1}{2^{160}} \sum_{k=128}^{160} \binom{n}{k}\\
&=&\frac{1'538'590'628'148'134'280'316'221'828'039'113}{365'375'409'332'725'729'550'921'208'179'070'754'913'983'135'744}\\
&\approx& \frac{1.539*10^{33}}{3.654*10^{47}}\\
&\approx& 0.00000000000000421098571\\
&\approx& 4.211 * 10^{-15}
\end{array} $$

In other words, the chance that I would win that often in a fair game is very, very small.
If you reject the hypothesis&nbsp;$H_0$, your probability $p=\probability[k\geq 128|160]$ to be wrong is very small.
If you reject&nbsp;$H_0$ and accept&nbsp;$H_1$, $p$ would be your probability to be wrong.
Normally, you would set yourself beforehand a limit&nbsp;$\alpha$, say&nbsp;$\alpha=0.01$ and if&nbsp;$p$ is less than that, you will risk accusing me.
Since $p \ll \alpha$, you therefore can be confident to assume that the coin was fixed.
This, actually, is the [binomial test](http://en.wikipedia.org/wiki/Binomial_test).

### The Concept of Many Statistical Tests

This is, roughly, how statistical tests work.
We make a set of observations, for instance, we run experiments with two algorithms&nbsp;$\mathcal{A}$ and&nbsp;$\mathcal{B}$ on one problem instance and get two corresponding lists ($A$&nbsp;and&nbsp;$B$) of measurements of a performance indicator.
The mean or median values of these lists will differ, i.e., one of the two methods will have performed better.
So our hypothesis&nbsp;$H_1$ could be "Algorithm&nbsp;$\mathcal{A}$ is better than algorithm&nbsp;$\mathcal{B}$."
Unfortunately, if that is indeed true, we cannot really know how likely it would have been to get exactly the experimental results that we got.
Instead, we define the null hypothesis&nbsp;$H_0$ that "The performance of the two algorithms is the same," i.e., $\mathcal{A} \equiv \mathcal{B}$.
If that would have been the case, the the data samples&nbsp;$A$ and&nbsp;$B$ would stem from the same algorithm, would be observations of the same random variable, i.e., elements from the same population.
If we combine&nbsp;$A$ and&nbsp;$B$ to a set&nbsp;$O$, we can then wonder how likely it would be to draw two sets from&nbsp;$O$ that show the same characteristics as&nbsp;$A$ and&nbsp;$B$.
If the probability is high, then we cannot rule out that $\mathcal{A} \equiv \mathcal{B}$.
If the probability is low, say below $\alpha=0.02$, then we can reject&nbsp;$H_0$ and confidently assume that&nbsp;$H_1$ is true and our observation was significant.

### Second Example (Randomization Test)

Let us now consider a more concrete example.
We want to compare two algorithms&nbsp;$\mathcal{A}$ and&nbsp;$\mathcal{B}$ on a given problem instance.
We have conducted a small experiment and measured objective values of their final runs in a few runs in form of the two data sets&nbsp;$A$ and&nbsp;$B$, respectively:

- $A = (2, 5, 6, 7, 9, 10)$ and
- $B = (1, 3, 4, 8)$

From this, we can compute the arithmetic means:

- $\mean(A)=\frac{39}{6}=6.5$ and
- $\mean(B)=\frac{16}{4}=4$.

It looks like algorithm&nbsp;$\mathcal{B}$ may produce the smaller objective values.
But is this assumption justified based on the data we have?
Is the difference between $\mean(A)$ and $\mean(B)$ significant at a threshold of $\alpha=2$?

If&nbsp;$\mathcal{B}$ is truly better than&nbsp;$\mathcal{A}$, which is our hypothesis&nbsp;$H_1$, then we cannot calculate anything.
Let us therefore assume as null hypothesis&nbsp;$H_0$ the observed difference did just happen by chance and, well, $\mathcal{A} \equiv \mathcal{B}$.
Then, this would mean that the data samples&nbsp;$A$ and&nbsp;$B$ stem from the *same* algorithm (as $\mathcal{A} \equiv \mathcal{B}$).
The two sets would only be artificial, an artifact of our experimental design.
Instead of having two data samples, we only have one, namely the union set&nbsp;$O$ with&nbsp;10 elements:

- $O = A \cup B = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)$

Moreover, any division&nbsp;$C$ of&nbsp;$O$ into two sets&nbsp;$A'$ and&nbsp;$B'$ of sizes&nbsp;6 and&nbsp;4, respectively, would have had the same probability of occurrence.
There are $\binom{10}{4}=210$ different ways of drawing 4&nbsp;elements from&nbsp;$O$.
Whenever we draw 4&nbsp;elements from&nbsp;$O$ to form a potential set&nbsp;$B'$.
This leaves the remaining 6&nbsp;elements for a potential set&nbsp;$A'$, meaning $\binom{10}{6}=210$ as well.
Any of these 210 possible divisions of&nbsp;$O$ would have had the same probability to occur in our experiment &ndash; if $H_0$ holds.

If we enumerate all possible divisions with a small program, we find that there are exactly&nbsp;27 of them which lead to a set&nbsp;$B'$ with $\mean(B')\leq 4$.
This, of course, means that in exactly these 27&nbsp;divisions, $\mean(A')\geq 6.5$.

In other words, if $H_0$&nbsp;holds, there would have been a probability of $p=\frac{27}{210}=\frac{9}{70}\approx 0.1286$ that we would see arithmetic mean performances *as extreme* as we did.
If we would reject&nbsp;$H_0$ and instead claim that&nbsp;$H_1$ is true, i.e., alogirthm&nbsp;$\mathcal{B}$ is better than&nbsp;$\mathcal{A}$, then we have a 13% chance of being wrong.
Since this is more than our pre-defined significance threshold of&nbsp;$\alpha=0.02$, we cannot reject&nbsp;$H_0$.
Based on the little data we collected, we cannot be sure whether algorithm&nbsp;$\mathcal{B}$ is better or not.

This here just was an example for a [Randomization Test](http://en.wikipedia.org/wiki/Resampling_(statistics)#Permutation_tests)&nbsp;[@BLB2008VMIDBS; @E1995RT].
It exemplifies how many statistical (non-parametric) tests work.

The number of all possible divisions the joint sets&nbsp;$O$ of measurements grows very quickly with the size of&nbsp;$O$.
In our experiments, where we always conducted 101&nbsp;runs per experiment, we would already need to enumerate $\binom{202}{101} \approx 3.6*10^{59}$ possible divisions when comparing two sets of results.
This, of course, is not possible.
Hence, practically relevant tests avoid this by applying clever mathematical tricks.

### Parametric vs. Non-Parametric Tests {#sec:nonParametricTests}

There are two types of tests: parametric and non-parametric tests.
The so-called parametric tests assume that the data follows certain distributions.
Examples for parametric tests&nbsp;[@B2001MVORSNPM] include the $t$-test, which assumes normal distribution.
This means that if our observations follow the normal distribution, then we cannot apply the $t$-test.
Since we often do not know which distribution our results follow, we should not apply the $t$-test.
In general, if we are not 100% sure that our data fulfills the requirements of the tests, we should not apply the tests.
Hence, we are on the safe side if we do not use parametric tests.

Non-Parametric tests, on the other hand, are more robust in that make very few assumptions about the distributions behind the data.
Examples include

- the Wilcoxon rank sum test with continuity correction (also called [Mann-Whitney U test](http://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test))&nbsp;[@B1972CCSURS; @SC1988NSFTBS; @HW1973NSM; @MW1947OATOWOOTRVISLTTO],
- [Fisher's Exact Test](http://en.wikipedia.org/wiki/Fisher%27s_exact_test)&nbsp;[@F1922OTIOCFCTATCOP],
- the [Sign Test](http://en.wikipedia.org/wiki/Sign_test)&nbsp;[@G2003SFNEIDSDWIWMEST; @SC1988NSFTBS],
- the [Randomization Test](http://en.wikipedia.org/wiki/Resampling_(statistics)#Permutation_tests)&nbsp;[@BLB2008VMIDBS; @E1995RT], and
- [Wilcoxon's Signed Rank Test](http://en.wikipedia.org/wiki/Wilcoxon_signed-rank_test)&nbsp;[@W1945ICBRM].

They tend to work similar to the examples given above.
When comparing optimization methods, we should always apply non-parametric tests.

The most suitable test in many cases is the above-mentioned **Mann-Whitney U test**.
Here, the hypothesis&nbsp;$H_1$ is that one of the two distributions&nbsp;$\mathcal{A}$ and&nbsp;$\mathcal{B}$ producing the two measured data samples&nbsp;$A$ and&nbsp;$B$, which are compared by the test, tends to produce larger or smaller values than the other.
The null hypothesis&nbsp;$H_0$ would be that this is not true and it can be rejected if the computed $p$-values are small. 
Doing this test manually is quite complicated and describing it is beyond the scope of this book.
Luckily, it is implemented in many tools, e.g., as the function `wilcox.test` in the `R`&nbsp;programming language, where you can simply feed it with two lists of numbers and it returns the $p$-value.

Good significance thresholds&nbsp;$\alpha$ are 0.02 or 0.01.

### Performing Multiple Tests

We do not just compare two algorithms on a single problem instance.
Instead, we may have multiple algorithms and several problem instances.
In this case, we need to perform [multiple comparisons](http://en.wikipedia.org/wiki/Multiple_comparisons_problem) and thus apply $N>1$&nbsp;statistical tests.
Before we begin this procedure, we will define a significance threshold&nbsp;$\alpha$, say 0.01.
In each single test, we check one hypothesis, e.g., "this algorithm is better than that one" and estimate a certain probability&nbsp;$p$ to err.
If $p<\alpha$, we can accept the hypothesis.

However, with $N>1$ tests at a significance level&nbsp;$\alpha$ each, our overall probability to accept at least one wrong hypothesis is not&nbsp;$\alpha$.
In *each* of the $N$&nbsp;test, the probability to err is&nbsp;$\alpha$ and the probability to be right is&nbsp;$1-\alpha$.
The chance to always be right is therefore $(1-\alpha)^N$ and the chance to accept at least one wrong hypothesis becomes

$$ \probability[\text{error}|\alpha]=1-(1-\alpha)^N $$

For $N=100$ comparisons and $\alpha=0.01$ we already arrive at $\probability[\text{error}|\alpha]\approx 0.63$, i.e., are very likely to accept at least one conclusion.
One hundred comparisons is not an unlikely situation: Many benchmark problem sets contain at 100 instances or more.
One comparison of two algorithms on each instance means that&nbsp;$N=100$.
Also, we often compare more than two algorithms.
For $k$&nbsp;algorithms on a single problem instance, we would already have $N=k(k-1)/2$&nbsp;pairwise comparisons.

In all cases with $N>1$, we therefore need to use an adjusted significance level&nbsp;$\alpha'$ in order to ensure that the overall probability to make wrong conclusions stays below&nbsp;$\alpha$.
The most conservative &ndash; and therefore my favorite &ndash; way to do so is to apply the [Bonferroni correction](http://en.wikipedia.org/wiki/Bonferroni_correction)&nbsp;[@D1961MCAM].
It defines: 

$$ \alpha' = \alpha/N $$

If we use&nbsp;$\alpha'$ as significance level in each of the&nbsp;$N$ tests, we can ensure that the resulting probability to accept at least one wrong hypothesis $\probability[\text{error}|\alpha']\leq \alpha$, as illustrated in [@fig:multicomp_bonferroni].

![The probability $\probability[\text{error}|\alpha]$ of accepting at least one wrong hypothesis when applying an unchanged significance level&nbsp;$\alpha$ in&nbsp;$N$ tests (left axis) versus similar &ndash; and almost constant &ndash; $\probability[\text{error}|\alpha']$ when using corrected value&nbsp;$\alpha'=\alpha/N$ instead (both right axis), for&nbsp;$\alpha=0.01$. ](\relative.path{multicomp_bonferroni.svgz}){#fig:multicomp_bonferroni width=80%} 
