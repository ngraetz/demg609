
library(knitr)
library(data.table)
library(ggplot2)
library(formatR)

mu_a <- .08
l0_a <- 5000
mu_b <- .10
l0_b <- 10000

# 1.
e0_a <- 1/mu_a
e0_b <- 1/mu_b

# 2. 
lt <- data.table(x = seq(0, 100, 5),
                 mu_a = rep(mu_a, 21),
                 mu_b = rep(mu_b, 21))

# Use mu as nmx, use births as radix given stationary population.
calculate_lt <- function(data, mu_var, radix_var) {
  
  # 1. Calculate nmx
  data[, nmx := get(mu_var)]
  
  # All other age groups
  data[, nax := 5 / 2]
  
  # 3. Calculate nqx
  data[, n := 5]
  data[, nqx := (n * nmx) / (1 + ((n - nax) * nmx))]
  data[x == 100, nqx := 1]
  
  # 4. Calculate npx
  data[, npx := 1 - nqx]
  # data[, npx := exp(1)^(-n*nmx)]
  # data[, nqx := 1 - npx]
  
  # 5. Calculate lx
  data[, lx := get(radix_var)]
  for(r in 2:length(data[, lx])) {
    previous_lx <- data[r-1, lx]
    previous_npx <- data[r-1, npx]
    data[r, lx := previous_lx * previous_npx]
  }
  
  # 6. Calculate ndx
  for(r in 1:length(data[, lx])) {
    lx_n <- data[r+1, lx]
    data[r, ndx := lx - lx_n]
    if(r == length(data[, lx])) data[r, ndx := lx]
  }
  
  # 7. Calculate nLx
  for(r in 1:length(data[, lx])) {
    lx_n <- data[r+1, lx]
    # data[r, nLx := (n * lx_n) + (nax * ndx)]
    # if(r == length(data[, lx])) data[r, nLx := lx / nmx]
    data[r, nLx := (lx - lx_n) / nmx]
    if(r == length(data[, lx])) data[r, nLx := lx / nmx]
  }
  
  # 8. Calculate Tx
  for(r in 1:length(data[, lx])) {
    data[r:length(data[, lx])-1, Tx := sum(nLx)]
  }
  
  # 9. Calculate ex
  data[, ex := Tx / lx]
  
  # Don't worry about upper age group
  data <- data[x != 100, ]
  
  return(data)
  
}


# Calculate for Race A and Race B.
lt_a <- calculate_lt(data = copy(lt), mu_var = 'mu_a', radix_var = 'l0_a')
lt_b <- calculate_lt(data = copy(lt), mu_var = 'mu_b', radix_var = 'l0_b')
# Surviving to x birthday in Race A: lt_a[, lx] 
# Surviving to x birthday in Race B: lt_b[, lx] 
# Confirm e0 is the same from #1

# 3. nNx = lx, nDx = ndx

# 4. 
lt_a[, asdr := ndx / nLx]
lt_a[, table := 'Race A']
lt_b[, asdr := ndx / nLx]
lt_b[, table := 'Race B']
combined_lt <- data.table(x = seq(0, 95, 5),
                          nNx = lt_a[, nLx] + lt_b[, nLx],
                          nDx = lt_a[, ndx] + lt_b[, ndx])
combined_lt[, nLx := nNx]
combined_lt[, asdr := nDx / nNx]
combined_lt[, table := 'Race A + B']
combined_lt <- rbind(combined_lt, lt_a, lt_b, fill = TRUE)

# 5. Equations

# 6. Ratio of nNx in B is higher at first, but then drops and A becomes more influential in the combined calculation.
# This is due to B starting with more people, but they die off faster than A.
gg1 <- ggplot(data = combined_lt) +
  geom_line(aes(x = x,
                y = asdr,
                linetype = table),
            size = 1) +
  geom_hline(aes(yintercept = mean(c(lt_a[1, asdr], lt_b[1, asdr]))),
             color = 'red',
             size = 1) + 
  theme_light()

ab_compare <- data.table(x = seq(0, 95, 5),
                         nNx_ratio = lt_b[, lx] / lt_a[, lx])
gg2 <- ggplot(data = ab_compare) +
  geom_line(aes(x = x,
                y = nNx_ratio),
            size = 1) + 
  geom_hline(aes(yintercept = 1),
             color = 'red',
             size = 1) + 
  theme_light()

require(gridExtra)
grid.arrange(gg1, gg2, ncol=2)

