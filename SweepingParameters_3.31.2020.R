# ---------------------------------------------
# Writing desciptions for equations and sweeping over parameters
# 31 Mar 2020
# JCS
# ---------------------------------------------

library(ggplot2)

# S=cA^z describes species-area relationship

# ---------------------------------------------
# FUNCTION species_area_curve
# description: creates a power function for S and A
# inputs: A is a vector of island areas
#         C is the intercept constant
#         z is the slope constant
# outputs: S is a vector of species richness
###############################################
species_area_curve <- function(A=1:5000,
                               c=0.5,
                               z=0.26) {

S <- c*(A^z)
return(S)

} # end of species_area_curve
#----------------------------------------------
head(species_area_curve())

# ---------------------------------------------
# FUNCTION species_area_plot
# description: plots species area curves with parameter values
# inputs: A = vector of areas
#         c = single value for c parameter
#         z = single value for z paramter
# outputs: smoothed curve with paramters printed in graph
###############################################
species_area_plot <- function(A=1:5000,
                              c=0.5,
                              z=0.26) {

plot(x=A,y=species_area_curve(A,c,z),
     type="l",
     xlab="Island Area",
     ylab="S",
     ylim=c(0,2500))
  mtext(paste("c =",c,"  z=",z),cex=0.7) #(cex=chacter expansion factor)
# return("Checking...species_area_plot")

} # end of species_area_plot
#----------------------------------------------
species_area_plot()

# build a grid of plots!

# global variables
c_pars <- c(100,150,175)
z_pars <- c(0.10,0.16,0.26,0.3)
par(mfrow=c(3,4))

for (i in seq_along(c_pars)) {
  for (j in seq_along(z_pars)) {
    species_area_plot(c=c_pars[i],z=z_pars[j])
  }
}


# changing the inputs a bit
#c_pars <- c(50,100,150,175)
#z_pars <- c(0.10,0.16,0.26)
#par(mfrow=c(4,3))


## read about the while and repeat function in the code posted for today




# expand.grid --------------------------------
# pairs up all combination of vectors that are handed into a dataframe, each row represents a unique combination of the variables it has recieved
expand.grid(c_pars,z_pars)

# ---------------------------------------------
# FUNCTION sa_output
# description: summary stats for species-area power function
# inputs: vector of predicted species richness values
# outputs: list of max-min, coefficient of variation
###############################################
sa_output <- function(S=runif(1:10)) {

sum_stats <- list(s_gain=max(S)-min(S),
                  s_cv=sd(S)/mean(S))

return(sum_stats)

} # end of sa_output
#----------------------------------------------

sa_output()

# build program body --------------------------------

# Global variables
Area <- 1:5000
c_pars <- c(100,150,175)
z_pars <- c(0.10,0.16,0.26,0.30)

# set up model data frame
model_frame <- expand.grid(c=c_pars,z=z_pars)
str(model_frame)
model_frame$SGain <- NA
model_frame$SCV <- NA
head(model_frame)

# Cycle through model calculations
for (i in 1:row(model_frame)) {
 
  # generate S vector
  temp1 <- species_area_curve(A=Area,
                              c=model_frame[i,1],
                              z=model_frame[i,2])
  # calculate output stats
  temp2 <- sa_output(temp1)
  
  # pass results to columns in data frame
  model_frame[i,c(3,4)] <- temp2
  
}
print(model_frame)



# parameter sweep redux with ggplot graphics

area <- 1:5 
c_pars <- c(100,150,175)
z_pars <- c(0.10,0.16,0.26,0.30)

# set up model frame
model_frame <- expand.grid(c=c_pars,
                          z=z_pars,
                          A=area)

head(model_frame)
length(model_frame)
nrow(model_frame)

# add response variable
model_frame$S <- NA # fill with NA at start of analysis

# loop through parameters and fill with sa function
for (i in 1:length(c_pars)) { 
  for (j in 1:length(z_pars)) {
    model_frame[model_frame$c==c_pars[i] & model_frame$z==z_pars[j],"S"] <- species_area_curve(A=area, c=c_pars[i], z=z_pars[j])
    }
}


head(model_frame)

p1 <- ggplot(data=model_frame)
p1 + geom_line(mapping=aes(x=A,y=S)) + 
  facet_grid(c~z)

p2 <- p1
p2 + geom_line(mapping=aes(x=A,y=S,group=z)) +
  facet_grid(.~c)

p3 <- p1
p3 + geom_line(mapping=aes(x=A,y=S,group=c)) +
  facet_grid(z~.)
