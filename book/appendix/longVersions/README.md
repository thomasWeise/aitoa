## Long Algorithm Versions

Here we put the longer, more comprehensive algorithm versions which we have moved to the back to make the actual discussions of algorithms more concise and easier to understand.

### Long Version of the Memetic Algorithm {#sec:memeticAlgorithmLong}

1. $I\in\searchSpace\times\realNumbers$ be a data structure that can store one point&nbsp;$\sespel$ in the search space and one objective value&nbsp;$\obspel$.
2. Allocate an array&nbsp;$P$ of length&nbsp;$\mu+\lambda$ instances of&nbsp;$I$.
3. For index&nbsp;$i$ ranging from&nbsp;$0$ to&nbsp;$\mu+\lambda-1$ do
    a. If the termination criterion has been met, jump directly to step&nbsp;5.
    b. Store a randomly chosen point from the search space in $\elementOf{\arrayIndex{P}{i}}{\sespel}$.
    c. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
    d. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
    e. **Local Search:** For each point&nbsp;$\sespel'$ in the search space neighboring to $\elementOf{\arrayIndex{P}{i}}{\sespel}$ according to the unary search operator do:
    	 i. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
       ii. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
       iii. If the termination criterion has been met, jump directly to step&nbsp;5.
       iv. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}$, $\obspel'$ in&nbsp;$\elementOf{\arrayIndex{P}{i}}{\obspel}$, stop the enumeration, and go back to step&nbsp;*3.e*.    
4. Repeat until the termination criterion is met:
    f. Sort the array&nbsp;$P$ according to the objective values such that the records with better associated objective value&nbsp;$\obspel$ are located at smaller indices. For minimization problems, this means elements with smaller objective values come first.
    g. Shuffle the first&nbsp;$\mu$ elements of&nbsp;$P$ randomly.
    h. Set the first source index&nbsp;$p=-1$.
    i. For index&nbsp;$i$ ranging from&nbsp;$\mu$ to&nbsp;$\mu+\lambda-1$ do
        i. Set the source index&nbsp;$p1$ to&nbsp;$p=\modulo{(p+1)}{\mu}$, i.e., make sure that every one of the&nbsp;$\mu$ selected points is used approximately the same number of times.
        ii. Randomly choose another index&nbsp;$p2$ from $0\dots(\mu-1)$ such that&nbsp;$p2\neq p$.
        iii. Set&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}=\searchOp_2(\elementOf{\arrayIndex{P}{p}}{\sespel}, \elementOf{\arrayIndex{P}{p2}}{\sespel})$, i.e., derive a new point in the search space for the record at index&nbsp;$i$ by applying the binary search operator to the points stored at index&nbsp;$p$ and&nbsp;$p2$.        
        iv. Apply the representation mapping $\solspel=\repMap(\elementOf{\arrayIndex{P}{i}}{\sespel})$ to get the corresponding candidate solution&nbsp;$\solspel$.
        v. Compute the objective objective value of&nbsp;$\solspel$ and store it at index&nbsp;$i$ as well, i.e., $\elementOf{\arrayIndex{P}{i}}{\obspel}=\objf(\solspel)$.
        vi. **Local Search:** For each point&nbsp;$\sespel'$ in the search space neighboring to $\elementOf{\arrayIndex{P}{i}}{\sespel}$ according to the unary search operator do:
		    	  A. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the representation mapping&nbsp;$\solspel'=\repMap(\sespel')$.
		        B. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
		        C. If the termination criterion has been met, jump directly to step&nbsp;5.
		        D. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\sespel'$ in the variable&nbsp;$\elementOf{\arrayIndex{P}{i}}{\sespel}$, $\obspel'$ in&nbsp;$\elementOf{\arrayIndex{P}{i}}{\obspel}$, stop the enumeration, and go back to step&nbsp;*4.i.vi*.
5. Return the candidate solution corresponding to the best record in&nbsp;$P$ to the user.
