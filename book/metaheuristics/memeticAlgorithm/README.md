## Memetic Algorithms: Hybrid of Global and Local Search {#sec:memeticAlgorithms}

We now have seen two types of efficient algorithms for solving optimization problems:

1. local search methods, like the hill climbers, that can refine and improve one solution quickly but may get stuck at local optima, and 
2. global search methods, like evolutionary algorithms, which try to preserve a diverse set of solutions and are less likely to end up in local optima, but pay for it by slower optimization speed.

It is a natural idea to combine both types of algorithms, to obtain a hybrid algorithm which unites the best from both worlds.
Such algorithms are today often called *Memetic Algorithms*&nbsp;[@M1989MA; @HSK2005RAIMA; @NCM2012HOMA].
