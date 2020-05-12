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

We will follow a na&#239;ve approach.
The points in the search space are permutations with repetitions, integer vectors of length&nbsp;$\jsspJobs*\jsspMachines$.
At each index, there could be any of the $\jsspJobs$&nbsp;jobs.
We want to build a model by using $\mu$&nbsp;such vectors.
For each index $k\in0\dots(\jsspJobs*\jsspMachines-1)$, we could simply store how often each of the jobs&nbsp;$\jsspJobIndex$ occurred there in the $\mu$&nbsp;permutations in&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$.
This means our model&nbsp;$M$ consists of $\jsspJobs*\jsspMachines$ vectors, each holding&nbsp;$\jsspJobs$ numbers ranging from&nbsp;$0$ to&nbsp;$\mu$.
A&nbsp;$0$ at&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$ means that job&nbsp;$\jsspJobIndex$ never occurred at index&nbsp;$k$ in any of the $\mu$&nbsp;selected points, whereas a value of&nbsp;$\mu$ would mean that all solutions had job&nbsp;$\jsspJobIndex$ at index&nbsp;$k$.

When we sample a new point&nbsp;$\sespel$ from this model, we would process all the indices&nbsp;$k\in0\dots(\jsspJobs*\jsspMachines-1)$.
The probability of putting a job&nbsp;$\jsspJobIndex\in0\dots \jsspJobs$ at index&nbsp;$k$ into&nbsp;$\sespel$ should be roughly proportional to&nbsp;$\arrayIndexx{M}{k}{\jsspJobIndex}$.
In other words, if a job&nbsp;$\jsspJobIndex$ occurs often at index&nbsp;$k$ in the $\mu$&nbsp;selected solutions, which we used to build the model&nbsp;$M$, then it should also often occur there in $\lambda$&nbsp;new points we sample from&nbsp;$M$.

While this indeed a na&#239;ve method with shortcomings (which we will discuss later), it should work "in principle". 
We illustrate the model update and sampling process by using our `demo` instance from [@sec:jsspDemoInstance] in [@fig:jssp_umda_example].

![An example of how the model update and sampling in our na&#239;ve EDA could look like on the `demo` instance from [@sec:jsspDemoInstance]; we set $\mu=10$ and 1&nbsp;new point&nbsp;$\sespel$ is sampled.](\relative.path{jssp_umda_example.svgz}){#fig:jssp_umda_example width=95%}
