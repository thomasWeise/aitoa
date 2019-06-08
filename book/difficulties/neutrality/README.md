## Neutrality

An optimization problem and its representation have the property of causality if small changes in a candidate solution lead to small changes in the objective value.
If the resulting changes are large, then causality is weak and the objective function is rugged, which has negative effects on optimization performance.
However, if the resulting changes are *zero*, this can have a similar negative impact.  

### The Problem: Neutrality

![An illustration of problems exhibiting increasing neutrality (from left to right).](\relative.path{increasing_neutrality.svgz}){#fig:increasing_neutrality}

Neutrality means that a significant fraction of the points in neighborhood of a given point in the search space map to candidate solutions with the same objective value.
From the perspective of an optimization process, exploring the neighborhood of a good solution will yield the same solution again and again, i.e., there is no direction into which it can progress in a meaningful way.
If half of the candidate solutions have the same objective value, then every second search step cannot lead to an improvement and, for most algorithms, does not yield useful information.
This will slow down the search.

\text.block{definition}{evolvability}{The *evolvability* of an optimization process in its current state defines how likely the search operations will lead to candidate solutions with new (and eventually, better) objectives values.}

While there are various slightly differing definitions of evolvability both in optimization and evolutionary biology (see [@H2010EAROEIEC]), they all condense to the ability to eventually produce better offspring.
Researchers in the late 1990s and early 2000s hoped that *adding* neutrality to the representation could increase the evolvability in an optimization process and may hence lead to better performance&nbsp;[@B1998RANTNKPFOFL; @S1999GRDOPFEA; @TI2002NANFSA].
A common idea on how neutrality could be beneficial was the that *neutral networks* would form connections in the search space&nbsp;[@B1998RANTNKPFOFL; @S1999GRDOPFEA].

\text.block{neutralNetwork}{*Neutral networks* are sets of points in the search space which map to candidate solutions of the same objective value and which are transitively connected by neighborhoods spanned by the unary search operator&nbsp;[@S1999GRDOPFEA].}

The members of a neutral network may have neighborhoods that contain solutions with the same objective value (forming the network), but also solutions with worse and better objective values.
An optimization process may drift along a neutral network until eventually discovering a better candidate solution, which then would be in a (better) neutral network of its own.
The question then arises how we can introduce such a beneficial form of neutrality into the search space and representation mapping, i.e., how we can create such networks intentionally and controlled.
Indeed, it was shown that random neutrality is not beneficial for optimization&nbsp;[@KW2002OTUOREIMBES].
Actually, there is no reason why neutral networks should provide a better method for escaping local optima than other methods, such as well-designed search operators (remember [@sec:jsspUnaryOperator2]), even if we could create them&nbsp;[@KW2002OTUOREIMBES].
Random, uniform, or non-uniform redundancy in the representation are not helpful for optimization&nbsp;[@R2006RFGAEA; @KW2002OTUOREIMBES] and should be avoided.

Another idea&nbsp;[@TI2002NANFSA] to achieve self-adaptation in the search is to encode the parameters of search operators in the points in the search space.
This means that, e.g., the magnitude to which a unary search operator may modify a certain decision variable is stored in an additional variable which undergoes optimization together with the "actual" variables.
Since the search space size increases due to the additional variables, this necessarily leads to some redundancy.
(We will discuss this useful concept when I get to writing a chapter on Evolution Strategy, which I will get to eventually, sorry for now.)

### Countermeasures

#### Representation Design

From [@tbl:jsspSearchSpaceTable] we know that in our job shop example, the search space is larger than the solution space.
Hence, we have some form of redundancy and neutrality.
We did not introduce this "additionally," however, but it is an artifact of our representation design with which we pay for a gain in simplicity and avoiding infeasible solutions.
Generally, when designing a representation, we should try to construct it as compact and non-redundant as possible.
A smaller search space can be searched more efficiently.   
