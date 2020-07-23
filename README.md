# An Introduction to Optimization Algorithms

## 1. Introduction

With the book [*"An Introduction to Optimization Algorithms"*](http://thomasweise.github.io/aitoa/index.html) we try to develop an accessible and easy-to-read introduction to optimization, optimization algorithms, and, in particular, metaheuristics.
We will do this by first building a general framework structure for optimization problems.
We then approach the algorithms that have been developed to solve such problems from bottom-up, starting with simple approaches and step-by-step moving to more advanced methods.
These moves are incremental, as problems of the current algorithm are discussed based on real results on a real example application, the Job Shop Scheduling Problem ([JSSP](https://github.com/thomasWeise/jsspInstancesAndResults)).

## 2. Resources

### 2.1. The Book

The book [*"An Introduction to Optimization Algorithms"*](http://thomasweise.github.io/aitoa/index.html) is available in the following formats:

1. [aitoa.pdf](http://thomasweise.github.io/aitoa/aitoa.pdf), in the [PDF](http://thomasweise.github.io/aitoa/aitoa.pdf) format for reading on the computer and/or printing (but please don't print this, save paper),
2. [aitoa.html](http://thomasweise.github.io/aitoa/aitoa.html), in the [HTML5](http://thomasweise.github.io/aitoa/aitoa.html) format for reading in the browser on any device,
3. [aitoa.epub](http://thomasweise.github.io/aitoa/aitoa.epub), in the [EPUB3](http://thomasweise.github.io/aitoa/aitoa.epub) format for reading on mobile phones or other hand-held devices, and
4. [aitoa.azw3](http://thomasweise.github.io/aitoa/aitoa.azw3), in the [AZW3](http://thomasweise.github.io/aitoa/aitoa.azw3) format for reading on Kindle and similar devices.

### 2.2. The Algorithm Implementations

Every algorithm that we discuss is implemented in Java&nbsp;1.8 and all accompanying sources codes are provided in the GitHub repository [aitoa-code](http://github.com/thomasWeise/aitoa-code).
This means that you can run the same experiments that I did, but also do your own experiments and use the code for your own purposes.
The code provides comprehensive facilities for logging and evaluating experimental results.
It comes as a Maven project that can be integrated as library into your own software, as discussed [here](http://github.com/thomasWeise/aitoa-code).

### 2.3. The Slides

The final goal is to use this book as the foundation of a university course "Optimization Algorithms."
Therefore, I am also trying to create a corresponding set of slides.
The book is far from being complete, but the slides are even in a much earlier state of development.
Only the first few topics from the book are touched as of now.

1. [Introduction](https://thomasweise.github.io/aitoa-slides/01_introduction.pdf)
2. [Structure](https://thomasweise.github.io/aitoa-slides/02_structure.pdf)

### 2.4. Everything in One Package

A [tar.xz](https://thomasweise.github.io/aitoa-slides/optimization_algorithms.tar.xz) archive with everything put together, i.e., the book, the source codes, and the slides, can be found [here](https://thomasweise.github.io/aitoa-slides/optimization_algorithms.tar.xz).

## 3. Further Tools and Resources

Furthermore, many of the diagrams in this book are generated using an [`R` package](http://github.com/thomasWeise/aitoaEvaluate), which is published in the GitHub Repository [aitoaEvaluate](http://github.com/thomasWeise/aitoaEvaluate).

The data from the experiments presented in the book is in the GitHub Repository [aitoa-data](http://github.com/thomasWeise/aitoa-data).

[jsspInstancesAndResults](https://github.com/thomasWeise/jsspInstancesAndResults) is an repository with lots of results from literature on the Job Shop Scheduling Problem (JSSP).
At the same time, it is also an `R` package.
You can use it to compare your own JSSP research with the state-of-the-art.

## 4. License

This book [*"An Introduction to Optimization Algorithms"*](http://thomasweise.github.io/aitoa/index.html) is released under the Attribution-NonCommercial-ShareAlike 4.0 International license (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0), see [http://creativecommons.org/licenses/by-nc-sa/4.0/](http://creativecommons.org/licenses/by-nc-sa/4.0/) for a summary.
The [slides](https://thomasweise.github.io/aitoa-slides/) of the corresponding course are released under the same license.
The experiments have been conducted using the Java programs published in repository [thomasWeise/aitoa-code](http://github.com/thomasWeise/aitoa-code), which under the MIT&nbsp;License.
The results of these experiments are provided in the repository [thomasWeise/aitoa-data](http://github.com/thomasWeise/aitoa-data) are under the CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0 license.
Many of the graphics and diagrams in the book have been created from these data using the MIT-licensed `R` scripts in  [thomasWeise/aitoaEvaluate](http://github.com/thomasWeise/aitoaEvaluate).

## 5. Contact

If you have any questions or suggestions, please contact
[Prof. Dr. Thomas Weise](http://iao.hfuu.edu.cn/team/director) of the
[Institute of Applied Optimization](http://iao.hfuu.edu.cn/) at
[Hefei University](http://www.hfuu.edu.cn) in
Hefei, Anhui, China via
email to [tweise@hfuu.edu.cn](mailto:tweise@hfuu.edu.cn) with CC to [tweise@ustc.edu.cn](mailto:tweise@ustc.edu.cn).

[<img alt="Travis CI Build Status" src="http://img.shields.io/travis/thomasWeise/betAndRun/master.svg" height="20"/>](http://travis-ci.org/thomasWeise/aitoa/)