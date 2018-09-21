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
  return(make.int(factorial(m*n)/((factorial(m))^n)));
}

for(n in 3L:5L) {
  for(m in 2L:5L) {
    cat(n, "|", m, "|", set.size(n, m), "\n", collapse="", sep="");
  }
}