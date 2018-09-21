gcd <- function(a, b) {
  if(a == b) { return(a); }
  if(a > b) { return(gcd(a - b, b)); }
  return(gcd(a, b-a));
}

make.int <- function(i) {
  if((i <= .Machine$integer.max)) {
    j <- as.integer(i);
    if((!(is.nan(j))) && (j == i)) {
      return(formatC(j, big.mark = "'", big.interval = 3));
    }
  }
  return(sprintf("%.3G", i));
}

set.size <- function(n, m) {
  factors  <- as.integer(2L:(m*n));
  divisors <- rep(as.integer(2L:m), n);

  while(TRUE) {
    # try to reduce the factors and divisors
    reduced <- FALSE;
    if(length(factors) <= 0L) {
      return("1");
    }
    if(length(divisors) <= 0L) {
      return(make.int(prod(factors)));
    }

# see if we can delete a factor
    for(i in seq_along(factors)) {
      factor <- factors[[i]];
      found  <- which(divisors == factor);
      if(length(found) > 0L) {
        factors  <- factors[-i];
        divisors <- divisors[-(found[[1L]])];
        reduced <- TRUE;
        break;
      }

      # try to further reduce
      for(j in seq_along(divisors)) {
        d <- divisors[[j]];
        k <- gcd(d, factor);
        if(k > 1L) {
          divisors[[j]] <- d %/% k;
          factors[[i]] <- factor %/% k;
          reduced <- TRUE;
          break;
        }
      }
      if(reduced) { break; }
    }
    if(!(reduced)) {
      break;
    }
  }
  return(make.int(prod(factors) / prod(divisors)));
}

for(n in 1L:5L) {
  for(m in 1L:5L) {
    cat(n, "|", m, "|", set.size(n, m), "\n");
  }
}

}