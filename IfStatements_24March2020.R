# ---------------------------------------------
# Booleans and if/else control structures
# 27 Mar 2020
# JCS
# ---------------------------------------------

# Review of boolean operators --------------------------------

# Simple inequalities
# uses logical operators
5 > 3
5 < 3
5 >= 5
5 <= 5
5 == 3 # be sure to use double ==, logical operator compares 2 things on either side and see if they are the same or not
5 != 3 # ! not

# compound statements use & or |

# use & for AND
FALSE & FALSE
FALSE & TRUE
TRUE & TRUE
5 > 3 & 1 != 2  # both statements are true so we get a true response
1 == 2 & 1 != 2

# use | for OR
FALSE | FALSE
FALSE | TRUE
TRUE | TRUE
1 == 2 | 1 != 2

# boolean operators work with vectors
1:5 > 3 # each element in vector compared the the value in the string

a <- 1:10
b <- 10:1

a > 4 & b > 4
sum(a > 4 & b > 4) # coerces booleans to numeric values

# "long" evaluates only the first element

# evalues all elements and gives a vector of T/F
a < 4 & b > 4

# evaluates only the first comparison that gives a boolean - long version
a < 4 && b > 4

# also a long form for ||

# vector result
a < 4 | b > 4

# single boolean result
a < 4 || b > 4

# xor for exclusive "or" testing of vectors
# works for (TRUE FALSE) but not for (FALSE FALSE)
# or (TRUE TRUE)

a <- c(0,0,1)
b <- c(0,1,1)
xor(a,b)

# by comparison with an ordinary |
a | b

# Set operations --------------------------------

# boolean algebra on sets of atomic vectors (numeric, logical, character strings)

a <- 1:7
b <- 5:10

# union to get all elements (OR for a set)
union(a,b) # gets elements that are in common

# interset to get common elements (AND for set)
intersect(a,b)

# these return vectors that meet the conditions you specify

# setdiff to get distinct elements in a vector
setdiff(a,b)

# setdiff to get distinct elements in b
setdiff(b,a)

# setequal to get identical elements
setequal(a,b)

# more generally, to compare any two objects
z <- matrix(1:12, nrow=4, byrow=TRUE)
z1 <- matrix(1:12,nrow=4,byrow=FALSE)

# this just compares element by element
z == z1

identical(z,z1)
z1 <- z

# most useful in if statements %in% or is.element
# these are equivalent, but I (Nick) prefer %in% for readibility

d <- 12
d %in% union(a,b)

# equivalent to above
is.element(d,union(a,b))

a <- 2
a == 1 | a == 2 | a == 3
a %in% c(1,2,3)
# check for partial matching with vector comparisons

a <- 1:7

d <- c(10,12)
d %in% union(a,b)
d %in% a

# if statement --------------------------------

# anatomy of if statments

# if (condition) expression

# if (condition) expression1 else expression2

# if (condition1) expression1 else 
# if (condition2) expression2 else
# expression3

# - final unspecified else captures rest of the unspecified conditions

# else statement must appear on the same line as previous expression
# instead of single expression, can use curly brackets to executre a set of lines when condition is met {}

z <- signif(runif(1),digits = 2)
print(z)

# simple if statement with no else
if (z > 0.5) cat(z, "is a bigger than average number", "\n")

# compound if statement with 3 outcomes (2 if statements)
# 3rd line is executed if the first 2 are false

if (z > 0.8) cat(z, "is a large number","\n") else
if (z < 0.2) cat(z, "is a small number","\n") else
{cat(z,"is a number of typical size", "\n")
  cat("z^2 =",z^2, "\n") }

# if statement wants a single boolean value (TRUE FALSE)
# if you give an if statement a vector of booleans
# if will operate only on the very first element in that vector

z <- 1:10

# this goes not do anything
if (z > 7) print(z)

# probabaly not what you want
if (z < 7) print(z)

# use subsetting!
print(z[z <7])



# ifelse function --------------------------------

# ifelse(test,yes,no)
# "test" is an object that can be coerced into a logical
# TRUE/FALSE

# "yes" returns values for true elements in the test
# "no" returns values for false elements in the test

# suppose we have an insect population in which each female lays on average, 10.2 eggs, following a Poisson distribution. lambda=10.2. However, there is a 35% chance of parisitism, in which case, no eggs are laid. Here is a random sample of eggs laid for a group of 1000 indididuals

tester <- runif(1000) # start with random uniform elements
eggs <- ifelse(tester > 0.35,rpois(n=1000,lambda=10.2),0)
hist(eggs)

# suppose we have a vector of probability values (perhaps from a simulation). We want to highlightssignificant values in the vector for plotting

p_vals <- runif(1000)
z <- ifelse(p_vals<=0.025,"lower_tail","non_sig")
z [p_vals>=0.975] <- "upper_tail"
table(z)

# Here is how I (Nick) would do it

z1 <- rep("non_sig", 1000)
z1[p_vals <= 0.025] <- "lower_tail"
z1[p_vals >= 0.975] <- "upper_tail"
table(z1)
# same as what we got above