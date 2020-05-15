## Estimation of Distribution Algorithms {#sec:edas}

Estimation of Distribution Algorithms (EDAs)&nbsp;[@MP1996FROGTTEODIBP; @M1997TEFRTSAIUFP; @LL2002EODAANTFEC; @LLIB2006TANECAOEODA] follow a completely different paradigm than the algorithms we have discussed so far.
So far, we have focused on the points&nbsp;$\sespel$ inside the search space&nbsp;$\searchSpace$.
We tried to somehow "navigate" from one or multiple such points to better points, by investigating their neighbors via the unary operator or trying to find "intermediate" locations (via the binary operator).
EDAs instead more look at the space&nbsp;$\searchSpace$ itself and ask
"Can we somehow learn which areas in&nbsp;$\searchSpace$ are promising?
Can we learn how good solutions look like?" 

### The Algorithm Idea

How do good solutions look like?
It is unlikely that good (or even optimal) solutions are uniformly distributed over the search space.
If the optimization problem that we are trying to solve is reasonable, then it should have some structure and there will be areas in the search space&nbsp;$\searchSpace$ that are more likely to contain good solutions than others.
*Distribution* here is already an important key word:
There should be some kind of (non-uniform) probability distribution of good solutions over the search space.
If we can somehow learn this distribution, we obtain a *model* of how good solutions look like.
Then we could *sample* this distribution/model.
Sampling a distribution just means to create random points according to it:
If we sample&nbsp;$\lambda$ points from a distribution&nbsp;$M$, then more points will be created in areas where $M$ has a high probability density and fewer points from places where it has a low probability density.

A basic EDA works roughly as follows:

1. Set the best-so-far objective value&nbsp;$\bestSoFar{\obspel}$&nbsp;to&nbsp;$+\infty$ and the best-so-far candidate solution&nbsp;$\bestSoFar{\solspel}$ to&nbsp;`NULL`.
2. Initialize the model&nbsp;$M_0$ to approximate a uniform distribution.
3. Create $\lambda>2$ random points&nbsp;$\sespel$ uniformly distributed in the search space&nbsp;$\searchSpace$.
4. Repeat until termination criterion is met (where $i$ be the iteration index):
   a. Map the $\lambda$&nbsp;points to candidate solutions&nbsp;$\solspel\in\solutionSpace$ using the representation mapping&nbsp;$\repMap:\searchSpace\mapsto\solutionSpace$ and evaluate their objective value&nbsp;$\obspel=\objf(\solspel)$.
   b. $\solspel'$ be the best of the $\lambda$&nbsp;candidate solutions and $\obspel'$ its objective value.
      If $\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\solspel'$ in&nbsp;$\bestSoFar{\solspel}$ and&nbsp;$\obspel'$ in&nbsp;$\bestSoFar{\obspel}$.
   c. Select the $\mu$&nbsp;best points from the set of $\lambda$&nbsp;points (with&nbsp;$1<\mu<\lambda$).
   d. Use the set&nbsp;$P_\mu$ of these $\mu$&nbsp;points to build the new model&nbsp;$M_i$.
      This step can also be implemented as model update&nbsp;$U$ and make use of the information in the old model&nbsp;$M_{i-1}$ as well as the problem instance&nbsp;$\instance$, i.e., $M_i=U(P_\mu, M_{i-1}, \instance)$.
   e. Sample $\lambda$&nbsp;points from&nbsp;$M_i$.
5. Return the candidate solution&nbsp;$\bestSoFar{\solspel}$ and its objective value&nbsp;$\bestSoFar{\obspel}$ to the user.

This structure looks different from what we had before, but we can recognize some familiar components.
The algorithm starts by creating a set of $\lambda$&nbsp;random points in the search space by using a nullary search operator, very much like EAs (see [@sec:evolutionaryAlgorithm]) do.
From these $\lambda$&nbsp;points, the set&nbsp;$P_\mu$ of the $\mu$&nbsp;best ones are selected -- again, very similar to EAs.
However, EDAs do not apply unary or binary search operations to these points to obtain an offspring generation.
Instead, they condense the information from the selected points into a model&nbsp;$M$, which usually is a stochastic distribution.
This can be done by estimating the parameters of a stochastic distribution from all points in&nbsp;$P_\mu$.
We then can create the $\lambda$&nbsp;new points by sampling them from this parameterized distribution&nbsp;$M$.

#### An Example

Maybe it is easier to understand how this algorithm works if we look at the simple example illustrated in [@fig:real_coded_umda_example].
Imagine you are supposed to find the minimum of an objective function&nbsp;$f$ defined over a two-dimensional sub-space space of the real numbers, i.e., $\solutionSpace\subset\realNumbers^2$.
For the sake of simplicity, let's assume the search and solution space are the same ($\searchSpace=\solutionSpace$) and its two dimensions be $x1$ and $x2$.
The objective function is illustrated in the top-left corner of [@fig:real_coded_umda_example].
It has a nice basin with good solutions, but also is a bit rugged.  

![An example of how we could apply an EDA to an objective function&nbsp;$f$ defined over a two-dimensional search/solution space. In each iteration $i>1$, 101&nbsp;points are sampled and the best 41&nbsp;are used to derive a model $M$, which is defined as a normal distribution parameterized by the arithmetic means and standard devisions of the selected points along the two axes.](\relative.path{real_coded_umda_example.svgz}){#fig:real_coded_umda_example width=95%}

At the beginning of our EDA, we just generate $\lambda=101$&nbsp;points uniformly distributed in the search space (as prescribed by *step&nbsp;3* of our algorithm).
This is illustrated in the top-right sub-figure of [@fig:real_coded_umda_example], where we only show two dimensions but put the contour of the objective function in the background.
From the $\lambda$&nbsp;points, we keep the $\mu=41$&nbsp;ones with the best objective values (colored green) and discarded the other $101-41=60$&nbsp;points (colored red).
We can now compute the mean and standard deviation of the $\mu$&nbsp;selected points along each axis, i.e., get four parameters.
In the figures, these models are illustrated in blue.
In their center, i.e., at the two mean coordinates, you can find a little blue cross.
From the blue cross, one line along each axis, with the length of the corresponding standard deviation, forming the two axes of an ellipse.
We can see that the ellipse is located nicely in the center of the area, where we indeed can find solutions which tend to have smaller (better) objective values.

But what can we do with this model?
We can use it to generate $\lambda$&nbsp;new points.
Since we are in the continuous, a normal distribution lends itself for this purpose.
A one-dimensional normal distribution has the feature that it gives high probability to values close to its mean.
The probability of encountering points farther away from the mean decreases quickly.
If we sample a normal distribution with a given mean and standard deviation, then most points will located within one standard deviation distance from the mean.
Since we have two means and two standard deviations, we could just use one independent normal distribution for each coordinate.

In the second sub-figure from the top on the right hand side of [@fig:real_coded_umda_example], we did exactly that.
As can be seen, the points are located more closely to the center of the figure.
We again select the best $\mu=41$&nbsp;points of the $\lambda=101$&nbsp;samples obtained this way and build new model based on them.
The standard deviations of the model are smaller now.
We repeat this process for two more steps and tend to get points more closely to the optimum of&nbsp;$f$ and models which better represent this characteristic.

Of course, this was just an example.
We could have chosen different probability distributions as model instead of the normal distribution.
We could have updated the model in a different way, e.g., combine the previous model with the new parameters.
Also we treated the two dimensions of our search space as independent, which may not hold in many scenarios.
And if our search space is not continuous, we may need to use a completely different type of model.

#### An Implementation

What we first need in order to implement EDAs is an interface to represent the new structural component: a model.

\repo.listing{lst:edaModel}{An excerpt of the interface of models that can be used in Estimation of Distribution Algorithms.}{java}{src/main/java/aitoa/structure/IModel.java}{}{relevant}

[@lst:edaModel] gives an idea how a very general interface for the required new functionality could look like.
The search space&nbsp;$\searchSpace$ is represented by the generic parameter&nbsp;`X`.
In our previous example, it could be equivalent the `double[2]`.
The model used in our example would hold four `double` values, namely the means and standard deviations along both dimensions. 

We can update the model by passing $\mu$&nbsp;samples from the search space `X` to the `update` method.
The source for these samples can be any `Java` collection (all of which implement `Iterable`).
In our example in the previous section, the `update` method could iterate over the `double[2]` values provided to it and compute, for both of their dimensions, the means and standard deviations.

Then, we can call `sample` $\lambda$ times to, well, sample the model and generate a new points in the search space.
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
Unfortunately, this representation does not lend itself for stochastic modeling &ndash; we would need a probability distribution over such permutations.
It should be said that there exist clever solutions&nbsp;[@CUML2015KOMMFSPBP], but for our introductory book, they may be too complex.

#### The Na&#239;ve Idea

We will follow a na&#239;ve approach.
The points in the search space are permutations with repetitions, integer vectors of length&nbsp;$\jsspJobs*\jsspMachines$.
At each index, there could be any of the $\jsspJobs$&nbsp;jobs.
We want to build a model by using $\mu$&nbsp;such vectors.
For each index $k\in0\dots(\jsspJobs*\jsspMachines-1)$, we could simply store how often each of the jobs&nbsp;$\jsspJobIndex$ occurred there in the $\mu$&nbsp;permutations in&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$.
This means our model&nbsp;$M$ consists of $\jsspJobs*\jsspMachines$ vectors, each holding&nbsp;$\jsspJobs$ numbers ranging from&nbsp;$0$ to&nbsp;$\mu$.
A&nbsp;$0$ at&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$ means that job&nbsp;$\jsspJobIndex$ never occurred at index&nbsp;$k$ in any of the $\mu$&nbsp;selected points, whereas a value of&nbsp;$\mu$ would mean that all solutions had job&nbsp;$\jsspJobIndex$ at index&nbsp;$k$.

When we sample a new point&nbsp;$\sespel$ from this model, we would process all the indices&nbsp;$k\in0\dots(\jsspJobs*\jsspMachines-1)$.
The probability of putting a job&nbsp;$\jsspJobIndex\in0\dots(\jsspJobs-1)$ at index&nbsp;$k$ into&nbsp;$\sespel$ should be roughly proportional to&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$.
In other words, if a job&nbsp;$\jsspJobIndex$ occurs often at index&nbsp;$k$ in the $\mu$&nbsp;selected solutions, which we used to build the model&nbsp;$M$, then it should also often occur there in $\lambda$&nbsp;new points we sample from&nbsp;$M$.
While this indeed a na&#239;ve method with shortcomings (which we will discuss later), it should work "in principle".

#### An Example
 
We illustrate the model update and sampling process by using our `demo` instance from [@sec:jsspDemoInstance] in [@fig:jssp_umda_example; @fig:jssp_umda_sampling].

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
In our example, $R$ happened to be&nbsp;3, so we set $\arrayIndex{\sespel}{11}=2$.

This can be implemented by writing a cumulative sum of the&nbsp;$\jsspJobs$ frequencies into an array $Q$ of length&nbsp;$\jsspJobs$.
We would get $Q=(0,1,6,10)$.
After drawing $R$, we can apply binary search to find the index of the smallest number $r\in Q$ which is larger than $R$.
Here, since $R=3$, $r=6$ and its zero-based index is $2$, i.e., we chose job&nbsp;2.

In the next step, we randomly choose $k$ from $0\dots 19 \setminus 11$.
We happen to obtain&nbsp;$k=0$.
We find $\arrayIndexx{M}{0}{0}=2$, $\arrayIndexx{M}{0}{1}=7$, $\arrayIndexx{M}{0}{2}=0$, and $\arrayIndexx{M}{0}{3}=1$.
We again draw a random number&nbsp;$R$ from $0\dots 9$, which this time happens to be&nbsp;6.
A value $R\in\{0,1\}$ would have led to choosing job&nbsp;0, but $R\in 2\dots 8$ leads us to pick job&nbsp;1 for index&nbsp;$k=1$ and we set $\arrayIndex{\sespel}{0}=1$.

The process is repeated an in step&nbsp;3, we randomly choose $k$ from $0\dots 19 \setminus \{11,0\}$.
We happen to pick&nbsp;$k=7$.
Only two different jobs were found in the selected individuals, namely nine times job&nbsp;0 and once job&nbsp;2.
We draw a random number $R$ from $0\dots 9$ again and obtained&nbsp;$R=6$, which leads us to set $\arrayIndex{\sespel}{7}=0$.

We repeat this again and again.
At step&nbsp;9, we this way chose job&nbsp;2 for the fifth time.
Since there are $\jsspMachines=5$ machines, this means that job&nbsp;2, placed at indices 11, 2, 12, 3, and now&nbsp;2, is completed and cannot be chosen anymore &ndash; regardless what the model suggests.
For instance, in step&nbsp;11 (see [@fig:jssp_umda_sampling]), we chose $k=4$.
Job&nbsp;2 did occur four times at index&nbsp;4 in the selected individuals!
But since we already assigned it five times, it cannot be chosen here anymore.
Thus, we cannot use the probabilities 30%, 40%, and 30% for jobs&nbsp;1, 2, and&nbsp;3 as suggested by the model.
We have to deduce the already completed job&nbsp; and raise the probabilities of jobs&nbsp;1 and&nbsp;3 to 50% each accordingly.
We can still pick the job exactly as before, but instead using a random number&nbsp;$R$ from $0\dots 9$, we use one from $0\dots 5$ (because $3+3=6$).
As it turned out randomly to be $R=2$, it falls in the interval $0\dots 2$ where we would choose job&nbsp;1.
Hence, we set $\arrayIndex{\sespel}{4}=1$.

We continue this process and complete assigning job&nbsp;0 in step&nbsp;17, after which only either job&nbsp;1 or job&nbsp;3 remain as choices.
Job&nbsp;3 is assigned for the fifth time in step&nbsp;18, after which only job&nbsp;1 remains.
After twenty steps, the sampling is complete.
The resulting point&nbsp;$\sespel\in\searchSpace$ is shown at the bottom of [@fig:jssp_umda_example].

Of course, this was just one concrete example.
Every time we sample a new point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using our model&nbsp;$M$, the indices&nbsp;$k$ and numbers&nbsp;$R$ would be drawn randomly and probably would be very different.
But each time, we could hope to obtain results at least somewhat similar but yet slightly different from the $\mu$&nbsp;points that we have selected.

The complexity of the model sampling is $\bigO{\jsspJobs*\jsspMachines*(\jsspJobs+\ln{\jsspJobs})}$:
For each of the $\jsspJobs*\jsspMachines*$ indices&nbsp;$k$ into the new point&nbsp;$\sespel$, we need to add up the $\jsspJobs$&nbsp;frequencies stored in the model and then draw the random number&nbsp;$R$ (which can be done in&nbsp;$\bigO{1}$) and find the corresponding job index via binary search (which takes&nbsp;$\bigO{\ln{\jsspJobs}}$).

#### Shortcomings and Fix

At first glance, it looks as if our approach might be a viable method to build and sample a model for our JSSP scenario.
But we are unlucky:
There is one major shortcoming:
We might get into a situation where we have to pick a job which should have probability&nbsp;0 in our model, because all other jobs have already been assigned!

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

The reader will understand that this chapter is already somewhat complex and we will have to leave it at this n&#239;ve approach.
As stated before, better models and methods exists, e.g., in&nbsp;[@CUML2015KOMMFSPBP].
The focus of the book, however, is to learn about different algorithms by attacking a problem with them in a more or less ad-hoc way, i.e., by doing what seems to be a reasonable first approach.
The idea proposed here, to me, seems to be something like that.

#### Implementation

We can now implement our model and we do this in the class `JSSPUMDAModel`.
The model can be stored in a two-dimensional array of type `long[n*m][n]`.
Here, we discuss the code for model building and model sampling in [@lst:edaModel:jssp:building; @lst:edaModel:jssp:sampling], respectively.

\repo.listing{lst:edaModel:jssp:building}{The building process of our n&#239;ve model for the JSSP in EDAs.}{java}{src/main/java/aitoa/examples/jssp/JSSPUMDAModel.java}{}{update}

We realize the model building by implementing routine of `IModel.update` (see [@lst:edaModel]) in [@lst:edaModel:jssp:building].
We first initialize the complete model matrix $M$ to all $1$ values.
We then process each selected point in the search space from beginning to end.
If a job is encountered at an index&nbsp;$k$, we add a value `this.m_base` to the corresponding cell of the matrix.
While allowing `this.m_base` to be set as a configuration parameter, we use `Integer.MAX_VALUE` by default.
This means that jobs not encountered at a certain index&nbsp;$k$ in the selected individuals will only be placed there during the sampling process if all other jobs have already been scheduled $\jsspMachines$&nbsp;times.

\repo.listing{lst:edaModel:jssp:sampling}{The sampling process of our n&#239;ve model for the JSSP in EDAs.}{java}{src/main/java/aitoa/examples/jssp/JSSPUMDAModel.java}{}{sampling}

The routine `IModel.sample` is implemented in [@lst:edaModel:jssp:sampling].
It starts by picking the full set of jobs and permitting $\jsspMachines$&nbsp;occurences for each.
It then shuffles the array of indices.
Processing this array from front to end then means picking all values for&nbsp;$k$ in a random order.
For each index&nbsp;$k$, it fills an array `N` with the cumulative sum of the (modified) encounter frequencies of the jobs that are not finished.
The random number&nbsp;$R$ is then drawn and its location in&nbsp;`N` is determined.
From this, we know the selected job.
The job is placed into the new solution and the number of remaining times it can be placed is reduced.
If the number reaches&nbsp;$0$, the job is removed from the set of selectable jobs.
This is repeated until the destination point is completed.
This implements the process discussed in the previous section.
