# Basic examples of data types and their uses
# 4 Feb 2020
# JCS

#

#   -----------------------------------------------------------------------

# using the assignment operator
x <- 5 # perfered
y = 4 # legal but not used except in function defaults
y = y + 1
y <- y + 1
y # contents put out on the console
print(y) # this statement always works even if you are in R markdown or somewhere else


#   -----------------------------------------------------------------------

# variable names
z <- 3 # use lower case
plantHeight <- 3 # camel case naming
plant.height <- 3 # avoid periods
plant_height <- # snake case - prefered
. <- 5 # use exclusively for temporary variables


#   -----------------------------------------------------------------------

# combine or concatenate function - c() is function name
z <- c(3.2, 5, 5, 6)
print(z)
typeof(z) # tells us it is a double
is.numeric(z)
is.character(z)

# character variable bracketed by quotes (single or double)
z <- c("perch", "striped base", 'trout')
print(z)

z <- c("this is one 'character string'", "and another")
print(z)

z <- c(c(2,3), c(4.4,6))
z <- c(TRUE,FALSE,FALSE)
typeof(z)
is.integer(z)


#   -----------------------------------------------------------------------

# properties of atomic vectors
# has a unique type
typeof(z)
is.logical(z)

# has a specified length
length(z)
length(zz)

# optional names
z <- runif(5)
print(z)
names(z)
names(z) <- c("chow",
              "pug",
              "beagle",
              "greyhound",
              "akita")
print(z)
z[3] #single element
z[c(3,4)]
z[c("beagle","greyhound")] #pulling out (the names are optional)
z[c(3,3,3)]

# add names when variable is first built (with or without quotes)
z2 <- c(gold=3.3, silver=10, lead=2)
print(z2)
# reset names
names(z2) <- NULL

# name some elements, but not others
names(z2) <- c("copper", "zinc")
print(z2)


#   -----------------------------------------------------------------------

# NA for missing data
z <- c(3.2,3.3,NA)
typeof(z)
length(z)
typeof(z[3])
z1 <- NA
typeof(z1)
is.na(z) # boolean to find NA
!is.na(z) # boolean to find NOT NA
mean(z)
mean(is.na(z)) # not correct operates on booleans
mean(z[!is.na(z)]) # correct

# NaN, -Inf, Inf from numeric division
z <- 0/0
print(z)
typeof(z)
z <- 1/0
print(z)
z <- -1/0
print(z)

# null is nothing 
z <- NULL
typeof(z)
length(z)
is.null(z)


#   -----------------------------------------------------------------------

# Three features of atomic elements

# 1. Coercion
# All atomic are of the same type
# if elements are different, R coerces them
# logical -> integer -> double -> character

z <- c(0.1, 5, "O.2")
typeof(z)
print(z)

# use coersion for useful calculations
a <- runif(10)
print(a)
a > 0.5 # for an inequlity we get back a true or false
sum(a > 0.5) # how many elements are greater than 0.5
mean(a > 0.7) # proportion of values greater than 0.7

# qualifying exam question
# in a normal distribution, approimately what percent of observations from a normal (0,1) are larger than 2.0

mean(rnorm(100000) > 2)

# 2. vectorization
z <- c(10, 20, 30)
z + 1
z2 <- c(1,2,3)
z + z2
z^2

# recycling 
z <- c(10,20,30)
z2 <- c(1,2)
z + z2