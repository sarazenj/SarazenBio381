# Probability distributions
# 18 Feburary 2020
# d probability density function
# p cumulative probability distribution
# q quantile function (inverse of p)
# r random number generator

### command + = zoom in
### command - = zoom out


# Poisson distribution ----------------------------------------------------

# discrete 0 to infinity
# parameter lamba > 0 (continuous)
# constant rate parameter (observations per unit time or unit area)

library(ggplot2)
library(MASS)

# d function for probability density
hits <- 0:10
my_vec <- dpois(x=hits, lambda = 1) # one event per sampling area
qplot(x=hits,
      y=my_vec,
      geom = "col", 
      color=I("black"), # black to outline the colors of the plot
      fill=I("goldenrod")) # use I for the identity funtion for simple 
# shape is highest on the left side

my_vec <- dpois(x=hits, lambda = 4.4) 
qplot(x=hits,
      y=my_vec,
      geom = "col", 
      color=I("black"), 
      fill=I("goldenrod"))
# shape is closer to the symetric but not quite. highest prob is occuring around 4
sum(my_vec) # this doesn't sum to 1 because hits only goes till 10

# for the poisson with lambda = 2 
# what is the probabilty that a single draw will yield x=0  ?? 
dpois(x=0, lambda = 2)

hits <- 0:10
my_vec <- ppois(q=hits, lambda = 2)
qplot(x=hits,
      y=my_vec,
      geom = "col", 
      color=I("black"), 
      fill=I("goldenrod"))

# for poisson with lambda = 2
# what is the probability that a single random draw will yield x <= 1?
# p function is the cummulative probabilty function

ppois(q=1,lambda = 2)

p1 <- dpois(x=1, lambda=2)
print(p1)
p2 <- dpois(x=0, lambda = 2)
print(p2)
p1 + p2

# the q function is the inverse of p
qpois(p=0.5,lambda=2.5)
# answer is 2 because integer count

# simulate a poisson to get acutal values
ran_pois <- rpois(n=1000, lambda = 2.5)
qplot(x=ran_pois,
      color=I("black"), 
      fill=I("goldenrod"))
quantile(x=ran_pois,probs = c(0.025,0.975))


# Binomial ----------------------------------------------------------------

# p = probability of dichotomous outcome
# size = number of trials
# x = possible outcomes 
# outcome x is bounded between 0 and size 

# density function for binomial 
hits <- 0:10
my_vec <- dbinom(x=hits, size=10, prob=0.5)
qplot(x=hits,
      y=my_vec,
      geom = "col", 
      color=I("black"), 
      fill=I("goldenrod"))

# what is the probability of getting 5 heads out of 10 tosses?
dbinom(x=5, size=10, prob=0.5)
# the probability is not 0.5


# biased coin
hits <- 0:10
my_vec <- dbinom(x=hits, size=10, prob=0.005)
qplot(x=0:10,
      y=my_vec,
      geom="col",
      col=I("black"),
      fill=I("goldenrod"))

# p function for tail probability 
# probability of 5 or fewer heads out of 10 tosses
pbinom(q=5,size=10,prob=0.5)
pbinom(q=4,size=9,prob=0.5)

# what is the 95% confidence interval for 100 trials with p = 0.7
qbinom(p=c(0.025,0.975),
       size=100,
       prob=0.7)

# how does this compare to a sample interval for real data? rbiom will give a random set of values
my_coins <- rbinom(n=50,
                    size=100,
                    prob=0.50)

qplot(x=my_coins,
      color=I("black"),
      fill=I("goldenrod"))
quantile(x=my_coins,probs=c(0.025, 0.975))


# Negative binomial -------------------------------------------------------

# number of failures in a series of 
# (Bernouli) with p= probability of success (=size)
# before a targeted number of successes (=size) generates a distribution that is more heterogenous ("overdispersed") than poisson
# Poisson

hits

# we are saying, how many failures (get tails) will you get beofre we accumulate 5 heads

hits <- 0:40
my_vec <- dnbinom(x=hits,
                  size=5,
                  prob=0.5)

qplot(x=hits,
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))

# geometric series is a special case where number of successes = 1. Each bar is a constant fraction of the one that came before it with prob 1-p

my_vec <- dnbinom(x=hits,
                  size=1, 
                  prob=0.1)

qplot(x=hits,
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod")) # each bar is 90% lower than the previous one

# alternatively, specify mean = mu of distribution and size
# this give us a poisson with a lambda value that varies
# dispersion parameter is the shape parameter is the shape parameter from a gamma distribution as it increases, the distribution the variance gets smaller

nbi_ran <- rnbinom(n=1000, size=10,mu=5)
qplot(nbi_ran,
      color=I("black"),
      fill=I("goldenrod"))