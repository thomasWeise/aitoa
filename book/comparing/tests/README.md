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

### Example for the Underlying Idea

Let's say I invited you to play a game of coin tossing.
We flip a coin.
If it shows up as heads, then you win 1&nbsp;RMB and if it is tails, you give me 1&nbsp;RMB instead.
We play 160&nbsp;times and I win 128&nbsp;times, as illustrated in [@fig:coin_toss]. 

![The results of our coin tossing game, where I win 128&nbsp;times (red) and you only 32&nbsp;times (green).](\relative.path{coin_toss.svgz}){#fig:coin_toss width=84%} 

This situation makes you suspicious, as it seems unlikely to you that I would win four times as often as you with a fair coin.
You wonder ifI cheated on you, i.e., if used a "fixed" coin with a winning probability different from 0.5.
So your hypothesis&nbsp;$H_1$ is that I cheated.
Unfortunately, it is impossible to make any useful statement about my winning probability if I cheated apart from that it should be bigger than 0.5. 

What you can do is use make the opposite hypothesis&nbsp;$H_0$: I did not cheat, the coin is fair and both of us have winning probability of&nbsp;$q=0.5$.
Under this assumption you can compute the probability that I would win at least $m=128$&nbsp;times out of $n=160$&nbsp;coin tosses.
Flipping a coin $n$&nbsp;times is a [Bernoulli process](http://en.wikipedia.org/wiki/Bernoulli_process)
The probability&nbsp;$\probablity[k|n]$ to win *exactly* $k$&nbsp;times in $n$&nbsp;coin tosses is then: 

$$ \probablity[k|n] = \binom{n}{k} q^k (1-q)^{n-k} = \binom{n}{k} 0.5^k 0.5^{n-k} = \binom{n}{k} 0.5^n = \binom{n}{k} \frac{1}{2^n} $$

where $\binom{n}{k}$ is the [binomial coefficient](http://en.wikipedia.org/wiki/Binomial_coefficient) "$n$&nbsp;over&nbsp;$k$".
Of course, if winning 128&nbsp;times would be an indication of cheating, winning even more often would have been, too.
Hence we compute the probability&nbsp;$\probablity[k\geq m|n]$ for me to win *at least* $m$&nbsp;times if we had played with a fair coin, which is:

$$ \probablity[k\geq m|n] = \sum_{k=m}^n \binom{n}{k} \frac{1}{2^n} = \frac{1}{2^n} \sum_{k=m}^n \binom{n}{k} $$

In our case, we get

$$ \begin{array}{rcl}
\probablity[k\geq 128|160] &=& \frac{1}{2^{160}} \sum_{k=128}^{160} \binom{n}{k}\\
&=&\frac{1'538'590'628'148'134'280'316'221'828'039'113}{365'375'409'332'725'729'550'921'208'179'070'754'913'983'135'744}\\
&\approx& \frac{1.539*10^{33}}{3.654*10^{47}}\\
&\approx& 0.00000000000000421098571\\
&\approx& 4.211 * 10^{-15}
\end{array} $$

In other words, the chance that I would win that often in a fair game is very, very small.
If you reject the hypothesis&nbsp;$H_0$, your probability $p=\probablity[k\geq 128|160]$ to be wrong is very small.
If you reject&nbsp;$H_0$ and accept&nbsp;$H_1$, $p$ would be your probability to be wrong.
Normally, you would set yourself beforehand a limit&nbsp;$\alpha$, say&nbsp;$\alpha=0.01$ and if&nbsp;$p$ is less than that, you will risk accusing me.
Since $p \ll \alpha$, you therefore can be confident to assume that the coin was fixed.
This, actually, is the [binomial test](http://en.wikipedia.org/wiki/Binomial_test).

### The Concept of Many Statistical Tests

This is, roughly, how statistical tests work.




We make a set of observations, for instance, we run experiments with two algorithms&nbsp;$\mathcal{A}$ and&nbsp;$\mathcal{B}$ on one problem instance and get two corresponding lists ($A$&nbsp;and&nbsp;$B$) of measurements of a performance indicator.
The mean or median values of these lists will differ, i.e., one of the two methods will have performed better.
So our hypothesis&nbsp;$H_1$ could be "Algorithms&nbsp;$\mathcal{A}$ is better than algorithm&nbsp;$\mathcal{B}$."
Unfortunately, if that is indeed true, we cannot really know how likely it would have been to get exactly the experimental results that we got.
Instead, we define the null hypothesis&nbsp;$H_0$ that "The performance of the two algorithms is the same," i.e., $\mathcal{A} \equiv \mathcal{B}$.
If that would have been the case, the the data samples&nbsp;$A$ and&nbsp;$B$ would stem from the same algorithm, would be observations of the same random variable, i.e., elements from the same population.
If we combine&nbsp;$A$ and&nbsp;$B$ to a set&nbsp;$O$, we can then wonder how likely it would be to draw two sets from&nbsp;$O$ that show the same characteristics as&nbsp;$A$ and&nbsp;$B$.
If the probability is high, then we cannot rule out that $\mathcal{A} \equiv \mathcal{B}$.
If the probability is low, say below $\alpha=0.02$, then we can reject&nbsp;$H_0$ and confidently assume that&nbsp;$H_1$ is true and our observation was significant.

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
