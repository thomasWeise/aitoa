## Example: Route Planning for a Logistics Company

One example field of application for optimization is [logistics](http://en.wikipedia.org/wiki/Logistics).
Let us look at a typical real-world scenario from this field&nbsp;[@WPG2009SRWVRPWEA; @WPRGG2009EFTP]: the situation of a logistics company that fulfills delivery tasks for its clients.
A client can order one or multiple containers to be delivered to her location within a certain time window.
She will then fill the containers with goods, which are then to be transported to a destination location, again within a certain time window.
The logistics company may receive many such customer orders per day, maybe several hundreds to even thousands.
The company may have multiple depots, where containers and trucks are stored.
For each order, it needs to decide which container(s) to use and how to get them to the customer, as sketched in [@fig:logistic_planning].
The trucks it owns may have different capacities and can carry one or two containers.
Besides using trucks, which can travel freely on the map, it may also be possible to utilize trains.
Trains may have vastly different capacities and follow specific schedules and arrive and depart at fixed times to/from fixed locations.
For each vehicle, different costs could occur.
Containers may be exchanged between vehicles at locations such as parking lots, depots, or train stations.

![Illustrative sketch of logistics problems: Orders require us to pick up some items at source locations within certain time windows and deliver them to their destination locations, again within certain time windows. We need to decide which containers and vehicles to use and over which routes we should channel the vehicles.](\relative.path{logistic_planning.svgz}){#fig:logistic_planning width=99%}

The company could have the goals to fulfill all transportation requests *at the lowest cost*.
Actually, it might seek to maximize its profit, which could even mean to outsource some tasks to other companies.
The goal of optimization then would be to find the assignment of containers to delivery orders and vehicles and of vehicles to routes, which maximizes the profit.
And it should do so within a limited, feasible time.

![A Traveling Salesman Problem (TSP) through eleven cities in China.](\relative.path{tsp_china.svgz}){#fig:tsp_china}

Of course, there is a wide variety of possible logistics planning tasks. 
Besides our real-world example above, a classical task is the [Traveling Salesman Problem](http://en.wikipedia.org/wiki/Travelling_salesman_problem) (TSP)&nbsp;[@ABCC2006TTSPACS; @GP2002TTSPAIV], where the goal is to find the shortest round-trip tour through$n$&nbsp;cities, as sketched in [@fig:tsp_china].
Many other scenarios can be modeled as such logistics questions, too:
If a robot arm needs to several drill holes into a circuit board, finding the shortest tour means solving a TSP and will speed up the production process, for instance&nbsp;[@GJR1991OCOPADMACS].