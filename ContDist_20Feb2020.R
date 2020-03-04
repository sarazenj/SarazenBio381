# exploring continuous distributions 
# 20 Feb 2020
# JCS

library(ggplot2)
library(MASS)


# Uniform -----------------------------------------------------------------

qplot(x=runif(n=100,min=1,max=6),
              color=I("black"),
              fill=I("goldenrod"))

qplot(x=runif(n=1000,min=1,max=6),
      color=I("black"),
      fill=I("goldenrod"))

qplot(x=sample(1:6,size=1000,replace=TRUE))


# Normal distribution -----------------------------------------------------

my_norm <- rnorm(n=100,mean=100,sd=2)

qplot(x=my_norm,
      color=I("black"),
      fill=I("goldenrod"))

# most of variables are normally distributed so many statistical analyses use it

my_norm <-rnorm(100,mean=2,sd=2)
qplot(x=my_norm)



# Gamma distribution ------------------------------------------------------

# may use for continuous data greater than zero
my_gamma <- rgamma(n=100,shape=1,scale=10)
qplot(x=my_gamma,
      color=I("black"),
      fill=I("goldenrod"))

# gamma with shape = 1 is exponential with scale = mean
my_gamma <- rgamma(n=100,shape=1,scale=0.1)
qplot(x=my_gamma,
      color=I("black"),
      fill=I("goldenrod"))

# increasing shape parameter distribution looks more normal
my_gamma <- rgamma(n=100,shape=20,scale=1)
qplot(x=my_gamma,
      color=I("black"),
      fill=I("goldenrod"))

# scale parameter changes both mean and variance!
# mean = shape*scale
# vairance = shape*scale^2


# Beta distribution -------------------------------------------------------

# continuous, but bounded between 0 and 1

# analagous to binomial, but with a continuous distribution of possible values

# p(data|parameters)

# p(parameters|data)

# P(parameters|data) = maximun likelihood estimator of parameters

# shape1 = number of successes + 1
# shape2 = number of failures + 1

my_beta <- rbeta(n=1000,shape1=50,shape2=50)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))
# distribution is broad, but more narrow with more data.
# beta distribution is most helpful at small sample size

# beta with 3 heads and no tails
my_beta <- rbeta(n=1000,shape1=4,shape2=1)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))

# shape and scale less than 1.0 gives u-shaped curve
my_beta <- rbeta(n=1000,shape1=0.2,shape2=0.1)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))



# Estimate parameters from data -------------------------------------------

x <- rnorm(1000,mea=92.5,sd=2.5)
qplot(x=x,
      color=I("black"),
      fill=I("goldenrod"))

# fitting distribution of the values of X to a normal
# gives us the parameters associated with a distribution
fitdistr(x,"normal")
fitdistr(x,"gamma") # if data came from a gamma distribution

# then for modeling, we will draw values out from the parameters from the max. liklihood above
x_sim <- rgamma(n=1000,shape=1418,rate=15)
qplot(x=x_sim,
      color=I("black"),
      fill=I("goldenrod"))

