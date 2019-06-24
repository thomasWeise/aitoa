## Epistasis: One Root of the Evil

Did you notice that we often said and found that optimization problems get the harder, the more decision variables we have?
Why is that?
The simple answer is this:
Let's say each element $\solspel\in\solutionSpace$ from the solution space&nbsp;$\solutionSpace$ has $n$&nbsp;variables, each of which can take on $q$&nbsp;possible values.
Then, there are $|\solutionSpace|=q^n$ points in the solution space &ndash; in other words, the size of $\solutionSpace$ grows exponentially with&nbsp;$n$.
Hence, it takes longer to find the best elements it.

But this is only partially true!
It is only true if the variables depend on each other.
As a counter example, consider the following problem subject to minimization:

$$ \objf(\solspel) = (\arrayIndex{\solspel}{1} - 3)^2 + (\arrayIndex{\solspel}{2} + 5)^2 + (\arrayIndex{\solspel}{3} - 1)^2, {\quad}\solspel\in \{-10 \dots 10\}^3 $$

There are three decision variables.
However, upon close inspection, we find that they are entirely unrelated.
Indeed, we could solve the three *separate* minimization problems given below one-by-one instead, and would obtain the same values for $\arrayIndex{\solspel}{1}$, $\arrayIndex{\solspel}{2}$, and $\arrayIndex{\solspel}{3}$.

$$
\begin{array}{rcll}
\objf_1(\arrayIndex{\solspel}{1}) &=& (\arrayIndex{\solspel}{1} - 3)^2 & {\quad}\arrayIndex{\solspel}{1}\in -10 \dots 10 \\
\objf_2(\arrayIndex{\solspel}{2}) &=& (\arrayIndex{\solspel}{1} + 5)^2 & {\quad}\arrayIndex{\solspel}{2}\in -10 \dots 10\\
\objf_3(\arrayIndex{\solspel}{3}) &=& (\arrayIndex{\solspel}{1} - 1)^2 & {\quad}\arrayIndex{\solspel}{3}\in -10 \dots 10
\end{array}
$$

Both times, the best value for&nbsp;$\arrayIndex{\solspel}{1}$ is 3, for&nbsp;$\arrayIndex{\solspel}{2}$ its -5, and for&nbsp;$\arrayIndex{\solspel}{3}$, it is 1.
However, while the three solution spaces of the second set of problems each contain 21 possible values, the solution space of the original problem contains $21^3=9261$ values.
Obviously, we would prefer to solve the three separate problems, because even in sum, they are much smaller.
But in this example, we very lucky: our optimization problem was *separable*, i.e., we could split it into several easier, independent problems.

\text.block{definition}{separability}{A function of&nbsp;$n$ variables is *separable* if it can be rewritten as a sum of $n$&nbsp;functions of just one variable&nbsp;[@H1964NADP; @HRMSA2008PFNSAICP].}

For the JSSP problem that we use as example application domain in this book, this is not the case:
Neither can we schedule each jobs separately without considering the other jobs nor can we consider the machines separately.
There is also no way in which we could try to find the best time slot for any sub-job without considering the other jobs.

### The Problem: Epistasis

The feature that makes optimization problems with more decision variables *much* harder is called *epistasis*.

![An illustration of how genes in biology could exhibit epistatic and pleiotropic interactions in an (entirely fictional) dinosaur.](\relative.path{pleiotropy_and_epistasis.svgz}){#fig:pleiotropy_and_epistasis}

In biology, [epistasis](https://en.wikipedia.org/wiki/Epistasis) is defined as a form of interaction between different genes&nbsp;[@P1998TLOGIA].
The interaction between genes is epistatic if the effect on the fitness of resulting from altering one gene depends on the allelic state of other genes&nbsp;[@L1935PTAIPAIOAABV].

\text.block{definition}{epistasis}{In optimization, *epistasis* is the dependency of the contribution of one decision variable to the value of the objective functions on the value of other decision variables&nbsp;[@WCT2012EOPABTM; @WZCN2009WIOD; @D1991EVAVOGH; @A1996NKFL; @NV1996EOFAIS].}

A representation has minimal epistasis when every decision variable is independent of every other one.
Then, the optimization problem is separable and can be solved by finding the best value for each decision variable separately.
A problem is maximally epistatic (or non-separable&nbsp;[@HRMSA2008PFNSAICP]) when no proper subset of decision variables is independent of any other decision variable&nbsp;[@NV1996EOFAIS].

Another related biological phenomenon is *[pleiotropy](https://en.wikipedia.org/wiki/Pleiotropy)*, which means that a single gene is responsible for multiple phenotypical traits&nbsp;[@H2010EAROEIEC].
Like epistasis, pleiotropy can sometimes lead to unexpected improvements but often is harmful.
Both effects are sketched in [@fig:pleiotropy_and_epistasis].

![How epistasis creates and influences the problematic problem features discussed in the previous sections.](\relative.path{epistasis_influence.svgz}){#fig:epistasis_influence}

As [@fig:epistasis_influence] illustrates, epistasis causes or contributes to the problematic traits we have discussed before&nbsp;[@WCT2012EOPABTM; @WZCN2009WIOD].
First, it reduces the causality because changing the value of one decision variable now has an impact on the meaning of other variables.
In our representation for the JSSP problem, for instance, changing the order of job IDs at the beginning of an encoded solution can have an impact on the times at which the sub-jobs coming later will be scheduled, even if these themselves were not changed.

If two decision variables interact epistatically, this can introduce local optima, i.e., render the problem multi-modal.
The stronger the interaction is, the more rugged the problem becomes.
In a maximally-epistatic problem, every decision variable depends on every other one, so applying a small change to one variable can have a large impact.

It is also possible that one decision variable have such semantics that it may turn on or off the impact of another one.
Of course, any change applied to a decision variable which has no impact on the objective value then, well, also has no impact, i.e., is *neutral*.
Finding rugged, deep valleys in a neutral plane in the objective space corresponds to finding a needle-in-a-haystack, i.e., an ill-defined optimization task. 

### Countermeasures

Many of the countermeasures for ruggedness, deceptiveness, and neutrality are also valid for epistatic problems.
In particular, a good representation design should aim to make the decision variables in the search space as independent as possible

#### Learning the Variable Interactions {#sec:epistasis:variableInteraction}

Often, a problem may neither be fully-separable nor maximally epistasic.
Sometimes, there are groups of decision variables which depend on each others while being independent from other groups.
Or, at least, groups of variables which interact strongly and which interact only weakly with variables outside of the group.
In such a scenario, it makes sense trying to learn which variables interact during the optimization process.
We could then consider each group as a unit, e.g., make sure to pass their values on together when applying a binary operator, or even try to optimize each group separately.
Examples for such techniques are:

- linkage learning in EAs&nbsp;[@H1997LGLTESPOBDUGA; @MG1999LIBNMDFOF; @C2006ETSOLLGATP; @GDK1989MGAMAAFR]
- modeling of variable dependency via statistical models&nbsp;[@PGCP1999BTBOA; CPPG2000LPDEABN]
- variable interaction learning&nbsp;[@CWYT2010LSGOUCCWVIL]
