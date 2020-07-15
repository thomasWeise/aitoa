## Estimation of Distribution Algorithms {#sec:edas}

Estimation of Distribution Algorithms (EDAs)&nbsp;[@MP1996FROGTTEODIBP; @M1997TEFRTSAIUFP; @LL2002EODAANTFEC; @LLIB2006TANECAOEODA] follow a completely different paradigm than the methods that we have discussed up to here.
So far, we have directly focused on the points&nbsp;$\sespel$ inside the search space&nbsp;$\searchSpace$.
We tried to somehow "navigate" from one or multiple such points to better points, by investigating their neighbors via the unary operator or by trying to good find locations "between" two points via the binary operator.
EDAs instead look at the bigger picture and try to discover and exploit the structure of the space&nbsp;$\searchSpace$ itself.
The ask the questions
"Can we somehow learn which areas in&nbsp;$\searchSpace$ are promising?
Can we learn how good solutions look like?"

### The Algorithm

How do good solutions look like?
It is unlikely that good (or even optimal) solutions are uniformly distributed over the search space.
If the optimization problem that we are trying to solve is reasonable, then it should have some structure and there will be areas in the search space&nbsp;$\searchSpace$ that are more likely to contain good solutions than others.
*Distribution* here is already an important keyword:
There should be some kind of (non-uniform) probability distribution of good solutions over the search space.
If we can somehow learn this distribution, we obtain a *model* of how good solutions look like.
Then we could *sample* this distribution/model.
Sampling a distribution just means to create random points according to it:
If we sample&nbsp;$\lambda$ points from a distribution&nbsp;$M$, then more points will be created in areas where $M$ has a high probability density and fewer points from places where it has a low probability density.

A basic EDA works roughly as follows:

1. Set the best-so-far objective value&nbsp;$\bestSoFar{\obspel}$&nbsp;to&nbsp;$+\infty$ and the best-so-far candidate solution&nbsp;$\bestSoFar{\solspel}$ to&nbsp;`NULL`.
2. Initialize the model&nbsp;$M_0$, e.g., to approximate a uniform distribution.
3. Create $\lambda>2$ random points&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$, either by sampling the model or by using a nullary search operator.
4. Repeat until termination criterion is met (where $i$ be the iteration index):
   a. Map the $\lambda$&nbsp;points to candidate solutions&nbsp;$\solspel\in\solutionSpace$ using the representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ and evaluate their objective value&nbsp;$\obspel=\objf(\solspel)$.
   b. $\solspel'$&nbsp;be the best of the $\lambda$&nbsp;new candidate solutions and $\obspel'$&nbsp;be its objective value.
      If $\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\solspel'$ in&nbsp;$\bestSoFar{\solspel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$.
   c. Select the $\mu$&nbsp;best points from the set of $\lambda$&nbsp;points (with&nbsp;$1<\mu<\lambda$).
   d. Use the set&nbsp;$P_\mu$ of these $\mu$&nbsp;points to build the new model&nbsp;$M_i$.
      This step can also be implemented as model update&nbsp;$U$ and make use of the information in the old model&nbsp;$M_{i-1}$ as well as the problem instance&nbsp;$\instance$, i.e., $M_i=U(P_\mu, M_{i-1}, \instance)$.
   e. Sample $\lambda$&nbsp;points from&nbsp;$M_i$.
5. Return the candidate solution&nbsp;$\bestSoFar{\solspel}$ and its objective value&nbsp;$\bestSoFar{\obspel}$ to the user.

This structure looks different from what we had before, but we can recognize some familiar components.
The algorithm starts by creating a set of $\lambda$&nbsp;random points in the search space.
We can use the nullary search operator for this.
So this step is very similar to what EAs do (see [@sec:evolutionaryAlgorithm]).
From these $\lambda$&nbsp;points, the set&nbsp;$P_\mu$ of the $\mu$&nbsp;best ones are selected -- again, very similar to EAs.
However, EDAs do *not* apply unary or binary search operations to these points to obtain an offspring generation.
Instead, they condense the information from the selected points into a model&nbsp;$M$, which usually is a stochastic distribution.
This can be done by estimating the parameters of a stochastic distribution from all points in&nbsp;$P_\mu$.
We then can create $\lambda$&nbsp;new points by sampling them from this parameterized distribution&nbsp;$M$.

#### An Example

Maybe it is easier to understand how this algorithm works if we look at the simple example illustrated in [@fig:real_coded_umda_example].
Imagine you are supposed to find the minimum of an objective function&nbsp;$f$ defined over a two-dimensional sub-space space of the real numbers, i.e., $\solutionSpace\subset\realNumbers^2$.
For the sake of simplicity, let's assume the search and solution space are the same ($\searchSpace=\solutionSpace$) and its two decision variables be&nbsp;$x1$ and&nbsp;$x2$.
The objective function is illustrated in the top-left corner of [@fig:real_coded_umda_example].
It has a nice basin with good solutions, but also is a bit rugged.

![An example of how we could apply an EDA to an objective function&nbsp;$f$ defined over a two-dimensional search/solution space. In each iteration $i>1$, 101&nbsp;points are sampled and the best 41&nbsp;are used to derive a model&nbsp;$M$, which is defined as a normal distribution parameterized by the arithmetic means and standard devisions of the selected points along the two axes.](\relative.path{real_coded_umda_example.svgz}){#fig:real_coded_umda_example width=95%}

At the beginning of our EDA, we just generate $\lambda=101$&nbsp;points uniformly distributed in the search space (*step&nbsp;3* of our algorithm).
This is illustrated in the top-right sub-figure of [@fig:real_coded_umda_example], where we only show two dimensions but put the contour of the objective function in the background.
From the $\lambda$&nbsp;points, we keep the $\mu=41$&nbsp;ones with the best objective values (colored green) and discarded the other $101-41=60$&nbsp;points (colored red).
We can now compute the mean and standard deviation of the $\mu$&nbsp;selected points along each axis, i.e., get four parameters.
In the figures, these models are illustrated in blue.
In their center, i.e., at the two mean coordinates, you can find a little blue cross.
From the blue cross, one line along each axis, with the length of the corresponding standard deviation, forming the two axes of an ellipse.
We can see that the ellipse is located nicely in the center of the area, where we indeed can find solutions which tend to have smaller (better) objective values.

But what can we do with this model?
We can use it to generate $\lambda$&nbsp;new points.
Since we are in the continuous space, a normal distribution lends itself for this purpose.
A one-dimensional normal distribution has the feature that it gives high probability to values close to its mean.
The probability of encountering points farther away from the mean decreases quickly.
If we sample a normal distribution with a given mean and standard deviation, then most points will located within one standard deviation distance from the mean.
Since we have two means and two standard deviations, we could just use one independent normal distribution for each coordinate, i.e., each of the two decision variables.

In the second sub-figure from the top on the right hand side of [@fig:real_coded_umda_example], we did exactly that.
As can be seen, the points are located more closely to the center of the figure.
We again select the best $\mu=41$&nbsp;points of the $\lambda=101$&nbsp;samples obtained this way and build new model based on them.
The standard deviations of the model are smaller now.
We repeat this process for two more steps and tend to get points more closely to the optimum of&nbsp;$f$ and models which better represent this characteristic.

Of course, this was just an example.
We could have chosen different probability distributions as model instead of the normal distribution.
We could have updated the model in a different way, e.g., combine the previous model with the new parameters.
Also we treated the two dimensions of our search space as independent, which may not be the case in many scenarios.
And of course, for each search space, we may need to use a completely different type of model.

### The Implementation

What we first need in order to implement EDAs is an interface to represent the new structural component: a model.

\repo.listing{lst:edaModel}{An excerpt of the interface of models that can be used in Estimation of Distribution Algorithms.}{java}{src/main/java/aitoa/structure/IModel.java}{}{relevant}

[@lst:edaModel] gives an idea how a very general interface for the required new functionality could look like.
The search space&nbsp;$\searchSpace$ is represented by the generic parameter&nbsp;`X`.
In our previous example, it could be equivalent the `double[2]`.
The model used in our example would internally store four `double` values, namely the means and standard deviations along both dimensions.

We can update the model by passing $\mu$&nbsp;samples from the search space `X` to the `update` method.
The source for these samples can be any `Java` collection (all of which implement `Iterable`).
In our example in the previous section, the `update` method could iterate over the `double[2]` values provided to it and compute, for both of their dimensions, the means and standard deviations.

Then, we can call `apply` $\lambda$&nbsp;times to sample the model and generate a new points in the search space.^[We call this method `apply` and it has the same structure as the `apply` method of the `INullarySearchOperator` interface which it overrides. This trick will come in handy later on, as it allows us to also use biased models as nullary search operator. For now, please ignore it.]
This could be implemented for our example by generating the two normally distributed random numbers, one for each dimension, based on the means and standard deviations stored in the model.

It can be seen that this interface is rather general.
We make very few assumptions about the nature of the model and how the update and sampling process will work.
In order to cover models that are continuously updated and might need a certain (potentially changing) minimum number of unique samples for an update, we add two more methods:
Before beginning an optimization run, the EDA should call the method `initialize` of the model.
The model should then in an unbiased, initial state.
Before updating the model, a call to `minimumSamplesNeededForUpdate` returns the minimum number of samples required for a meaningful update.
If the number of selected individuals falls below this threshold, the algorithm could terminate or restart.

\repo.listing{lst:EDA}{An excerpt of the implementation of the Estimation of Distribution Algorithm.}{java}{src/main/java/aitoa/algorithms/EDA.java}{}{relevant}

A basic EDA can now be implemented as shown in [@lst:EDA].
In this implementation excerpt, we have omitted the checks to `minimumSamplesNeededForUpdate` some calls to the termination criterion as well as the initialization of variables, to provide more concise and readable code.

### Ingredient: A Stochastic Model for the JSSP Search Space

We now want to apply the EDA to our Job Shop Scheduling Problem.
Our search space represents solutions for the JSSP as a permutation of a multi-set, where each of the $\jsspJobs$&nbsp;jobs occurs exactly $\jsspMachines$&nbsp;times, once for each machine.
Unfortunately, this representation does not lend itself for stochastic modeling at all &ndash; we need a probability distribution over such permutations.
It should be said that there exist clever solutions&nbsp;[@CUML2015KOMMFSPBP] for this problem, but for our introductory book, they may be too complicated.

#### A First and Na&#239;ve Idea

We will follow a *very* na&#239;ve approach to apply the EDA idea to the JSSP.
The points in the search space are permutations with repetitions, integer vectors of length&nbsp;$\jsspJobs*\jsspMachines$.
At each index, there could be any of the $\jsspJobs$&nbsp;jobs.
We want to build a model by using $\mu$&nbsp;such vectors.
For each index $k\in0\dots(\jsspJobs*\jsspMachines-1)$, we could simply store how often each of the jobs&nbsp;$\jsspJobIndex$ occurred there in the $\mu$&nbsp;permutations in&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$.
This means our model&nbsp;$M$ consists of $\jsspJobs*\jsspMachines$ vectors, each holding&nbsp;$\jsspJobs$ numbers ranging from&nbsp;$0$ to&nbsp;$\mu$.
A&nbsp;$0$ at&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$ means that job&nbsp;$\jsspJobIndex$ never occurred at index&nbsp;$k$ in any of the $\mu$&nbsp;selected points, whereas a value of&nbsp;$\mu$ would mean that all solutions had job&nbsp;$\jsspJobIndex$ at index&nbsp;$k$.

When we sample a new point&nbsp;$\sespel$ from this model, we would process all the indices&nbsp;$k\in0\dots(\jsspJobs*\jsspMachines-1)$.
The probability of putting a job&nbsp;$\jsspJobIndex\in0\dots(\jsspJobs-1)$ at index&nbsp;$k$ into&nbsp;$\sespel$ should be roughly proportional to&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$.
In other words, if a job&nbsp;$\jsspJobIndex$ occurs often at index&nbsp;$k$ in the $\mu$&nbsp;selected solutions, which we used to build the model&nbsp;$M$, then it should also often occur there in $\lambda$&nbsp;new points we sample from&nbsp;$M$.
Of course, we will need to adher to the constraint that no job can occur more then $\jsspMachines$&nbsp;times.
While this indeed a na&#239;ve method with several shortcomings (which we will discuss later), it should work "in principle".

#### An Example of the Na&#239;ve Idea {#sec:eda:umda:jssp:example}

We illustrate the idea of this model update and sampling process by using our `demo` instance from [@sec:jsspDemoInstance] in [@fig:jssp_umda_example; @fig:jssp_umda_sampling].

![An example of how the model update and sampling in our na&#239;ve EDA could look like on the `demo` instance from [@sec:jsspDemoInstance]; we set $\mu=10$ and 1&nbsp;new point&nbsp;$\sespel$ is sampled. See also [@fig:jssp_umda_sampling].](\relative.path{jssp_umda_example.svgz}){#fig:jssp_umda_example width=95%}

The `demo` instance has $\jsspJobs=4$&nbsp;jobs that are processed on $\jsspMachines=5$&nbsp;machines.
The points in the search space thus have $\jsspMachines*\jsspJobs=20$&nbsp;decision variables.
We can build the model by considering each of the 20&nbsp;decision variables separately.
Their indices&nbsp;$k$ range from&nbsp;$0$ to&nbsp;$19$.

Assume that $\mu=10$&nbsp;such points have been selected.
In the upper part of [@fig:jssp_umda_example], we illustrate these ten points, marking the occurrences of job&nbsp;0 red, of job&nbsp;1 blue, of ob&nbsp;2 green, and leaving those of job&nbsp;3 black for clarity.
The model derived from the selected points is illustrated in the middle part.
It has one row for each job and one column for each decision variable index.
When looking at the first decision variable (index&nbsp;0), we find that job&nbsp;0 occurred twice in the selected points, job&nbsp;1 seven times, job&nbsp;3 once, and job&nbsp;2 never.
This is shown in the first column of the model.
The second column of the model stands for the jobs seen at index&nbsp;1.
Here, job&nbsp;0 was never encountered, job&nbsp;1 and job&nbsp;2 four times, and job&nbsp;3 twice.
These values are obtained by simply counting how often a given job&nbsp;ID appears at the same index in the $\mu=10$&nbsp;selected solutions.
The model can be built iteratively in about $\bigO{\mu*\jsspMachines*\jsspJobs}$&nbsp;steps.

![A clearer illustration of the example for sampling the model in our na&#239;ve EDA one time given in [@fig:jssp_umda_example].](\relative.path{jssp_umda_sampling.svgz}){#fig:jssp_umda_sampling width=95%}

An example for sampling one new point in the search space from this model is given in the lower part of [@fig:jssp_umda_example] and illustrated in complete detail in [@fig:jssp_umda_sampling].
From the model which holds the frequencies of each job for each index&nbsp;$k$, we now want to sample the points of length&nbsp;$\jsspMachines*\jsspJobs$.
In other words, based on the model, we need to decide which job to put at each index.
The more often a job occurred at a given index in the $\mu$&nbsp;selected points, the more likely we should place it there as well.
Naturally, we could iterate over all indices from $k=0$ to $k=(\jsspJobs*\jsspMachines-1)$ from beginning to end.
However, to increase the randomness, we process the indices in a random order.

Initially, the new point is empty.
In each step of the sampling process, one index&nbsp;$k$ is chosen uniformly at random from the not-yet-processed ones.
In our example, we first randomly picked&nbsp;$k=11$.
In the model&nbsp;$M$, we have $\arrayIndexx{M}{11}{0}=0$, because job&nbsp;0 never occurred at index&nbsp;11 in any of the $\mu=10$&nbsp;solutions used for building the model.
Because job&nbsp;1 was found at $k=11$ exactly once, $\arrayIndex{M}{11}{1}=1$.
Since job&nbsp;2 was found at $k=11$ 5&nbsp;times, $\arrayIndex{M}{11}{2}=5$.
And $\arrayIndex{M}{11}{3}=4$ because job&nbsp;3 was found four times at index&nbsp;11 in the selected individuals.
We find that $(\sum_{\jsspJobIndex=0}^3 \arrayIndex{M}{11}{\jsspJobIndex})=10=\mu$.
We want that the chance to sample job&nbsp;0 at the here should be 0%, the chance to choose job&nbsp;1 should be 10%, the chance to pick job&nbsp;2 should be 50%, and, finally, job&nbsp;3 should be picked with 40% probability.
This can be done by drawing a random number&nbsp;$R$ uniformly distributed in $0\dots9$.
If it happens to be&nbsp;0, we pick job&nbsp;1, if it is in $1\dots5$, we pick job&nbsp;2, and if it happens to be in $6\dots9$, we pick job&nbsp;3.
In our example, $R$&nbsp;happened to be&nbsp;3, so we set $\arrayIndex{\sespel}{11}=2$.

This can be implemented by writing a cumulative sum of the&nbsp;$\jsspJobs$ frequencies into an array&nbsp;$Q$ of length&nbsp;$\jsspJobs$.
We would get $Q=(0,1,6,10)$.
After drawing&nbsp;$R$, we can apply binary search to find the index of the smallest number $r\in Q$ which is larger than&nbsp;$R$.
Here, since $R=3$, $r=6$ and its zero-based index is $2$, i.e., we chose job&nbsp;2.

In the next step, we randomly choose&nbsp;$k$ from&nbsp;$0\dots 19 \setminus 11$.
We happen to obtain&nbsp;$k=0$.
We find $\arrayIndexx{M}{0}{0}=2$, $\arrayIndexx{M}{0}{1}=7$, $\arrayIndexx{M}{0}{2}=0$, and $\arrayIndexx{M}{0}{3}=1$.
We again draw a random number&nbsp;$R$ from $0\dots 9$, which this time happens to be&nbsp;6.
A value&nbsp;$R\in\{0,1\}$ would have led to choosing job&nbsp;0, but&nbsp;$R\in 2\dots 8$ leads us to pick job&nbsp;1 for index&nbsp;$k=1$ and we set $\arrayIndex{\sespel}{0}=1$.

The process is repeated an in step&nbsp;3, we randomly choose&nbsp;$k$ from&nbsp;$0\dots 19 \setminus \{11,0\}$.
We happen to pick&nbsp;$k=7$.
Only two different jobs were found in the selected individuals, namely nine times job&nbsp;0 and once job&nbsp;2.
We draw a random number&nbsp;$R$ from&nbsp;$0\dots 9$ again and obtained&nbsp;$R=6$, which leads us to set&nbsp;$\arrayIndex{\sespel}{7}=0$.

We repeat this again and again.
At step&nbsp;9, we this way chose job&nbsp;2 for the fifth time.
Since there are $\jsspMachines=5$ machines, this means that job&nbsp;2, placed at indices&nbsp;11, 2, 12, 3, and now&nbsp;2, is completed and cannot be chosen anymore &ndash; regardless what the model suggests.
For instance, in step&nbsp;11 (see [@fig:jssp_umda_sampling]), we chose $k=4$.
Job&nbsp;2 did occur four times at index&nbsp;4 in the selected individuals!
But since we already assigned it five times, it cannot be chosen here anymore.
Thus, we cannot use the probabilities 30%, 40%, and 30% for jobs&nbsp;1, 2, and&nbsp;3 as suggested by the model.
We have to deduce the already completed job&nbsp; and raise the probabilities of jobs&nbsp;1 and&nbsp;3 to 50% each accordingly.
We can still pick the job exactly as before, but instead using a random number&nbsp;$R$ from&nbsp;$0\dots 9$, we use one from&nbsp;$0\dots 5$ (because $3+3=6$).
As it turned out randomly to be&nbsp;$R=2$, it falls in the interval $0\dots 2$ where we would choose job&nbsp;1.
Hence, we set $\arrayIndex{\sespel}{4}=1$.

We continue this process and complete assigning job&nbsp;0 in step&nbsp;17, after which only either job&nbsp;1 or job&nbsp;3 remain as choices.
Job&nbsp;3 is assigned for the fifth time in step&nbsp;18, after which only job&nbsp;1 remains.
After twenty steps, the sampling is complete.
The resulting point&nbsp;$\sespel\in\searchSpace$ is shown at the bottom of [@fig:jssp_umda_example].

Of course, this was just one concrete example.
Every time we sample a new point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using our model&nbsp;$M$, the indices&nbsp;$k$ and numbers&nbsp;$R$ would be drawn randomly and probably would be very different.
But each time, we could hope to obtain results at least somewhat similar but yet slightly different from the $\mu$&nbsp;points that we have selected.

The complexity of the model sampling is&nbsp;$\bigO{\jsspJobs*\jsspMachines*(\jsspJobs+\ln{\jsspJobs})}$:
For each of the $\jsspJobs*\jsspMachines*$ indices&nbsp;$k$ into the new point&nbsp;$\sespel$, we need to add up the $\jsspJobs$&nbsp;frequencies stored in the model and then draw the random number&nbsp;$R$ (which can be done in&nbsp;$\bigO{1}$) and find the corresponding job index via binary search (which takes&nbsp;$\bigO{\ln{\jsspJobs}}$).

#### Shortcomings of the Na&#239;ve Idea

At first glance, it looks as if our approach might be a viable method to build and sample a model for our JSSP scenario.
But we are unlucky:
There is are two major shortcomings.

First, we might get into a situation where we have to pick a job which should have probability&nbsp;0 in our model, because all other jobs have already been assigned!
Let's take a look at index&nbsp;$k=5$ in [@fig:jssp_umda_example].
Here, $\arrayIndexx{M}{5}{1}=10$, whereas the measured frequency of all other jobs is zero.
In other words, our model prescribes that job&nbsp;1 must be placed at index&nbsp;5 into the new point&nbsp;$\sespel$, regardless of whatever other choice we made during the sampling process.
However, since we proceed randomly, it is entirely possible, however, that index $k=5$ is drawn later during the sampling process and job&nbsp;1 has already been assigned five times.

This situation can always occur if one of the values in&nbsp;$M$ for a given index&nbsp;$k$ is&nbsp;$0$.
We may always end up in a situation where we cannot finish sampling the new point because of it.

Getting a&nbsp;0 at an index&nbsp;$k$ for a job&nbsp;$\jsspJobIndex$ in the model&nbsp;$M$ also would mean that we *never* place job&nbsp;$\jsspJobIndex$ again at this index in any future iterations of our algorithm.
The EDA concept prescribes and alternation between building the model from the $\mu$&nbsp;selected solutions, then sampling a new set of $\lambda$&nbsp;solutions and choosing the $\mu<\lambda$&nbsp;best of them, and then building the model again from these.
If job&nbsp;$\jsspJobIndex$ is not placed at index&nbsp;$k$ during the sampling process (for whatever reason), then it cannot have a non-zero probability in the next model.
Thus, it would again not be placed at index&nbsp;$k$ &ndash; and this option would have disappeared forever in the optimization process.

We can combat this problem by changing our model building process a bit.
When counting, the frequencies of the jobs for a given index&nbsp;$k$ in the $\mu$&nbsp;selected points, we do not start at&nbsp;0 but at&nbsp;1.
This way, each job will always have non-zero probability.
Of course, for a small value of&nbsp;$\mu$, this would skew our distributions quite a bit towards randomness.
The solution is to not add&nbsp;1 for each encounter of a job, but a very large number, say 1'000'000.

At index&nbsp;$k=5$, we would then have $\arrayIndexx{M}{5}{1}=10*1'000'000$ and $\arrayIndexx{M}{5}{\jsspJobIndex}=1$ for&nbsp;$\jsspJobIndex\in\{0,2,3\}$.
In other words, all jobs have non-zero probability, but if we can place job&nbsp;1 at index&nbsp;$k=5$, then we will most likely do so.

The model sampling does not need to be changed in any way:
For each index&nbsp;$k$, we first sum up all the $\jsspJobs$&nbsp;numbers in the model and obtain a number&nbsp;$Z$.
For index&nbsp;$k=5$, we would obtain $Z=1'000'003$.
Then we sample a random number&nbsp;$R$ uniformly distributed from&nbsp;$0\dots Z-1$.
At index&nbsp;5, if $R=0$, we would pick job&nbsp;0.
If $R\in 1\dots1'000'000$, we would pick job&nbsp;1.
If $R=1'000'001$, we pick job&nbsp;2 and if $R=1'000'002$, we pick job&nbsp;3.
The binary search does not take any longer if the numbers we search are larger, so the problem is solved without causing any harm.

The situation remains that we cannot perfectly faithfully model and sample the selected points.
When approaching the end of the sampling of one new point, we are always likely to deviate from the observed job probabilities.
By randomizing the order in which we visit the indices&nbsp;$k$, which we already do, we try to at least distribute this "unfaithfulness" evenly over the whole length of the solutions in average.

The second big problem with this na&#239;ve idea is that it does not distinguish between, e.g., the first and the second occurrence of a job in the solutions we use to update the model from.
For instance, in [@fig:jssp_umda_example], we have two solutions that contain the first occurrence of job&nbsp;0 at index&nbsp;0 (namely solutions&nbsp;1 and&nbsp;3) and two solutions (2 and&nbsp;6) that contain it at index&nbsp;3.
There is no solution that contains the second occurrence of job&nbsp;0 at index&nbsp;3.
Yet, if we sample the model, we might well choose index&nbsp;0 for the first and index&nbsp;3 for the second occurrence of job&nbsp;0.
In other words, even if we could faithfully sample our model, we might still arrive at solutions that are completely different from those that we used to build it.
Darn.

The reader will understand that this chapter is already somewhat complex and we will have to leave it at this na&#239;ve approach.
As stated before, better models and methods exists, e.g., in&nbsp;[@CUML2015KOMMFSPBP].
The focus of the book, however, is to learn about different algorithms by attacking a problem with them in a more or less ad-hoc way, i.e., by doing what seems to be a reasonable first approach.
The idea proposed here, to me, seems to be something like that.

#### Implementation of the Na&#239;ve Idea

We can now implement our model and we do this in the class `JSSPUMDAModel`.
We call it `UMDA` model because it the probability of choosing one value for a given decision variable assigned by the model only depends on the values of only that variable in the solutions used for building the model &ndash; and the first EDA doing something like that was the Univariate Marginal Distribution Algorithm (UMDA)&nbsp;[@MP1996FROGTTEODIBP; @MM2002MAOEAFO].
The model can be stored in a two-dimensional array of type `long[n*m][n]`.
Here, we discuss the code for model building and model sampling in [@lst:edaModel:jssp:building; @lst:edaModel:jssp:sampling], respectively.

\repo.listing{lst:edaModel:jssp:building}{The building process of our na&#239;ve model for the JSSP in EDAs.}{java}{src/main/java/aitoa/examples/jssp/JSSPUMDAModel.java}{}{update}

We realize the model building by implementing the routine `IModel.update` (see [@lst:edaModel]) in [@lst:edaModel:jssp:building].
We first initialize the complete model matrix&nbsp;$M$ to all&nbsp;$1$ values.
We then process each selected point in the search space from beginning to end.
If a job is encountered at an index&nbsp;$k$, we add a value `this.m_base` to the corresponding cell of the matrix.
While allowing `this.base` to be set as a configuration parameter, we use `Integer.MAX_VALUE` by default.
This means that jobs not encountered at a certain index&nbsp;$k$ in the selected individuals will only be placed there during the sampling process if all other jobs have already been scheduled $\jsspMachines$&nbsp;times.

\repo.listing{lst:edaModel:jssp:sampling}{The sampling process of our na&#239;ve model for the JSSP in EDAs.}{java}{src/main/java/aitoa/examples/jssp/JSSPUMDAModel.java}{}{sampling}

The routine `IModel.apply` is implemented in [@lst:edaModel:jssp:sampling].
It starts by picking the full set of jobs and permitting $\jsspMachines$&nbsp;occurrences for each.
It then shuffles the array of indices.
Processing this array from front to end then means picking all values for&nbsp;$k$ in a random order.
For each index&nbsp;$k$, it fills an array&nbsp;`N` with the cumulative sum of the (modified) encounter frequencies of the jobs that are not finished.
The random number&nbsp;$R$ is then drawn and its location in&nbsp;`N` is determined.
From this, we know the selected job.
The job is placed into the new solution and the number of remaining times it can be placed is reduced.
If the number reaches&nbsp;$0$, the job is removed from the set of selectable jobs.
This is repeated until the destination point is completed.
This implements the process discussed in the previous section.

### The Right Setup

We again do a similar setup experiment as we did for the EA in [@sec:eaNoCrSetup] to configure our EDA.
The setup `umda_3_32768`, which, in each iteration, samples $\lambda=32768$&nbsp;new solutions and uses the $\mu=3$&nbsp;best of them to update the model, seems to yield the best performance in average.
We also try apply clearing in the objective space discussed in [@sec:eaClearingInObjectiveSpace] in the EDA.
Clearing removes candidate solutions with duplicate makespan value before the model update.
This is done by simply applying the routine specified in [@lst:UtilsClearing] before the selection step into our algorithm.
The implementation of the `EDAWithClearing` thus is almost the same as the basic `EDA` implementation in [@lst:EDA] and both are given in the online repository.
After another setup experiment, we identify the best setup of our UMDA-EDA with clearing for the JSSP.
In each iteration, it samples $\lambda=64$&nbsp;new candidate solutions and keeps the $\mu=2$&nbsp;unique best of them.
We will call this setup `umdac_2+64`.

### Results on the JSSP {#sec:eda:jssp:results}

In [@tbl:jssp_edac_results], we compare the performance on the JSSP of both EDA variants to the best stochastic hill climber with restarts, namely `hcr_65536_nswap`.
We can find that the UMDA without clearing is generally worse than the hill climber, while the `umdac_2+64` with clearing can perform somewhat better on `abz7` and `yn4`.
On `swv15`, both algorithms perform particularly badly.
The performance of our adaptation of the EDA concept towards the JSSP is not very satisfying.

\relative.input{jssp_edac_results.md}

: The results of the EDAs `umda_3_32768` (without clearing) and `umdac_2+64` (with clearing) in comparison to `hcr_65536_nswap`. The columns present the problem instance, lower bound, the algorithm, the best, mean, and median result quality, the standard deviation&nbsp;*sd* of the result quality, as well as the median time *med(t)* and FEs *med(FEs)* until the best solution of a run was discovered. The better values are **emphasized**. {#tbl:jssp_edac_results}

In [@tbl:jssp_edac_results] we make an interesting observation:
It seems that the EDAs have a much lower median number of FEs *med(FEs)* until discovering their end result compared to the hill climber, while the time *med(t)* they need for these FEs does not tend to be lower at all.
The time that our EDA needs to create and evaluate one candidate solution, to perform one objective function evaluation (one&nbsp;FE), is higher compared to the hill climber.
For instance the 1'901'332&nbsp;FEs within 93&nbsp;seconds of `umda_3_32768` on `abz7` equal roughly 20'450&nbsp;FEs/s, whereas the hill climber `hcr_65536_nswap` can generate 21'189'358&nbsp;candidate solutions within 96&nbsp;seconds, i.e., achieves 220'700&nbsp;FEs/s on the same problem, which is roughly ten times as much.
On `swv15`, the hill climber converges to its final result within 89&nbsp;seconds, during which it performs 10'783'296&nbsp;FEs, i.e., 12'1000&nbsp;FEs/s.
Here, `umdac_2+64` is 13&nbsp;times slower and performs 859'250&nbsp;FEs in 94&nbsp;seconds, i.e., 9140&nbsp;FEs/s.

Let us therefore compare two perspectives on the progress that EDAs make with what our EAs are doing.
In [@fig:jssp_progress_edac_log], we plot the progress over (log-scaled) time in milliseconds as we did before.
This perspective fits to our goal, to obtain good solutions for the JSSP within three minutes.
The `umda_32768` behaves somewhat similar to the `ea_32768_nswap`, which also creates $\lambda=32768$ new solutions in each generations, but is generally slower and finishes at worse results.
The gap between `umdac_2+64` and `eac_4+5%_nswap`, which both apply clearing, is much wider.

![The median of the progress of the&nbsp;`ea_32768_nswap`, `eac_4+5%_nswap`, `umda_32768`, and&nbsp;`umdac_2+64` algorithms over **time**, i.e., the current best solution found by each of the&nbsp;101 runs at each point of time (over a logarithmically scaled time axis). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_edac_log.svgz}){#fig:jssp_progress_edac_log width=84%}

![The median of the progress of the&nbsp;`ea_32768_nswap`, `eac_4+5%_nswap`, `umda_32768`, and&nbsp;`umdac_2+64` algorithms over **the consumed FEs**, i.e., the current best solution found by each of the&nbsp;101 runs at each point of FE (over a logarithmically scaled time FE). The color of the areas is more intense if more runs fall in a given area.](\relative.path{jssp_progress_edac_fes_log.svgz}){#fig:jssp_progress_edac_fes_log width=84%}

Now we take a look at the same diagrams, but instead of the actual consumed clock time, we use the number of generated solutions as horizontal time axis.
This basically shows us the progress that the algorithms make per call to the objective function, i.e., per&nbsp;FE.
This perspective is very useful in many theoretical scenarios and also justified in scenarios where the FEs take a very long time (see later in [@sec:comparing:time:FEs]).

[@fig:jssp_progress_edac_fes_log] shows a very different picture.
`umda_32768` actually has a better median solution quality than `ea_32768_nswap`, but it stops much earlier and then is overtaken.
Only on `la24`, the plain EA overtakes the plain EDA before the EDA stops.
With the exception of instance `swv15`, the gap between `umdac_2+64` and `eac_4+5%_nswap` also becomes smaller.

Of course we cannot really know whether the EDA would eventually reach better solutions than the EA if it perform the same number of FEs.
We could find this out with more experiments, maybe with runtime limits of 30&nbsp;minutes instead of three.
We will not do this here, as our scenario has a hard time limit.

What we found out is still interesting:
Even the trivial, na&#239;ve model for the JSSP seems to "work," despite its shortcomings.
The biggest problem here seems to be the algorithmic time complexity of the model sampling process.
The `1swap` or `nswap` operators in the EA copy the original point in the search space&nbsp;$\searchSpace$ and then swap one or multiple jobs.
To generate a new point in&nbsp;$\searchSpace$, they thus require a number of algorithm steps roughly proportional to&nbsp;$\jsspJobs*\jsspMachines$.
As discussed at the end of [@sec:eda:umda:jssp:example], our UMDA model needs&nbsp;$\bigO{\jsspJobs*\jsspMachines*(\jsspJobs+\ln{\jsspJobs})}$ steps for this.
The higher complexity of sampling the search space here clearly shows.

### Summary

In this chapter, we have discussed the concept of Estimation of Distribution Algorithms (EDAs): the idea of learning statistical models of good solutions.
Models can be probability distributions, which assign higher probability densities to areas where good previously observed solutions were located.
In each "generation", we can sample $\lambda$&nbsp;points in the search space using this model/distribution and then use the best $\mu$&nbsp;of these samples to update the model.
What we hopefully gain are two things: better solutions, but also a better model, i.e., an abstract representation of what good solutions look like in general.

This concept lends itself to many domains.
Already in high school we learned probability distributions over real numbers.
It is very straightforward to adapt the idea of EDAs to subsets of the $n$-dimensional Euclidean space, which we did as introductory example in [@fig:real_coded_umda_example].
The concept also sends itself if the our search space are vectors of bits, which is the domain where the original Univariate Marginal Distribution Algorithm (UMDA)&nbsp;[@MP1996FROGTTEODIBP; @MM2002MAOEAFO] was applied.

Unfortunately for the author of the book, probability distributions over permutations are a much harder nut to crack.
As mentioned before, we tried a very na&#239;ve approach to this with several flaws &ndash; but we got it to work.
Some of the flaws of our approach could also be fixed:
The fact that the model does not distinguish between the first and second occurrence of a job ID can be fixed by using unique operation IDs instead of job IDs, i.e., using $\jsspMachines*\jsspJobs$ unique values for each location in the model instead of only $\jsspJobs$ ones.
I tried this out, but it does not lead to tangibly better results within our three minute budget.
Most likely because it makes the sampling of new solutions even slower and thus decreases the total number of search steps we can do in total even more&hellip;

And this brings us two unexpected lessons to learn from this section:
First, algorithmic time complexity does matter.
Well, every computer scientist knows this.
Professors do not bother undergraduate students with this topic for fun.
But here we are reminded that efficiently implementing algorithms is important, also in the field of randomized metaheuristics.
If we were to invent a very strong optimization approach but would not be able to implement it with low complexity, then it could be infeasible in practice.

The second lesson is that comparing algorithm performance using FEs could yield different results from comparing them based on clock time.
Both have different advantages which we discuss in detail in [@sec:comparing:time:FEs], but we need to always be clear which one is more important in our scenario.
In our scenario here, clock time is more important.

So was this all what is to say about EDAs?
No.
The EDAs we discussed here are very simple.
There are at least two aspects that we did not cover here:

One aspect that we did not discuss here is that our model&nbsp;$M$ is actually not *updated* but *overwritten* in each generation.
Instead, we could also combine the new information&nbsp;$M_{new}$ with the current model&nbsp;$M_{old}$ the model&nbsp;$M$ in.
The UMDA implementation in&nbsp;[@MP1996FROGTTEODIBP] and the equivalent Population-based Incremental Learning Algorithm (PBIL)&nbsp;[@B1994PBILAMFIGSBFOACL; @BC1995RTGFTSGA], for instance, do this by simply setting $M=\delta M_{new} + (1-\delta)M_{old}$, where $\delta\in(0,1]$&nbsp;is a learning rate.
Another interesting approach to such iterative learning is the Compact Genetic Algorithm (cGA)&nbsp;[@HLG1999TCGA].

The second aspect is that we treated all decision variables as if they were independent in our model.
This is where the *univariate* in UMDA comes from.
However, variables are hardly independent in practical problems (see also [@sec:epistasis]).
For instance, the decision whether I should *next* put job&nbsp;1 on machine&nbsp;2 or job&nbsp;3 in the JSSP will likely depend on which job I assigned to which machine *just now*.
Such inter-dependencies between decision variables can be represented by *multivariate* distributions.
Examples for algorithms trying to construct such models are the Bayesian Optimization Algorithm (BOA)&nbsp;[@PGCP1999BTBOA; @PGCP2000LPDEABN] for bit strings.
The Covariance Matrix Adaptation Evolutionary Strategy (CMA-ES)&nbsp;[@HMK2003RTTCOTDESWCMAC; @AH2005ARCESWIPS] learns the relationship between pairs of variables for continuous problems in the Euclidean space.
It is basically the state-of-the-art for complicated numerical optimization problems.
