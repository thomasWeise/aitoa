# Introduction

Today, algorithms influence a bigger and bigger part in our daily life and the economy.
They support us by suggesting good decisions in a variety of fields, ranging from engineering, timetabling and scheduling, product design, over travel and logistic planning to even product or movie recommendations.
They will be the most important element of the transition of our industry to smarter manufacturing and intelligent production, where they can automate a variety of tasks, as illustrated in [@fig:intelligent_manufacturing].

![Examples for applications of optimization, computational intelligence, machine learning techniques in five fields of smart manufacturing: the production itself, the delivery of the products, the management of the production, the products and services, and the sales level.](\relative.path{intelligent_manufacturing.svgz}){#fig:intelligent_manufacturing width=99%}

[Optimization](http://en.wikipedia.org/wiki/Mathematical_optimization) and [Operations Research](http://en.wikipedia.org/wiki/Operations_research) provide us with algorithms that propose good solutions to such a wide range of questions.
Usually, it is applied in scenarios where we can choose from many possible options.
The goal is that the algorithms propose solutions which minimize (at least) one resource requirement, be it costs, energy, space, etc.
If they can do this well, they also offer another important advantage: Solutions that minimize resource consumption are often not only cheaper from an immediate economic perspective, but also better for the environment, i.e., with respect to ecological considerations.

Thus, we already know three reasons why optimization will be a key technology for the next century, which silently does its job behind the scenes:

1. Any form of intelligent production or smart manufacturing needs automated decisions and since these decisions should be *intelligent*, they can only come from a process which involves optimization in one way or another.
2. In global and local competition in all branches of industry and all service sectors those institutions who can reduce their resource consumption and costs while improving product quality and production efficiency will have the edge -- and one technology for achieving this is better planning via optimization.
3. Our world suffers from both depleting resources and too much pollution.
   Optimization can "give us more while needing less,", i.e., often inherently leads to more environmentally friendly processes.

But how can algorithms help us to find solutions for hard problems in a variety of different fields?
What does "variety" even mean?
How general are these algorithms?
And how can they help us to make good decisions?
And how can they help us to save resources?

In this book, we will answer all of these questions.
We will explore quite a lot of different optimization algorithms.
We will look at their actual implementations and we will apply them to example problems to see what their strengths and weaknesses are.
But before we do all of that, let us first get a feeling about typical use cases of optimization.

\relative.input{examples/logistic_planning/README.md}
\relative.input{examples/bin_packing/README.md}
\relative.input{examples/jssp/README.md}
