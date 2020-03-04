# intro experimental designs
# 2/20/2020

library(ggplot2)

# Regression analysis -----------------------------------------------------

n <- 50 # number of observations (rows)
var_a <- runif(n) # 50 random uniforms (independent)
var_b <- runif(n) # dependent variable
var_c <- 5.5 + var_a*10 # creates a noisy linear relationship
id <- seq_len(n) # creates a sequence from 1 to n if n > 0
reg_df <- data.frame(id,var_a,var_b,var_c)

str(reg_df)
head(reg_df)

# regression model 
reg_model <- lm(var_c~var_a,data=reg_df) # go graph these data out of the columns of the data frame
reg_model # sparce output
str(reg_model)
head(reg_model$residuals)

# summary of model usually has what we want
summary(reg_model)
summary(reg_model)$coefficients
str(summary(reg_model))

# pval = likelihood of the data, given a particular null model (ex. in class we got one that was significant)


z <- unlist(summary(reg_model))
z # simple long list of all the items


# pulling out from the list that we unlisted above. this is the smaller package of the things we actually want. bundling up the partcular output you want to keep and work with
reg_sum <- list(intercept=z$coefficients1,
                slope=z$coefficients2,
                intercept_p=z$coefficients7,
                r2=z$r.squared)
reg_sum$intercept

# regression plot for data
# data needs to be in a dataframe for ggplot, not just a vector
reg_plot <- ggplot(data=reg_df,
                  aes(x=var_a,y=var_c)) + 
                  geom_point() +
                  stat_smooth(method=lm, se=0.95)
# reg_plot is a ggplot object
print(reg_plot)


# Basic ANOVA -------------------------------------------------------------

n_group <- 3 # number of treatment groups
n_names <- c("Control","Treat1","Treat2")
n_size <- c(12,17,9)
n_mean <- c(60,60,60)
n_sd <- c(5,5,5)
t_group <- rep(n_names,n_size)
t_group
table(t_group)

id <- 1:(sum(n_size))
res_var <- c(rnorm(n=n_size[1],mean=n_mean[1],sd=n_sd[1]),
             rnorm(n=n_size[2],mean=n_mean[2],sd=n_sd[2]),
             rnorm(n=n_size[3],mean=n_mean[3],sd=n_sd[3]))
ano_data <- data.frame(id,t_group,res_var)
str(ano_data)


# ANOVA Model -------------------------------------------------------------

# ~ means "as a function of"
ano_model <- aov(res_var~t_group,data=ano_data)
print(ano_model) # to get the model
print(summary(ano_model)) # gets all elements of the model 
z <- summary(ano_model) # save as a vector
str(z)
aggregate(res_var~t_group,data=ano_data,FUN=mean) # separates out by the t_group and gives the mean of each group. applying a common operation to several columns

unlist(z)
unlist(z)[7] # takes the f value out, need to go in the summary section and figure out what you want and the number
ano_sum <- list(Fval=unlist(z)[7],
                probF=unlist(z)[9])
ano_sum



# ggplot for ANOVA data ---------------------------------------------------
library(ggplot2)


ano_plot <- ggplot(data=ano_data,
                   aes(x=t_group, # aes=specify asthetics
                       y=res_var,
                       fill=t_group)) +# fill to specify a grouping variable
                      geom_boxplot()
print(ano_plot)

# there will always be sampling noise and can see that variation in the box plot

ggsave(filename="Plot2.pdf",plot=ano_plot,device="pdf") # this will automate the saving of the plot


# data frame for logistic regression --------------------------------------

# discrete y variable (0,1), continuous x varaible

x_var <- sort(rgamma(n=200,shape=5,scale=5)) 
head(x_var) # these are in order because of using the sort command

y_var <- sample(rep(c(0,1),each=100),prob=seq_len(200)) # 100 0's followed by 100 1's, sample function reorders randomly, generates a random but nonuniform distribution
head(y_var)

l_reg_data <- data.frame(x_var,y_var)



# Logistic regression code ------------------------------------------------

l_reg_model <- glm(y_var~x_var,
                   data=l_reg_data,
                   family=binomial(link=logit))

summary(l_reg_model)
summary(l_reg_model)$coefficients


# basic ggplot of logistic regression data --------------------------------

l_reg_plot <- ggplot(data=l_reg_data,
                     aes(x=x_var,y=y_var)) + 
              geom_point() +
              stat_smooth(method=glm,
                          method.args=list(family=binomial))
print(l_reg_plot) ## check the code for this plot since it did not work this time



# Contingency table data --------------------------------------------------

# both x and y variables are discrete (= counts) integer counts of different groups
vec_1 <- c(50,66,22)
vec_2 <- c(120,22,30)
data_matrix <- rbind(vec_1,vec_2)
rownames(data_matrix) <- c("Cold","Warm")
colnames(data_matrix) <- c("Aphaenogaster",
                           "Camponotus",
                           "Crematogaster")
str(data_matrix)
data_matrix


# simple association test -------------------------------------------------

print(chisq.test(data_matrix))


# plotting contingency data -----------------------------------------------

# base R graphics
mosaicplot(x=data_matrix,
           col=c("goldenrod", "grey", "black")) # illustrates where the two groups are differing in their frequency

barplot(height=data_matrix,
        beside=TRUE,
        col=c("cornflowerblue", "tomato")) # y axis displays the counts that you can see well


# ggplot graph ------------------------------------------------------------

library(tidyverse)

d_frame <- as.data.frame(data_matrix) # as.data.frame = coeherces the data matrix into a data frame
d_frame <- cbind(d_frame,list(Treatment=c("Cold","Warm")))
d_frame <- gather(d_frame,key=Species,Aphaenogaster:Crematogaster,value=Counts)

# wide data, vs. long form = each 

head(d_frame)
# we went from a 3x2 table instead to the long form

p <- ggplot(data=d_frame,
            aes(x=Species,y=Counts,fill=Treatment)) +
            geom_bar(stat="identity",
                     position="dodge",
                     color=I("black")) + 
            scale_fill_manual(values=c("cornflowerblue","coral"))
print(p)