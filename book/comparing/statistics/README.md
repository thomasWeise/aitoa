## Statistical Measures {#sec:statisticalMeasures}

Most of the optimization algorithms that we have discussed so far are randomized ([@sec:randomizedAlgos]).
A randomized algorithm makes at least one random decision which is not a priori known or fixed.
Such an algorithm can behave differently every time it is executed.

\text.block{definition}{run}{One independent application of one optimization algorithm to one instance of an optimization problem is called a *run*.}

Each *run* is considered as independent and may thus lead to a different result.
This also means that the measurements of the basic performance indicators discussed in [@sec:basicPerformanceIndicators] can take on different values as well.
We may measure $k$&nbsp;different result solution qualities at the end of $k$&nbsp;times applications of the same algorithm to the same problem instance (which was also visible in&nbsp;[@fig:performance_indicators_cuts]).
In order to get a handy overview about what is going on, we often want to reduce this potentially large amount of information to a few, meaningful and easy-to-interpret values.
These values are statistical measures.
Of course, this here is neither a book about statistics nor probability, so we can only scratch on the surface of these topics.
For better discussions, please refer to text books such as&nbsp;[@K2014PTACC; @T2017LOPTAMS; @R1977PTACC; @T2018SFAB; @SC1988NSFTBS].

\relative.input{sampling/README.md}
\relative.input{average/README.md}
\relative.input{spread/README.md}
