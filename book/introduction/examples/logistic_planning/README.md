### Route Planning for a Logistics Company

Logistics always has been a very important application area of optimization.
Therefore, let us there look into a typical real-world optimization task&nbsp;[@WPG2009SRWVRPWEA, @WPRGG2009EFTP].

A logistics company needs to accept and fulfill delivery tasks from its clients.
Let us assume that a client can order one or multiple containers to be delivered to her location within a certain time window.
She will then fill the containers with certain goods, which are then to be transported to a destination location, again within a certain time window.
The logistics company may receive many such customer orders per day, maybe several hundreds to even thousands.
The company may have multiple depots, where containers and trucks are stored.
For each order, it needs to decide which container(s) to use and how to get them to the customer.
The trucks it owns may have different capacities and can carry one or two containers.
Besides using trucks, which can travel freely on the map, it may also be possible to utilize trains.
Trains may have vastly different capacities and follow specific schedules and arrive and depart at fixed times to/from fixed locations.
For each vehicle, different costs could occur.
Containers may be exchanged between vehicles at locations such as parking lots, depots, or train stations.

The company could have the goals to fulfill all transportation requests *at the lowest cost*.
Actually, it might seek to maximize its profit, which could even mean to outsource some tasks to other companies.
The goal of optimization then would be to find the assignment of containers to delivery orders and vehicles and of vehicles to routes, which maximizes the profit.
And it should do so within a limited, feasible time.

