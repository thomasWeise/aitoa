## Testing and Reproducibility as Important Elements of Software Development

The very first and maybe one of the most important issues when evaluating an optimization algorithms is that you *never* evaluate an optimization algorithm.
You always evaluate an *implementation* of an optimization algorithm.
You always compare *implementations* of different algorithms.

Before we even begin to think about running experiments, we need to be assert whether our algorithm implementations are correct.
In almost all cases, it is not possible to proof whether a software is implemented correctly or not.
However, we can apply several measures to find potential errors.

### Unit Testing

A very important tool that should be applied when developing a new optimization method is [unit testing](http://en.wikipedia.org/wiki/Unit_testing).
Here, the code is divided into units, each of which can be tested separately.

In this book, we try to approach optimization in a structured way and have defined several interfaces for the components of an optimization and the representation in [@sec:structure].
An implementation of such an interface can be considered as a unit.
The interfaces define methods with input and output values.
We now can write additional code that tests whether the methods behave as expected, i.e., do not violate their contract.
Such unit tests can be executed automatically.
Whenever we compile our software after changing code, we can also run all the tests again.
This way, we are very likely to spot a lot of errors before they mess up our experiments.

In the Java programming language, the software framework [JUnit](http://en.wikipedia.org/wiki/JUnit) provides an infrastructure for such testing.
In the example codes of our book, in the folder [src/test/java](\repo.name/tree/master/src/test/java/aitoa), we provide JUnit tests for general implementations of our interfaces as well as for the classes we use in our JSSP experiment.

Here, the encapsulation of different aspects of black-box optimization comes in handy.
If we can ensure that the implementations of all search operations, the representation mapping, and the objective function are correct, then our implemented black-box algorithms will &ndash; at least &ndash; not return any invalid candidate solutions.
The reason is that they use exactly only these components (along with utility methods in the `ISpace` interface which we can also test) to produce solutions.
A lot of pathological errors can therefore be detected early.

Always develop the tests either before or at least along with your algorithm implementation.
Never say "I will do them later."
Because you won't.
And if you actually would, you will find errors and then repeat your experiments.

### Reproducibility

A very important aspect of rigorous research is that experiments are reproducible.
It is extremely important to consider reproduciblity *before* running the experiments.
From personal experiments, I can say that sometimes, even just two or three years after running the experiments, I have looked at the collected data and did no longer know, e.g., the settings of the algorithms.
Hence, the data became useless.
The following measures can be taken to ensure that your experimental results are meaningful to yourself and others in the years to come:

1. Always use self-explaining formats like plain text files to store your results.
2. Create one file for each run of your experiment and *automatically* store at least the following information&nbsp;[@W2017FSDFTSTFOAB; @WCTLTCMY2014BOAAOSFFTTSP]:
	 a. The algorithm name and all parameter settings of the algorithm.
	 b. The relevant measurements.
	 c. The [seed](http://en.wikipedia.org/wiki/Random_seed) of the pseudo-random number generator used.
	 d. Information about the problem instance on which the algorithm was applied.
	 e. Short comments on how the above is to be interpreted.
	 f. Maybe information about the computer system your code runs on, maybe the Java version, etc.
	 g. Maybe even your contact information.
This way, you or someone else can, next year, or in ten years from now, read your results and get a clear understanding of "what is what."
Ask yourself: If I put my data on my website and someone else downloads it, does every single file contain sufficient information to understand its content?
3. Store the files and the compiled binaries of your code in a self-explaining directory structure&nbsp;[@W2017FSDFTSTFOAB; @WCTLTCMY2014BOAAOSFFTTSP].
I prefer having a base folder with the binaries that also contains a folder `results`.
`results` then contains one folder with a short descriptive name for each algorithm setup, which, in turn, contain one folder with the name of each problem instance.
The problem instance folders then contain one text file per run.
After you are done with all experiments and evaluation, such folders lend them self for compression, say in the [`tar`](http://en.wikipedia.org/wiki/Tar_(computing)).[`xz`](http://en.wikipedia.org/wiki/Xz) format, for long-term archiving.
4. Write your code such that you can specify the random seeds.
This  allows to easily repeat selected runs or whole experiments.
All random decisions of an algorithm depend on the random number generator (RNG).
The "seed" (see *point&nbsp;2.c* above) is an initialization value of the RNG.
If I initialize the (same) RNG with the same seed, it will produce the same sequence of random numbers.
If I know the random seed used for an experiment, then I can start the same algorithm again with the same initialization of the RNG.
Even if my optimization method is randomized, it will then make the same "random" decisions.
In other words, you should be able to repeat the experiments in this book and get more or less identical results.
There might be differences if Java changes the implementation of their RNG or if your computer is significantly faster or slower than mine, though.
5. Ensure that all random seeds in your experiments are generated in a deterministic way in your code.
This can be a proof that you did not perform [cherry picking](http://en.wikipedia.org/wiki/Cherry_picking) during your experiments, i.e., that you did not conduct 1000 runs and picked only the 101 where your newly-invented method works best.
6. Clearly document and comment your code.
In particular, comment the contracts of each method such that you can properly verify them in unit tests.
Never say "I document the code when I am finished with my work."
Because you won't.
7. Prepare your code from the very beginning as if you would like to put it on your website.
Prepare it with the same care and diligence you want to see your name associated with.
8. If you are conducting research work, consider to publish both your code and data online:
	 a. For code, several free platforms such as [GitHub](http://www.github.com) or [bitbucket](http://bitbucket.org/) exist.
These platforms often integrate with free [continuous integration](http://en.wikipedia.org/wiki/Continuous_integration) platforms, which can automatically compile your code and run your unit tests when you make a change.
	 b. For results, there, too, are free platforms such as [zenodo](http://zenodo.org/).
Using such online repositories also protects us from losing data.
This is also a great way to show what you are capable of to potential employers&hellip;
9. If your code depends on external libraries or frameworks, consider using an automated dependency management and build tool.
For the code associated with this book, I use [Apache Maven](http://en.wikipedia.org/wiki/Apache_Maven), which ensures that my code is compiled using the correct dependencies (e.g., the right JUnit version) and that the unit tests are executed on each built.
If I or someone else wants to use the code later again, the chances are good that the build tool can find the same, right versions of all required libraries.  

From the above, I think it should have become clear that reproducibility is nothing that we can consider after we have done the experiments.
Hence, like the search for bugs, it is a problem we need to think about beforehand.
Several of the above are basic suggestions which I found useful in my own work.
Some of them are important points that are necessary for good research &nbsp; and which sadly are never mentioned in any course.
