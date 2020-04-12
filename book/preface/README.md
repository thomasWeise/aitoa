# Preface {-}

After writing *Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB] during my time as PhD student a long time ago, I now want to write a more direct guide to optimization and metaheuristics.
Currently, this [book](http://thomasweise.github.io/aitoa/index.html) is in an early stage of development and work-in-progress, so expect many changes.
It is available as [pdf](http://thomasweise.github.io/aitoa/aitoa.pdf), [html](http://thomasweise.github.io/aitoa/aitoa.html), [epub](http://thomasweise.github.io/aitoa/aitoa.epub), and [azw3](http://thomasweise.github.io/aitoa/aitoa.azw3).

The text tries to introduce optimization in an accessible way for an audience of undergraduate and graduate students without background in the field.
It tries to provide an intuition about how optimization algorithms work in practice, what things to look for when solving a problem, or how to get from a simple, working, proof-of-concept approach to an efficient solution for a given problem.
We follow a "learning-by-doing" approach by trying to solve one practical optimization problem as example theme throughout the book.
All algorithms are directly implemented and applied to that problem after we introduce them.
This allows us to discuss their strengths and weaknesses based on actual results.
We try to improve the algorithms step-by-step, moving from very simple approaches, which do not work well, to efficient metaheuristics.

```
@book{aitoa,
  author    = {Thomas Weise},
  title     = {An Introduction to Optimization Algorithms},
  year      = {2018--\meta.year},
  publisher = {Institute of Applied Optimization ({IAO}),
               School of Artificial Intelligence and Big Data,
               Hefei University},
  address   = {Hefei, Anhui, China},
  url       = {http://thomasweise.github.io/aitoa/},
  edition   = {\meta.date}
}
```

We use concrete examples and algorithm implementations written in Java.
While originally designed for educational purposes, the code is general and may applicable to real research experiments, too.
All of it is freely available in the repository *[thomasWeise/aitoa-code](\repo.name)* on [GitHub](http://www.github.com) under the MIT&nbsp;License.
Often, we will just look at certain portions of the code, maybe parts of a class where we omit methods or member variables, or even just snippets from functions.
Each source code listing is accompanied by a *(src)* link in the caption linking to the current full version of the file in the GitHub repository.
If you discover an error in any of the examples, please [file an issue](http://github.com/\repo.name/issues).

This book is written using our [automated book writing environment](http://github.com/thomasWeise/bookbuildeR/), which integrates GitHub, [Travis CI](http://www.travis-ci.org), and [docker](http://www.docker.com)-[hub](http://hub.docker.com).
Many of the charts and tables in the book have been generated with `R`&nbsp;scripts, whose source code is available in the [aitoaEvaluate](http://github.com/thomasWeise/aitoaEvaluate) on GitHub under the MIT&nbsp;License, too.
The experimental results are available in the repository [aitoa-data](http://github.com/thomasWeise/aitoa-data).
The text of the book itself is actively written and available in the repository *[thomasWeise/aitoa](http://github.com/thomasWeise/aitoa)* on GitHub.
There, you can also submit *[issues](http://github.com/thomasWeise/aitoa/issues)*, such as change requests, suggestions, errors, typos, or you can inform me that something is unclear, so that I can improve the book.

| &nbsp;
| repository: <http://github.com/thomasWeise/aitoa>
| commit: [\meta.commit](http://github.com/thomasWeise/aitoa/commit/\meta.commit)
| time and date: \meta.time
| example source repository: <\repo.name>
| example source commit: [\repo.commit](\repo.name/commit/\repo.commit)
| experimental results: <http://github.com/thomasWeise/aitoa-data>
| code for generating diagrams: <http://github.com/thomasWeise/aitoaEvaluate>
| &nbsp;

![](\relative.path{qr_code_aitoa_book.svgz})

This book is released under the Attribution-NonCommercial-ShareAlike 4.0 International license (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0), see [http://creativecommons.org/licenses/by-nc-sa/4.0/](http://creativecommons.org/licenses/by-nc-sa/4.0/) for a summary.

| &nbsp;
| Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/team/director)
| Institute of Applied Optimization ([IAO](http://iao.hfuu.edu.cn)),
| School of Artificial Intelligence and Big Data,
| [Hefei University](http://www.hfuu.edu.cn/english/),
| Hefei, Anhui, China.
| Web: <http://iao.hfuu.edu.cn/team/director>
| Email: <tweise@hfuu.edu.cn>, <tweise@ustc.edu.cn>
