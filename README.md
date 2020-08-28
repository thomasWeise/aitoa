# An Introduction to Optimization Algorithms

## 1. Introduction

With the book [*"An Introduction to Optimization Algorithms"*](http://thomasweise.github.io/aitoa/index.html) we try to develop an accessible and easy-to-read introduction to optimization, optimization algorithms, and, in particular, metaheuristics.
We will do this by first building a general framework structure for optimization problems.
We then approach the algorithms that have been developed to solve such problems from bottom-up, starting with simple approaches and step-by-step moving to more advanced methods.
These moves are incremental, as problems of the current algorithm are discussed based on real results on a real example application, the Job Shop Scheduling Problem ([JSSP](https://github.com/thomasWeise/jsspInstancesAndResults)).

**If you have any comments or suggestions regarding the book, or if you spotted an error or typo, please feel free to submit an [issue here](https://github.com/thomasWeise/aitoa/issues).**
Your feedback would help us to improve the book.

## 2. Resources

### 2.1. The Book

The book [*"An Introduction to Optimization Algorithms"*](http://thomasweise.github.io/aitoa/index.html) is available in the following formats:

1. [aitoa.pdf](http://thomasweise.github.io/aitoa/aitoa.pdf), in the [PDF](http://thomasweise.github.io/aitoa/aitoa.pdf) format for reading on the computer and/or printing (but please don't print this, save paper),
2. [aitoa.html](http://thomasweise.github.io/aitoa/aitoa.html), in the [HTML5](http://thomasweise.github.io/aitoa/aitoa.html) format for reading in the browser on any device,
3. [aitoa.epub](http://thomasweise.github.io/aitoa/aitoa.epub), in the [EPUB3](http://thomasweise.github.io/aitoa/aitoa.epub) format for reading on mobile phones or other hand-held devices, and
4. [aitoa.azw3](http://thomasweise.github.io/aitoa/aitoa.azw3), in the [AZW3](http://thomasweise.github.io/aitoa/aitoa.azw3) format for reading on Kindle and similar devices.

The latter two formats are still a bit experimental, so they might not be beautiful.
The [html](http://thomasweise.github.io/aitoa/aitoa.html) version of the book is fairly large, as it is a single stand-alone file.

### 2.2. The Algorithm Implementations

Every algorithm that we discuss is implemented in Java&nbsp;1.8 and all accompanying sources codes are provided in the GitHub repository [aitoa-code](http://github.com/thomasWeise/aitoa-code).
This means that you can run the same experiments that I did, but also do your own experiments and use the code for your own purposes.
The code provides comprehensive facilities for logging and evaluating experimental results.
It should be applicable to a wide range of scenarios.
In particular, we tried to make it suitable for scientific experiments and provide built-in experiment execution, parallelization, distribution, and self-documenting output facilities.
The code comes as a Maven project that can be integrated as library into your own software, as discussed [here](http://github.com/thomasWeise/aitoa-code).

### 2.3. The Slides

The final goal is to use this book as the foundation of a university course "Optimization Algorithms."
Therefore, I am also trying to create a corresponding set of [slides](https://thomasweise.github.io/aitoa-slides/).
The book is far from being complete, but the slides are even in a much earlier state of development.
Only the first few topics from the book are covered as of now.

1. [Introduction](https://thomasweise.github.io/aitoa-slides/01_introduction.pdf)
2. [Structure](https://thomasweise.github.io/aitoa-slides/02_structure.pdf)
3. [Metaheuristics](https://thomasweise.github.io/aitoa-slides/03_metaheuristics.pdf)
4. [Random Sampling](https://thomasweise.github.io/aitoa-slides/04_random_sampling.pdf)
5. [Stochastic Hill Climbing](https://thomasweise.github.io/aitoa-slides/05_stochastic_hill_climbing.pdf)
6. [Evolutionary Algorithm](https://thomasweise.github.io/aitoa-slides/06_evolutionary_algorithm.pdf)
7. [Simulated Annealing](https://thomasweise.github.io/aitoa-slides/07_simulated_annealing.pdf)

The LaTeX source code of the slides is provided in [this repository](http://github.com/thomasWeise/aitoa-slides). 
It also includes all figures as `pdf` and `svg`.

### 2.4. Everything in One Archive

A [tar.xz archive](https://thomasweise.github.io/aitoa-slides/optimization_algorithms.tar.xz) with everything put together, i.e., the [book](http://thomasweise.github.io/aitoa/index.html), the [source codes](http://github.com/thomasWeise/aitoa-code), and the [slides](https://thomasweise.github.io/aitoa-slides/), can be found [here](https://thomasweise.github.io/aitoa-slides/optimization_algorithms.tar.xz).
We package everything as [tar.xz](https://thomasweise.github.io/aitoa-slides/optimization_algorithms.tar.xz) because this format tends to achieve the best compression ratio.

## 3. Further Tools and Resources

Furthermore, many of the diagrams in this book are generated using an [`R` package](http://github.com/thomasWeise/aitoaEvaluate), which is published in the GitHub Repository [aitoaEvaluate](http://github.com/thomasWeise/aitoaEvaluate).
You can install and use it in `R` via `devtools::install_github("thomasWeise/aitoaEvaluate")`.

The data from the experiments presented in the book is presented in the GitHub Repository [aitoa-data](http://github.com/thomasWeise/aitoa-data).

[jsspInstancesAndResults](https://github.com/thomasWeise/jsspInstancesAndResults) is an repository with lots of results from literature on the Job Shop Scheduling Problem (JSSP).
At the same time, it is also an `R` package.
You can use it to compare your own JSSP research with the state-of-the-art.

## 4. Ecosystem

Around this book I have created a whole ecosystem of tools that help me by automating many of work involved in its development.
The goal is to allow an author to fully concentrate on writing her material, while compiling the material to different formats and uploading them to the web should be [automated](https://www.linkedin.com/posts/thomas-weise-3297b139_thomasweisebookbuilder-activity-6593099811547906048-sUqT).
This tool suite is centered around GitHub and putting all material into a repository, which automatically allows for collaborative working as well.

The `R` package [bookbuildeR](http://github.com/thomasWeise/bookbuildeR) provides the commands wrapping around [pandoc](http://pandoc.org/) and extending [Markdown](http://pandoc.org/MANUAL.html#pandocs-markdown) to automatically build electronic books.

There is a hierarchy of docker containers that forms the infrastructure for the automated builds:

- [docker-bookbuilder](http://github.com/thomasWeise/docker-bookbuilder) is the docker container that can be used to compile an electronic book based on our tool chain. [Here](http://github.com/thomasWeise/docker-bookbuilder) you can find it on GitHub and [here](http://hub.docker.com/r/thomasweise/docker-bookbuilder/) on docker hub.
- [docker-slidesbuilder](http://github.com/thomasWeise/docker-slidesbuilder) is the docker container that can be used to compile `beamer`-based LaTeX slides to pdf and upload them. [Here](http://github.com/thomasWeise/docker-slidesbuilder) you can find it on GitHub and [here](http://hub.docker.com/r/thomasweise/docker-slidesbuilder/) on docker hub.
- [docker-pandoc-r](http://github.com/thomasWeise/docker-pandoc-r) is a docker container with a complete pandoc, TeX Live, and R installation. It forms the basis for [docker-bookbuilder](http://github.com/thomasWeise/docker-bookbuilder) and its sources are [here](http://github.com/thomasWeise/docker-pandoc-r) while it is located [here](http://hub.docker.com/r/thomasweise/docker-pandoc-r/) on docker hub.
- [docker-pandoc-calibre](http://github.com/thomasWeise/docker-pandoc-calibre) is the container which is the basis for [docker-pandoc-r](http://github.com/thomasWeise/docker-pandoc-r). It holds a complete installation of pandoc, [calibre](http://calibre-ebook.com), which is used to convert EPUB3 to AZW3, and TeX Live and its sources are [here](http://github.com/thomasWeise/docker-pandoc-calibre) while it is located [here](http://hub.docker.com/r/thomasweise/docker-pandoc-calibre/).
- [docker-pandoc](http://github.com/thomasWeise/docker-pandoc) is the container which is the basis for [docker-pandoc-calibre](http://github.com/thomasWeise/docker-pandoc-calibre). It holds a complete installation of pandoc and TeX Live and its sources are [here](http://github.com/thomasWeise/docker-pandoc) while it is located [here](http://hub.docker.com/r/thomasweise/docker-pandoc/).
- [docker-texlive-thin](http://github.com/thomasWeise/docker-texlive-thin) is the container which is the basis for [docker-pandoc](http://github.com/thomasWeise/docker-pandoc). It holds an installation of TeX Live and its sources are [here](http://github.com/thomasWeise/docker-texlive-thin) while it is located [here](http://hub.docker.com/r/thomasweise/docker-texlive-thin/).
- The `R` package [utilizeR](http://github.com/thomasWeise/utilizeR) holds some utility methods used by [bookbuildeR](http://github.com/thomasWeise/bookbuildeR). 

Besides these containers, we also have some tools to make our work more efficiently.
The tool [`ultraSvgz`](https://github.com/thomasWeise/ultraSvgz) combines several existing pieces (such as [`ultraGzip`](http://github.com/thomasWeise/ultraGzip)) of software to compile an `svg` graphic to a very small `svgz`.
This, in turn, makes it easier to keep the total size of the git repositories with our book and slides small.

## 5. License

This book [*"An Introduction to Optimization Algorithms"*](http://thomasweise.github.io/aitoa/index.html) is released under the Attribution-NonCommercial-ShareAlike 4.0 International license (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0), see [http://creativecommons.org/licenses/by-nc-sa/4.0/](http://creativecommons.org/licenses/by-nc-sa/4.0/) for a summary.
The [slides](https://thomasweise.github.io/aitoa-slides/) of the corresponding course are released under the same license.
The experiments have been conducted using the Java programs published in repository [thomasWeise/aitoa-code](http://github.com/thomasWeise/aitoa-code), which under the MIT&nbsp;License.
The results of these experiments are provided in the repository [thomasWeise/aitoa-data](http://github.com/thomasWeise/aitoa-data) are under the CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0 license.
Many of the graphics and diagrams in the book have been created from these data using the MIT-licensed `R` scripts in  [thomasWeise/aitoaEvaluate](http://github.com/thomasWeise/aitoaEvaluate).

## 6. Contact

If you have any questions or suggestions, please contact
[Prof. Dr. Thomas Weise](http://iao.hfuu.edu.cn/team/director) of the
[Institute of Applied Optimization](http://iao.hfuu.edu.cn/) at
[Hefei University](http://www.hfuu.edu.cn) in
Hefei, Anhui, China via
email to [tweise@hfuu.edu.cn](mailto:tweise@hfuu.edu.cn) with CC to [tweise@ustc.edu.cn](mailto:tweise@ustc.edu.cn).

[<img alt="Travis CI Build Status" src="http://img.shields.io/travis/thomasWeise/betAndRun/master.svg" height="20"/>](http://travis-ci.org/thomasWeise/aitoa/)