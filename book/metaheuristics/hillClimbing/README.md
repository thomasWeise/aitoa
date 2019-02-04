## Hill Climbing

Our first algorithm, random sampling, is not a very efficient.
It does not make any use of the information it "sees" during the optimization process.
A search step consists of creating an entirel new, entirely random candidate solution.
Every search step is thus independent of all prior steps.

Local search algorithms offer an alternative.
They remember the current best point&nbsp;$\bestSoFar{\sespel}$ in the search space&nbsp;$\searchSapce$.
In every step, a local search algorithm investigates a point&nbsp;$\sespel$ similar to&nbsp;$\bestSoFar{\sespel}$.
If it is better, it is accepted as a new best-so-far solution.
Otherwise, it is discarted.

Local search exploits a property of many optimization problems called *causality*&nbsp;[@R1973ES; @R1994ES; @WCT2012EOPABT; @WZCN2009WIOD].

\text.block{definition}{causality}{Causality means that small changes in the features of an object (or candidate solution) also lead to small changes in its behavior (or objective value).}

### Ingredient: Unary Search Operation for the JSSP

So the question arises how we can apply small changes to a candidate solution?

\repo.listing{lst:JSSPUnaryOperator1Swap}{An excerpt of the `1swap` operator for the JSSP, an implementation of the unary search operation interface [@lst:IUnarySearchOperator]. `1swap` swaps two jobs in our encoding of Gantt diagrams.}{java}{src/main/java/aitoa/examples/jssp/JSSPUnaryOperator1Swap.java}{}{relevant}

![An example for the application of `1swap` to an existing point in the search space (top-left), yielding a slightly modified copy (top-right) with two jobs swapped. If we map these to the solution space (bottom) using the representation mapping&nbsp;$\repMap$, the changes marked with violet frames occur (bottom-right).](\relative.path{jssp_unary_1swap_demo.svgz}){#fig:jssp_unary_1swap_demo width=99%}
