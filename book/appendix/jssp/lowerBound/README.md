### Lower Bounds {#sec:appendix:jssp:lowerBounds}

The way to compute the lower bound from [@sec:jssp:lowerBounds] for the JSSP is discussed by Taillard in [@T199BFBSP].
As said there, the makespan of a JSSP schedule cannot be smaller than the total processing time of the "longest"" job.
But we also know that the makespan cannot be shorter than the latest "finishing time"&nbsp;$\jsspMachineFinish{\jsspMachineIndex}$ of any machine&nbsp;$\jsspMachineIndex$ in the optimal schedule.
For a machine&nbsp;$\jsspMachineIndex$ to finish, it will take at least the sum&nbsp;$\jsspMachineRuntime{\jsspMachineIndex}$ of the runtimes of all the sub-jobs to be executed on it, where

$$ \jsspMachineRuntime{\jsspMachineIndex} = \sum_{\jsspJobIndex=0}^{\jsspJobs-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex'}\text{~with~}\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex'}=\jsspMachineIndex $$

Of course, some sub-jobs&nbsp;$\jsspMachineIndex'$ cannot start right away on the machine, namely if they are not the first sub-job of their job.
The minimum idle time of such a sub job is then the sum of the runtimes of the sub-jobs that come before it in the same job&nbsp;$\jsspJobIndex$.
This means there may be an initial idle period&nbsp$\jsspMachineStartIdle{\jsspMachineIndex}$ for the machine&nbsp;$\jsspMachineIndex$, which is at least as big as the shortest possible idle time.

$$ \jsspMachineStartIdle{\jsspMachineIndex} \geq \min_{\forall \jsspJobIndex\in 0\dots(\jsspJobs-1)} \left\{ \sum_{\jsspMachineIndex''=0}^{\jsspMachineIndex-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex'}\text{~with~}\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex'}=\jsspMachineIndex \right\} $$

Vice versa, there also is a minimum time&nbsp;$\jsspMachineEndIdle$ that the machine will stay idle after finishing all of its sub-jobs.

$$ \jsspMachineEndIdle{\jsspMachineIndex} \geq \min_{\forall \jsspJobIndex\in 0\dots(\jsspJobs-1)} \left\{ \sum_{\jsspMachineIndex''=\jsspMachineIndex+1}^{\jsspJobs-1} \jsspSubJobTime{\jsspJobIndex}{\jsspMachineIndex'}\text{~with~}\jsspSubJobMachine{\jsspJobIndex}{\jsspMachineIndex'}=\jsspMachineIndex \right\} $$

With this, we now have all the necessary components of [@eq:jsspLowerBound].
