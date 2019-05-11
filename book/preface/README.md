# Preface {-}

After I wrote *Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB] during my time as PhD student more than ten years ago, I now want to write a more direct guide to optimization, optimization algorithms, and metaheuristics.
Currently, this book is in a very early stage of development.
It is work-in-progress, so expect many changes.
This [book](http://thomasweise.github.io/aitoa/index.html) is available as [pdf](http://thomasweise.github.io/aitoa/aitoa.pdf), [html](http://thomasweise.github.io/aitoa/aitoa.html), [epub](http://thomasweise.github.io/aitoa/aitoa.epub), and [azw3](http://thomasweise.github.io/aitoa/aitoa.azw3).

This book is intended to be accessible and easy to read.
In my old book&nbsp;[@WGOEB], I tried to focus mainly on the abstract algorithms and sometimes described what problems we can solve with them.
This, however, may not give the reader a good intuition about how the algorithms work in practice, what things to look for when solving a problem, or how we can get from a simple, working, proof-of-concept approach to an efficient solution for a given problem.
So in this book, we follow more of a "learning-by-doing" approach, by trying to solve one practical optimization problem as example theme throughout the book.
All algorithms are directly implemented and applied to that problem after we introduce them.
This allows us to discuss their strengths and weaknesses based on their actual results.
Based on these discussions, we step-by-step try to improve the algorithms, moving from very simple approaches which do not work well to efficient metaheuristics.
We will partially sacrifice the formal and abstract structure of*&nbsp;[@WGOEB] and introduce concepts "as they come," with the goal to increase the accessibility of the ideas.

```
@book {aitoa,
  author    = {Thomas Weise},
  title     = {An Introduction to Optimization Algorithms},
  year      = {2018--\meta.year},
  publisher = {Institute of Applied Optimization ({IAO}),
               Faculty of Computer Science and Technology,
               Hefei University},
  address   = {Hefei, Anhui, China},
  url       = {http://thomasweise.github.io/aitoa/},
  edition   = {\meta.date}
}
```

As said, we will be using a lot of concrete examples and algorithm implementations, which are written in the programming language [Java](http://en.wikipedia.org/wiki/Java_(programming_language)).
All source code is published in the repository *[thomasWeise/aitoa-code](\repo.name)* on [GitHub](http://www.github.com) and also freely accessible.
Often, we will just look at certain portions of the code.
These excerpts may just be parts of a class, where we omit methods or member variables, or even just snippets from functions.
Sometimes we may omit even some portions of the code and just describe them in a comment.
However, each source code listing is accompanied by a *(src)* link in the caption linking to the current full version of the file in the GitHub repository.
If you discover any error in any of the code examples, please [file an issue](http://github.com/\repo.name/issues).

This book is written using our automated book writing environment, which integrates GitHub, [Travis CI](http://www.travis-ci.org), and [docker](http://www.docker.com)-[hub](http://hub.docker.com) (see <http://iao.hfuu.edu.cn/157>).
The complete text of the book is actively written and available in the repository *[thomasWeise/aitoa](http://github.com/thomasWeise/aitoa)* on GitHub.
There, you can also submit *[issues](http://github.com/thomasWeise/aitoa/issues)*, which can be change requests, suggestions, discovered errors or typos, or you can inform me that something is unclear, so that I can improve the book.


| &nbsp;
| Repository: <http://github.com/thomasWeise/aitoa>
| This Commit: [\meta.commit](http://github.com/thomasWeise/aitoa/commit/\meta.commit)
| Time and Date: \meta.time
| Author: [Thomas Weise](http://iao.hfuu.edu.cn/team/director)
| Example Source Repository: <\repo.name>
| This Example Source Commit: [\repo.commit](\repo.name/commit/\repo.commit)
| &nbsp;


This book is released under the Attribution-NonCommercial-ShareAlike 4.0 International license (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0), see [http://creativecommons.org/licenses/by-nc-sa/4.0/](http://creativecommons.org/licenses/by-nc-sa/4.0/) for a summary.


| &nbsp;
| Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/team/director)
| Institute of Applied Optimization ([IAO](http://iao.hfuu.edu.cn))
| Hefei University,
| Hefei, Anhui, China.
| Web: <http://iao.hfuu.edu.cn/team/director>
| Email: <tweise@hfuu.edu.cn>, <tweise@ustc.edu.cn>
