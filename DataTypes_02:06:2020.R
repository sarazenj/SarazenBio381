# more functions and tricks with atomic vectors
# 06 Feb 2020
#JCS


#   -----------------------------------------------------------------------

# create an empty vector and specify its mode and length
z <- vector(mode='numeric',length=0)
z <- c(z,5)
print(z)
# dynamic sizing don't do this in R

# instead, preallocate space to a vector
z <- rep(0,100)
head(z) #gives first 6 or so lines of vector
# this way would have 0s at the end if we eventually enter less values than 100

# fill with NA values - this is the prefered way!
z <- rep(NA,100)
head(z)

typeof(z)
z[1] <- "Washington"
typeof(z)

v_size <- 100 #specify the size
my_vector <- runif(v_size)
my_names <- paste("Species", seq(1:length(my_vector)),sep="")
head(my_names)
names(my_vector) <- my_names
head(my_vector)

#########

# rep function for repeating elements
rep(0.5,6)
rep(x=0.5, times=6)
rep(times=6, x=0.5)
rep(6,0.5) # this doesn't work, not putting in the correct spot
my_vec <- c(1,2,3)
rep(x=my_vec,times=2)
rep(x=my_vec,each=2)
rep(x=my_vec,times=my_vec)
rep(x=my_vec,each=my_vec)

# using seq to create regular sequences
seq(from=2, to=4)
2:4
`:`(2,4)
## previous 3 statements are all the same for R, get the same output
seq(from=2,to=4,by=0.5)
x <- seq(from=2, to=4, length=7)
print(x)
my_vec <- 1:length(x)
seq_along(my_vec)

# using random number generator
runif(5) # there is a default setting which gives numbers between 0 and 1
runif(n=5,min=100,max=110)

#rnorm for normal
rnorm(6)
rnorm(n=5,mean=100,sd=30)

library(ggplot2x)
z <- runif(1000)
qplot(x=z)
z <- rnorml(1000)
qplot(x=z)

# use sample function to draw random values from an existing vector
long_vec <- seq_len(10)
print(long_vec)
sample(x=long_vec)
sample(x=long_vec, size=3)
sample(x=long_vec,size=16,replace=TRUE)
my_weights <- c(rep(20,5), rep(100,5))
print(my_weights)

sample(x=long_vec,replace=TRUE, prob=my_weights)



# Subsetting --------------------------------------------------------------
# techniques for subsetting index values

# subset with positive index values
z <- c(3.1, 9.2, 1.3, 0.4, 7.5)
z[c(2,3)]

#subset with negative values
z[-c(1,5)]

# create a logical vector of conditions for subsetting
z[z<3]

tester <- z<3
print(tester)
z[tester]

# which function to find slots
which(z<3) 
z[which(z<3)]

# use length for relative positioning
z[-c(length(z):(length(z)-2))] # length goes to maximum length of the sequence to 2 elements less

# also subseting named vector elements
names(z) <- letters[1:5]
z
z[c("b","b")] # we can pull out repeated elements 
#######################################################
################ THIS SEEMS LIKE IT COULD BE HELPFUL! #

# relational operators
# < less than
# > greater than
# <= less than or equal
# greater than or equal
# == equal

# logical operators
# ! converts to NOT
# & and (vector)
# | or (vector)
# xor(a,b) a or b, but not a and b
# && and (first element)
# || or (first element)

# examples
x <- 1:5
y <- c(1:3,7,7)
x == 2
x != 2

x == 1 & y == 7
x
y

x == 1 & y == 7 
x == 1 | y ==7
x == 3 | y ==3
xor(x==3,y==3)

x == 3 && y ==3 # this only evaluates the first element in the vector

# subscripting with missing values
set.seed(90)
z <- runif(10)
z
z < 0.5
z[z < 0.5]

which(z < 0.5)
z[which(z<0.5)]

zD <- c(z,NA,NA)
zD[zD<0.5]
zD[which(zD<0.5)]
