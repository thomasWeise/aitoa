## Metaheuristics: Why do we need them?

The main topic of this book will be metaheuristic optimization (although I will eventually also discuss some other methods (remember: work in progress)).
So why do we need metaheuristic algorithms?
Why should you read this book?

### Good Solutions within Acceptable Time {#sec:approximationOfTheOptimum}

The first and foremost reason is that they can provide us good solutions within reasonable time.

It is easy to understand that there are some problems which are harder to solve than others.
Everyone of us already knows this from the mathematics classes in school.
Of course, the example problems discussed before cannot be attacked as easily as solving a single equation.
They require algorithms, they require computer science.

Unfortunately, while we have learned many types of equations that can be solved easily in our mathematics classes, theoretical computer science shows that for many problems, the time we need to find the best-possible solution can grow exponentially with the number of involved variables in the worst case.
(The number of involved variables here could be the number of cities in a TSP, the number of jobs or machines in a JSSP, or the number of objects to pack in a, well, packing problem.)
A big group of such complicated problems are called [\NPhard](https://en.wikipedia.org/wiki/NP-hardness)&nbsp;[@LLRKS1993SASAAC; @CPW1998AROMSCAAA].
In other words, unless some [fundamentally breakthrough happens](http://en.wikipedia.org/wiki/P_versus_NP_problem)&nbsp;[@C1971TCOTPP; @K1972RACP], there will be many problems which we cannot solve exactly within reasonable time.

![The growth of different functions in a log-log scaled plot. Exponential functions grow very fast, so that an algorithm which needs&nbsp;$\sim 2^s$ steps to solve an optimization problem of size&nbsp;$s$ quickly becomes infeasible. (compare with [@tbl:jsspSolutionSpaceTable] and [@tbl:jsspSearchSpaceTable])](\relative.path{function_growth.svgz}){#fig:function_growth width=99%}

[@fig:function_growth] illustrates that finding the solutions for problems with such exponential "time complexity" will quickly become infeasible, even for relatively small problem instances.
Just throwing more computing power at the problems will not solve this fundamental issue.
Our processing power is limited and parallelization can provide a linear speed-up at best.
This cannot mitigate the exponentially growing runtime requirements of many optimization problems.
Unfortunately, the example problems discussed so far are amongst this kind of problem.

So what can we do to solve such problems?
The exponential time requirement occurs if we make *guarantees* about the solution quality, especially about its optimality, over all possible scenarios.
What we can do, therefore, is that we can trade-in the *guarantee* of finding the best possible solution for lower runtime requirements.
We can use algorithms from which we hope that they find a good *approximation* of the optimum, i.e., a solution which is very good with respect to the objective function, but which do not *guarantee* that their result will be the best possible solution.
We may sometimes be lucky and even find the optimum, while in other cases, we may get a solution which is close enough.
And we will get this within acceptable time limits.

![The trade-off between solution quality and runtime.](\relative.path{runtime_quality_tradeoff.svgz}){#fig:runtime_quality_tradeoff width=90%}

In [@fig:runtime_quality_tradeoff] we illustrate this idea on the example of the Traveling Salesman Problem&nbsp;[@ABCC2006TTSPACS; @LLKS1985TTSPAGTOCO; @GP2002TTSPAIV] briefly mentioned in [@sec:intro:logistics].
The goal of solving the TSP is to find the shortest round trip tour through $n$&nbsp;cities.
The TSP is \NPhard&nbsp;[@GJ1979CAIAGTTTONC; @GP2002TTSPAIV].
Today, it is possible to solve many large instances of this problem to optimality by using sophisticated *exact* algorithms&nbsp;[@CEG2005CWDPIFT; @W2003ROCFTB].
Yet, finding the *shortest possible tour* for a particular TSP may (still and probably always in the future) simply take way too long, e.g., in the scale of many years.
Finding just *one tour* is, however, very easy: I can write down the cities in any particular order.
Of course, I can visit the cities in an arbitrary order.
That is an entirely valid solution, and I can obtain it basically in 0&nbsp;time.
This "tour" would probably be very bad, very long, and generally not a good idea.

In the real world, we need something in between.
We need a solution which is as good as possible as fast as possible.
Heuristic and metaheuristic algorithms offer different trade-offs of solution quality and runtime.
Different from exact algorithms, they do not guarantee to find the optimal solution and often make no guarantee about the solution quality at all.
Still, they often allow us to get very good solutions for computationally hard problems in short time.
They may often still discover them (just not always, not guaranteed).

### Good Algorithms within Acceptable Time

Saying that we need a good algorithm to solve a given problem is very easy.
Developing a good algorithm to solve a given problem is not, as any graduate student in the field can probably confirm.
Before, I stated that great exact algorithms for the TSP exist&nbsp;[@CEG2005CWDPIFT; @W2003ROCFTB], that can solve many TSPs quickly (although not all).
There are years and years of research in these algorithms.
Even the top heuristic and metaheuristic algorithm for the TSP today result from many years of targeted research&nbsp;[@H2009GKOSFTLKTH; @NK2013APGAUEACFTTSP; @W2016BNMDPCADIM] and their implementation from the algorithm specification alone can take months&nbsp;[@WWLC2019IIIOADTM].
Unfortunately, if you do not have plain TSP, but one with some additional constraints &ndash; say, time windows to visit certain cities &ndash; the optimized, state-of-the-art TSP solvers are no longer applicable.
And in a real-world application scenario, you do not have years to develop an algorithm.
What you need are simple, versatile, general algorithm concepts that you can easily adapt to your problem at hand.
Something that can be turned into a working prototype within a few weeks.

Metaheuristics are the answer.
They are general algorithm concepts into which we can plug problem-specific modules.
General metaheuristics are usually fairly easy to implement and deliver acceptable results.
Once a sufficiently well-performing prototype has been obtained, we could go and integrate it into the software ecosystem of the customer.
We also can try to improve its performance using different ideas &hellip; and years and years of blissful research, if we are lucky enough to find someone paying for it. 
