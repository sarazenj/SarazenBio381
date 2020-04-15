# ---------------------------------------------
# Randomization tests
# 03 Apr 2020
# JCS
# ---------------------------------------------

# Statisical p is probability of obtaining the observed results (or something more extreme) if the null hypothesis were true p(data|H0)

# Null hypothesis of "no effect"
# variation is caused by measureemnt error ot other unspecified (and less important) sources of variation

# two advantages of randomization tests: 
# relaxes assumptions of standard parametric tests (normality, balances sample sizes, common variance)
# gives a more intuitive understanding of statistical probability

# Steps in randomization test --------------------------------

# 1. Define a metric X as a single number to represent pattern
# 2. Calculate X(obs) the metric for the empirical (=observed) data that we start with
# 3. Randomize or reshuffle the data. Randomize in a way that would uncouple their assoiciation to treatment groups. Ideally, the randomization only affects the pattern of treatment effects in the data (such as sample sizes) are preserved in the randomization. Simulate the null hypothesis!
# 4. For this single randomization, calculate X(sim). If the null hypothesis is true X(obs) is similar to X(sim). If null hypothesis is false X(obs) is very different from X(sim).
# 5. Repeat steps (3) and (4) many times. (typically n=1000). This will let us visualize as a histogram the distribution of X(sim); distribution of X values when the null hypothesis is true. 
# 6. Estimate the tail probability of the observed metric (or something more extreme) given the null distribution (p(X(obs)|H0).

# Preliminaries --------------------------------

library(ggplot2)
library(TeachingDemos)

# random number generator setting up

set.seed(100)
char2seed("finally Friday") # choose anything that you want for characters
char2seed("finally Friday", set=FALSE) # kicks back what the actual seed is, under the random number sequence

Sys.time()
as.numeric(Sys.time())
my_seed <- as.numeric(Sys.time())  # let the system set the seed and then just save it
set.seed(my_seed)

char2seed("finally Friday") # set the seed for the day

# create treatment groups
trt_group <- c(rep("Control",4),rep("Treatment",5))
print(trt_group)

# create response variable
z <- c(runif(4) + 1, runif(5) + 10) # becomes a vectorized operation
print(z)

# combine vectors into a single data frame
df <- data.frame(trt=trt_group,res=z)
print(df)

# look at means in the two groups
obs <- tapply(df$res, df$trt, mean)
# this function first wants the data (this case the response variable) then the grouping variable. and then give it the function that it is going to apply to that subset of the data
print(obs)

# create a simulated data set -------------------------------- 

# set up a new data frame
df_sim <- df
df_sim$res <- sample(df_sim$res)
# sample reorders the values, keeps the same number of values in each group though
print(df_sim)

# look at the means in the two groups of randomized data
sim <- tapply(df_sim$res ,df_sim$trt, mean)
print(sim)
# the difference between these groups is not as difference, by chance we can get a difference this big

# Build functions --------------------------------

# ---------------------------------------------
# FUNCTION read_data
# description: read in (or generate) data set for analysis
# inputs: file name (or nothing, as in this demo)
# outputs: 3 column data frame of observed data (ID, x, y )
###############################################
read_data <- function(z=NULL) {
  if(is.null(z)){
    x_obs <- 1:20
    y_obs <- x_obs + 10*rnorm(20)
    df <- data.frame(ID=seq_along(x_obs),
                     x_obs,
                     y_obs)}
#  df <- read.table(file=z,
 #                  header = TRUE,
  #                 stringsAsFactors = FALSE)
   return(df)


} # end of read_data
#----------------------------------------------
# read_data() 

# ---------------------------------------------
# FUNCTION get_metric
# description: calculate metric for randomization test
# inputs: 2-column data frame for regression
# outputs: regression slope
###############################################
get_metric <- function(z=NULL) {
  if(is.null(z)){
    x_obs <- 1:20
    y_obs <- x_obs + 10*rnorm(20)
    z <- data.frame(ID=seq_along(x_obs),
                    x_obs,
                    y_obs)}
  
  . <- lm(z[,3]~z[,2])
  . <- summary(.)
  . <- .$coefficients[2,1]
  slope <- .
  return(slope)

} # end of get_metric
#----------------------------------------------
# get_metric()

## . is a temporary holder

# what is coming in to this function is the original data, and what is coming out is the randomized version

# ---------------------------------------------
# FUNCTION shuffle_data
# description: randomize data for regression analysis
# inputs: 3 column data frame (ID, xvar, yvar)
# outputs: 3 column data frame (ID, xvar, yvar)
###############################################
shuffle_data <- function(z=NULL) {
  if(is.null(z)){
    x_obs <- 1:20
    y_obs <- x_obs + 10*rnorm(20)
    z <- data.frame(ID=seq_along(x_obs),
                    x_obs,
                    y_obs)}
  
z[,3] <- sample(z[,3])

return(z)

} # end of shuffle_data
#----------------------------------------------
# shuffle_data()

# ---------------------------------------------
# FUNCTION get_pval
# description: calculate p value from simulation
# inputs: List of observed metric and vector of simulated metrics
# outputs: lower and upper tail probability value
###############################################
get_pval <- function(z=NULL) {
  if(is.null(z)){
    z <- list(rnorm(1),rnorm(1000)) }
  p_lower <- mean(z[[2]]<=z[[1]]) ### asking what is the proportion of the 1000 cases we are looking at for which the simulated value is less thatn the observed value - lower tail probability
  p_upper <- mean(z[[2]]>=z[[1]])

  
return(c(pL=p_lower,pU=p_upper))
} # end of get_pval
#----------------------------------------------
# get_pval() # pvalues together add up to 1 

# ---------------------------------------------
# FUNCTION plot_ran_test
# description: create a ggplot of histogram of simulated values
# inputs: list of observed metric and vector simulated metrics
# outputs: saved ggplot graph
###############################################
plot_ran_test <- function(z=NULL) {
  if(is.null(z)){
    z <- list(rnorm(1),rnorm(1000)) }
  df <- data.frame(ID=seq_along(z[[2]]), sim_x=z[[2]])
  p1 <- ggplot(data=df, mapping=aes(x=sim_x))
  p1 + geom_histogram(mapping=aes(fill=I("goldenrod"),
                                  color=I("black"))) +
    geom_vline(aes(xintercept=z[[1]],col="blue"))

} # end of plot_ran_test
#----------------------------------------------
# plot_ran_test()



# running the code! --------------------------------

n_sim <- 1000 # number of simulated data sets
x_sim <- rep(NA,n_sim) # set up empty vector for simulated slopes

df <- read_data() # get (fake) data
x_obs <- get_metric(df) # get slope of observed data

# (seq_len looks for a single number that creates a sequence)
for (i in seq_len(n_sim)) {
  x_sim[i] <- get_metric(shuffle_data(df)) # run similation
}

slopes <- list(x_obs,x_sim) 
get_pval(slopes)
plot_ran_test(slopes)

# blue line splits into 2 pieces, the observed slope is much higher than most of the simulated


# Two key questions for this:
#1 what is the metric that we are going to use?
#2 proceedure for shuffling the data