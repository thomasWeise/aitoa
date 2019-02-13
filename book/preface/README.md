# Preface {-}

After I wrote *Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB] during my time as PhD student more than ten years ago, I now want to write a more direct guide to optimization, optimization algorithms, and metaheuristics.
Currently, this book is in a very early stage of development.
It is work-in-progress, so expect many changes.

This book is intented to be a learning-by-doing approach to optimization.
Instead of using too much theoretical background when introducing the different algorithms, we will try to work our way from very simple algorithms to sophisticated methods by solving a very common optimization task.
We will not try to introduce the algorithms from a theoretical perspective, instead we will discuss concepts and theoretical aspects when we encounter them.
We sacrifice a formal and abstract structure with the goal to increase the accessibility of the ideas.

```
@book {aitoa,
  author    = {Thomas Weise},
  title     = {An Introduction to Optimization Algorithms},
  year      = {2018--\meta.year},
  publisher = {Institute of Applied Optimization ({IAO}),
               Faculty of Computer Science and Technology,
               Hefei University},
  address   = {Hefei, Anhui, China},
  url       = {http://thomasweise.github.io/aitoa/aitoa.pdf},
  edition   = {\meta.date}
}
```

In this book, we are using a lot of concrete examples written in the programming language [Java](http://en.wikipedia.org/wiki/Java_(programming_language)).
These are published in the repository *[thomasWeise/aitoa-code](\repo.name)* on [GitHub](http://www.github.com) and also freely accessible.
Often, we will just look at certain portions of the code.
These excerpts may just be parts of a class, where we omit methods or member variables, or even just snippets from functions.
Sometimes we may omit even some portions of the snippet and just describe them in a comment.
However, each source code listing is accompanied by a *(src)* link in the caption linking to the current full version of the file in the GitHub repository.
If you discover any error in any of the code examples, please [file an issue](http://github.com/\repo.name/issues).

This book is written using my automated book writing environment, which integrates GitHub, [Travis CI](http://www.travis-ci.org), and [docker](http://www.docker.com)-[hub](http://hub.docker.com).
The complete text of the book is actively written and available in the repository *[thomasWeise/aitoa](http://github.com/thomasWeise/aitoa)* on GitHub.
As said, there, you can also submit *[issues](http://github.com/thomasWeise/aitoa/issues)*, which can be change requests, suggestions, discovered bugs or typos, or maybe inform me that something is unclear, so that I can improve the book.
Whenever I make a change to the book, maybe resulting from your submitted issue, new versions will automatically be built.
The build process is described at <http://iao.hfuu.edu.cn/157>.


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

