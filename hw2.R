
library(knitr)
library(data.table)
library(ggplot2)
library(formatR)

# A.(1)
# Load data.
data <- fread("C:/Users/ngraetz/Documents/repos/demg609/hw2_data.csv")
data[, pop := as.numeric(pop)]
data[, deaths := as.numeric(deaths)]

# Calculate CDR.
cdr_usa <- sum(data[country == "USA", deaths]) / sum(data[country == "USA", pop])
cdr_russia <- sum(data[country == "Russia", deaths]) / sum(data[country == "Russia", pop])

# A.(2)
data[, asdr := deaths / pop]
ggplot(data = data) +
  geom_line(aes(x = age_start,
                y = log(asdr),
                color = country),
            size = 1) +
  theme_classic()

# A.(3)
# Assumptions of linear growht (mid-year population)

# A.(4)
data[country == "USA", age_prop := pop / sum(pop)]
data[country == "Russia", age_prop := pop / sum(pop)]
ggplot(data = data) +
  geom_line(aes(x = age_start,
                y = age_prop,
                color = country),
            size = 1) +
  theme_classic()

# A.(5)
cdr_usa_wt <- weighted.mean(data[country == "USA", asdr],
                            data[country == "USA", age_prop])
cdr_russia_wt <- weighted.mean(data[country == "Russia", asdr],
                               data[country == "Russia", age_prop])

# A.(6)
usa_ascdr <- weighted.mean(data[country == "USA", asdr],
                           data[country == "Russia", age_prop])

# A.(7)
cmr <- sum(data[country == "Russia", deaths]) / sum(data[country == "USA", asdr] * data[country == "Russia", pop])
cdr_russia / usa_ascdr

# A.(8)
c_age <- sum((data[country == "Russia", age_prop] - data[country == "USA", age_prop]) * 
            ((data[country == "USA", asdr] + data[country == "Russia", asdr]) / 2)) 
c_asdr <- sum((data[country == "Russia", asdr] - data[country == "USA", asdr]) * 
             ((data[country == "USA", age_prop] + data[country == "Russia", age_prop]) / 2)) 
total_diff <- abs(c_age) + abs(c_asdr)
abs(c_age)/total_diff
abs(c_asdr)/total_diff

# A.(9)
# Yes, they overlap

# B.(1)
