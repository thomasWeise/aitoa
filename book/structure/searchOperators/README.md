## Search Operations {#sec:searchOperators}

One of the most important design choices of a metaheuristic optimization algorithm are the search operators employed.

### Definitions

\text.block{definition}{searchOp}{An $k$&#8209;ary *search operator*&nbsp;$\searchOp:\searchSpace^k\mapsto\searchSpace$ is a left-total relation which accepts $k$&nbsp;points in the search space&nbsp;$\searchSpace$ as input and returns one point in the search space as output.}

Special cases of search operators are

- nullary operators ($k=0$, see [@lst:INullarySearchOperator]), which sample a new point from the search space without using any information from an existing points,
- unary operators ($k=1$, see [@lst:IUnarySearchOperator]), which sample a new point from the search space based on the information of one existing point,
- binary operators ($k=2$, see [@lst:IBinarySearchOperator]), which sample a new point from the search space by combining information from two existing points, and
- ternary  operators ($k=3$), which sample a new point from the search space by combining information from three existing points.

\repo.listing{lst:INullarySearchOperator}{A generic interface for nullary search operators.}{java}{src/main/java/aitoa/structure/INullarySearchOperator.java}{}{relevant}

\repo.listing{lst:IUnarySearchOperator}{A generic interface for unary search operators.}{java}{src/main/java/aitoa/structure/IUnarySearchOperator.java}{}{relevant}

\repo.listing{lst:IBinarySearchOperator}{A generic interface for binary search operators.}{java}{src/main/java/aitoa/structure/IBinarySearchOperator.java}{}{relevant}

Whether, which, and how such such operators are used depends on the nature of the optimization algorithms and will be discussed later on.

Search operators are often *randomized*, which means invoking the same operator with the same input multiple times may yield different results.
This is why [@lst:INullarySearchOperator;@lst:IUnarySearchOperator;@lst:IBinarySearchOperator] all accept an instance of [`java.util.Random`](http://docs.oracle.com/javase/8/docs/api/java/util/Random.html), a pseudorandom number generator.

Operators that take existing points in the search space as input tend to sample new points which, in some sort, are similar to their inputs.
They allow us to define proximity-based relationships over the search space, such as the common concept of neighborhoods.

\text.block{definition}{neighborhood}{A unary operator&nbsp;$\searchOp:\searchSpace\mapsto\searchSpace$ defines a *neighborhood* relationship over a search space where a point&nbsp;$\sespel_1\in\searchSpace$ is called a *neighbor* of a point&nbsp;$\sespel_2\in\searchSpace$ are called neighbors if and only if&nbsp;$\sespel_1$ could be the result of an application of&nbsp;$\searchOp$ to&nbsp;$\sespel_2$.}

### Example: Job Shop Scheduling

We will step-by-step introduce the concepts of nullary, unary, and binary search operators in the subsections of [@sec:metaheuristics] on metaheuristics as they come.
This makes more sense from a didactic perspective.
