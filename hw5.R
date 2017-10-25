library(knitr)
library(data.table)
library(ggplot2)
library(formatR)

data <- fread("C:/Users/ngraetz/Documents/repos/demg609/hw4_data_clean.csv")
setnames(data, 'nDx i', 'nDx_i')

# 1. Calculate multiple decrement life table for period.

# Calculate npx from lx 
for(r in 1:length(data[, lx])) {
  lx_n <- data[r+1, lx]
  data[r, npx := lx_n / lx]
  if(r == length(data[, lx])) data[r, npx := 0]
}
data[, nqx := 1 - npx]

# Calculate nqx_i
data[, nqx_i := nqx * (nDx_i / nDx)]

# Calculate ndx_i
data[, ndx_i := nqx_i * lx]

# Calculate lx_i
for(r in 1:length(data[, ndx_i])) {
  data[r:length(data[, ndx_i]), lx_i := sum(ndx_i)]
}

# Calculate ndx
  for(r in 1:length(data[, lx])) {
    lx_n <- data[r+1, lx]
    data[r, ndx := lx - lx_n]
    if(r == length(data[, lx])) data[r, ndx := lx]
  }

# Calculate the probability that someone aged x will eventually exit from cause i
  data[, prob_cause_i := lx_i / lx]
  
  lt <- data
  
# 2. 
  lt[x == 0, prob_cause_i]
  lt[x == 50, prob_cause_i]

# 3. 
  lt[, R_prop_i := (nDx - nDx_i) / nDx]
  lt[, npx_minus_i := npx^R_prop_i]
  
# 4.
  prod(lt[x < 85, npx_minus_i]) / prod(lt[x < 85, npx])
  
  # Alternatively, calculate *_lx_-i and do the sum
  #   lt[x == 25, lx] / lt[1, lx]
  
  # An individual is ~5% more likely to survive to 85 if there were no accidents,
  # relative to the master life table that includes accidents.
  # (absolute difference is only ~1%)

  