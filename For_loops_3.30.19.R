# ---------------------------------------------
# Basic anatomy and use of for loops
# 30 Mar 2020
# JCS
# ---------------------------------------------

# Anatomy of a for loop

# For (var in seq) { # start of the loop

# body of a for loop 

# } # end of the loop

# var is a counter variable that holds the current value of the counter in the loop
# seq is an integer vector (or vector of character strings) that defines the starting and ending values of the loop

# suggest using i,j,k for var (counter)

# How to NOT set up your for loops
my_dogs <- c("chow", "akita", "malamute", "husky", "samoyed")

for (i in my_dogs) { 
  print(i) 
}
## in this way, you can only access the names in character sequence, not their position in the sequence

# set it up in this way instead
for (i in 1:length(my_dogs)) {
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}

## 1 will change each time the for loop goes through, it will go to 2, 3, so on
## this is good because you have an integer sequence that is the correct length for your steps

# potential hazard: suppose our vector is empty!
my_bad_dogs <- NULL

for (i in 1:length(my_bad_dogs)){
  cat("i =", i, "my_bad_dogs[i] =", mmy_bad_dogs[i], "\n")
}



# safer way to code var in the for loop is to use seq_along 
for (i in seq_along(my_dogs)) {
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}

# handles the empty vector correctly!
for (i in seq_along(my_bad_dogs)){
  cat("i =", i, "my_bad_dogs[i] =", mmy_bad_dogs[i], "\n")
}
# output is nothing here, because my_bad_dog is empty


# could also define vector length from a constant
zz <- 5
for(i in seq_len(zz)) {
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}



# Tip #1  --------------------------------
# Do not change object dimensions inside a loop
# avoid these functions (cbind,rbind,c,list)

my_dat <- runif(1)
for (i in 2:10) {
  temp <- runif(1)
  my_dat <- c(my_dat,temp) # don't do this!
  cat("loop number =", i, "vector element =", my_dat[i], "\n")
}

print(my_dat)

# Tip #2 --------------------------------
# Don't do things in a loop if you do not need to

for (i in 1:length(my_dogs)) {
  my_dogs[i] <- toupper(my_dogs[i]) # don't do this in loop
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}

# can easily do this outside the loop, just a vector operation
z <- c("dog","cat","pig")
toupper(z)

# Tip #3 --------------------------------
# Do not use a loop if you can vectorize!

my_dat <- seq(1:10)
for (i in seq_along(my_dat)) {
  my_dat[i] <- my_dat[i] + my_dat[i]^2
  cat("loop number =", i, "vector element =", my_dat[i], "\n")
}

# no loop needed here!
z <- 1:10
z <- z + z^2
print(z)

# Tip #4 --------------------------------
# understand distinction between the counter variable i, and the vector element z[i]

z <- c(10,2,4)
for (i in seq_along(z)) {
  cat("i=",i,"z[i] =", z[i], "\n")
}

# What is the value of i at the end of the loop?
print(i)
# 3 was the final value assinged to it at the end of the loop
print(z)

# Tip #5 --------------------------------
# use next to skip certain elements in the loop

z <- 1:20
# suppose we want to work only with odd-numbered elements?

for (i in seq_along(z)) {
  if (i %% 2==0) next
  print(i)
}
# next function to skip, use in conjuction with an if statement

# another method, probably faster, (why?)

z <- 1:20
z_sub <- z[z %% 2!=0] # contrast with the logical expression in loop
length(z)
length(z_sub)
for (i in seq_along(z_sub)) {
  cat("i =", i, "z_sub[i] =", z_sub[i],"\n")
}
# subsetting happened outside the loop, so it went faster than what we did above


# Tip #6 --------------------------------
# use break function to set up a conditional to break out of a loop early

# create a simple random walk population model function

# ---------------------------------------------
# FUNCTION ran_walk
# description: scochastic random walk
# inputs: times = number of time stamps
#         n1 = inital population size (=n[1])
#         lambda = finite rate of increase
#         noise_sd = standard deviation of a 
#               normal distribution with mean 0
# outputs: vector n with population > 0
#           until extinction then NA values
###############################################
library(ggplot2)
library(tcltk)

ran_walk <- function(times=100,
                     n1=50,
                     lambda=1.0,
                     noise_sd=10) {

  n <- rep(NA,times) # creating the output vector - impt to do this right away
  n[1] <- n1 # initalize starting population size
  noise <- rnorm(n=times,mean=0,sd=noise_sd) # create random noise vector
  
  for (i in 1:(times - 1)) { # start of for loop
    n[i + 1] <- n[i]*lambda + noise[i]
    if(n[i + 1] <=0) { # start of if statement
      n[i + 1] <- NA
      cat("Population extinction at time", i, "\n")
      tkbell()
      break } # end of if statement
  } # end of the for loop
  return(n)
} # end of function
# end of ran_walk
#----------------------------------------------

# explore model parameters interactively
# with simple graphics

pop <- ran_walk()
qplot(x=1:100,y=pop,geom="line")

# check out performance with no noise
pop <- ran_walk(noise_sd = 5, lambda = 0.98)
qplot(x=1:100,y=pop,geom="line")

# Double for loops --------------------------------
# embed one loop inside another

m <- matrix(round(runif(20),digits=2),nrow=5)
# 1) loop over the rows
for (i in 1:nrow(m)) {
  m[i,] <- m[i,] + i 
}
print(m)


m <- matrix(round(runif(20),digits=2),nrow=5)
# 2) loop over columns
for (j in 1:ncol(m)) {
  m[,j] <- m[,j] + j
}
print(m)

# loop over rows and columns with double for loop
m <- matrix(round(runif(20),digits=2),nrow=5)
for (i in 1:nrow(m)) { # start of outer (row) loop
  for (j in 1:ncol(m)) # start of inner (column) loop
    m[i,j] <- m[i,j] + i + j
} # end of the inner (column) loop
} # end of the outer (row) loop
# row, then all the columns, next row, all the columns
print(m)

