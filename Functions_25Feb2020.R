# Function structure and use
# 25 Feb 2020
# JCS


# -------------------------------------------------------------------------

# Everything in R is a function
sum(3,2) # a prefix function
3 + 2 # an "operator", but it is actually a function
`+` (3,2) # rewritten as an "infix" function

y <- 3
print(y)

`<-`(yy,3)
print(yy)

# to see contents of a function, print it
print(read.table)

sd         # print function
sd(c(3,2)) # call function with parameters
sd()       # print function with no inputs, (doesn't work for this one, but others can be run without an input and uses base inputs)


# The anatomy of a user-defined function ----------------------------------

function_name <- function(par_x=default_x,
                          par_y=default_y,
                          par_z=default_z) { # { indicates the start of the code
  # function body
  # lines of r code and annotation
  # may call other functions
  # can create functions
  # create local variables
  
  return(z) # returns from the function a single element
  
} # the end of the code

function_name()
function_name(par_x=my_matrix,
              par_y="order",
              par_z=1:10)

# use prominent hash fencing around your function code
# give a header with the function name, and a brief description of input,output
# names inside function can be short
# functions should be short and simple, no more than 1 screen
# if too complex, break into multiple functions
# provide default values for all input parameters
# make default values from random number generators


###########################################################################

# FUNCTION: hardy_weinberg
# input: an allele frequency p (0,1)
# output: p and the frequencies of genotypes AA AB BB


# -------------------------------------------------------------------------

hardy_weinberg <- function(p=runif(1)) {
  q <- 1 - p
  f_AA <- p^2
  f_AB <- 2*p*q
  f_BB <- q^2
  vec_out <- list(p=p,
                  f_AA=f_AA,
                  f_AB=f_AB,
                  f_BB=f_BB)
  return(vec_out) 
}

# now we have a sepecialized function called hardy_weinberg in the function list

##########################################################################

hardy_weinberg() # outputs is the list that we created above
hardy_weinberg(p=0.5)
pp <- 0.6 # assign number to the variable
hardy_weinberg(p=pp)  # pass variable into the fucntion
print(pp)
print(hardy_weinberg) # get code out
print(hardy_weinberg(p=pp))


###########################################################################

# FUNCTION: hardy_weinberg2
# input: an allele frequency p (0,1)
# output: p and the frequencies of genotypes AA AB BB


# -------------------------------------------------------------------------

hardy_weinberg2 <- function(p=runif(1)) {
  if(p > 1.0 | p < 0.0) { # setting up error conditions # | is or
    return("Function failure: p must be <= 1 and >=0") # exits the function if this is true
  }
  q <- 1 - p
  f_AA <- p^2
  f_AB <- 2*p*q
  f_BB <- q^2
  vec_out <- list(p=p,
                  f_AA=f_AA,
                  f_AB=f_AB,
                  f_BB=f_BB)
  return(vec_out) 
}

##########################################################################

hardy_weinberg2()
hardy_weinberg(1.1) # original function that works, but values not accurate
hardy_weinberg2(1.1)
z <- hardy_weinberg2(1.1) # no error message the code runs
z # gives the error message in that object
# use stop function for true error trapping



###########################################################################

# FUNCTION: hardy_weinberg3
# input: an allele frequency p (0,1)
# output: p and the frequencies of genotypes AA AB BB


# -------------------------------------------------------------------------

hardy_weinberg3 <- function(p=runif(1)) {
  if(p > 1.0 | p < 0.0) { # setting up error conditions # | is or
    stop("Function failure: p must be <= 1 and >=0") # exits the function if this is true
  }
  q <- 1 - p
  f_AA <- p^2
  f_AB <- 2*p*q
  f_BB <- q^2
  vec_out <- list(p=p,
                  f_AA=f_AA,
                  f_AB=f_AB,
                  f_BB=f_BB)
  return(vec_out) 
}

##########################################################################

hardy_weinberg3(1.1) # gives us an error in hardy_weinberg3
z <- hardy_weinberg3(1.1)

# what goes on in the function stays in the function, not in the global environment


# -------------------------------------------------------------------------

# global variables: visible in all parts of code, declared in main body of the program

# local variables: visible only within the function; declared within the function or passed to it through the input parameters

# functions can "see" variables in global environment 
# global environment cannot "see" variables in the function environment 

my_func <- function(a=3, b=4) { 
  z <- a + b
  return(z)
}
my_func()

my_func_bad <- function(a=3) {
  z <- a + b
  return(z)
}
my_func_bad() # this went to find B in the global environment, which isn't something we want though
b <- 100
my_func_bad()

my_func_ok <- function(a=3) {
  bb <- 100
  z <- a + bb
  return(z)
}
my_func_ok()
print(bb) # error because in global environment bb does not exist, it is only in the local one
# local environment only looks locally not in global environment

#########################################################################
# FUNCTION: fit_linear
# fits simple regression line
# inputs: numeric vectors of predictor (x) and response (y)
# output: slope and p-value


# -------------------------------------------------------------------------

fit_linear <- function(x=runif(20),
                       y=runif(20)){
    my_mod <- lm(y~x)
    my_out <- list(slope=summary(my_mod)$coefficients[2,1],
                   p_val=summary(my_mod)$coefficients[2,4])
    plot(x=x,y=y) # inputs are same names that we name above
return(my_out)
                       }

# -------------------------------------------------------------------------
fit_linear()

# create more complex input value

#########################################################################
# FUNCTION: fit_linear2
# fits simple regression line
# inputs: numeric vectors of predictor (x) and response (y)
# output: slope and p-value


# -------------------------------------------------------------------------

fit_linear2 <- function(p=NULL) {
  if(is.null(p)) { 
    p <- list(x=runif(20), y=runif(20))
  }
  my_mod <- lm(p$y~p$x) # give name of list, p and $y the element in the list
  my_out <- list(slope=summary(my_mod)$coefficients[2,1],
                 p_val=summary(my_mod)$coefficients[2,4])
  plot(x=p$x,y=p$y) # inputs are same names that we name above
  return(my_out)
}

# -------------------------------------------------------------------------

fit_linear2()
my_pars <- list(x=1:10, y=runif(10))
fit_linear2(p=my_pars)
fit_linear2(my_pars)

# use do.call to pass a list of parameters to a function

z <- c(runif(99),NA)
mean(z)
mean(x=z, na.rm=TRUE, trim=0.5)

my_list= list(x=z,na.rm=TRUE,trim=0.05) # creating a list structure of all the elements that we need for the input to the mean function
mean(my_list)
do.call(mean, my_list) # a function that has as its input another function





