# Manipulating data using dplyr
# JCS
# 2020-03-04

## What is dplyr?
# New-ish package: provides a set of tools for manipulating data
# Part of the tidyverse: collection of packages share philosophy, grammar, and data structure
# specifically written to be fast!
# Individual functions for most common operations
# Easier to figure out what you want to do with your data

library(dplyr)

## Core verbs
# filter () #rows
# arrange()
# select() # columns
# summarize() and group_by()
# mutate()

data(starwars)
class(starwars)

## WHAT IS A TIBBLE?
# 'modern take' on data frames
# keeps great aspects of df, drops frustrating ones (changing variable names, changing input type)

glimpse(starwars)
head(starwars)

## clean up data
# complete.cases

starwarsClean <- starwars[complete.cases(starwars[,1:10]),]

is.na(starwarsClean[,1])
anyNA(starwarsClean)
anyNA(starwars)

### what does our data look like?
glimpse(starwarsClean)
head(starwarsClean)

## filter(): pick/subset observations by their values
### uses >, >=, <, <=, !=, == for comparisons
### logical operators: & | !
### filter automatically excludes NAs

filter(starwarsClean, gender == "male", height < 180, height > 180) 
### can use commas, multiple conditions for the same variable

filter(starwarsClean, eye_color %in% c("blue", "brown"))
### %in% similar to ==

## arrange(): reorders rows
arrange(starwarsClean, by=height) 
# default is ascending order

arrange(starwarsClean, by=desc(height))
# desc() changes the order

arrange(starwarsClean, height, desc(mass))
# add additional argument to break ties in preceding column

starwars1 <- arrange(starwars, height)
tail(starwars1) # missing values are at the end

# select(): choose variables by their names

starwarsClean[1:10,2] # base r - selecting second variable

select(starwarsClean, 1:5) # use numbers
select(starwarsClean, name:height) # can use variable names too

select(starwarsClean, -(films:starships)) 
# all 3 ways above to the same thing

# rearrange columns
select(starwarsClean, name, gender, species, everything())
# everything() helper function useful if you want to move a couple variables to the beginning

select(starwarsClean, contains("color"))
# other helpers: ends_with, starts_with, matches (reg ex), num_range

select(starwarsClean, height, skin_color, films) # not in 'clumps'

### rename columns
select(starwars, haircolor = hair_color)

### rename function
rename(starwarsClean, haircolor=hair_color)



#### mutate(): creates new variables with functions of existing variables

mutate(starwarsClean, ratio = height/mass)
# we can use arithmetic operators

starwars_lbs <- mutate(starwarsClean, mass_lbs = mass*2.2) #convert kg to lbs
head(starwars_lbs)
select(starwars_lbs, 1:3, mass_lbs, everything()) # brings mass_lbs to beginning of dataset

# transmute - just keeps new variable
transmute(starwardsClean, mass_lbs = mass*2.2)

transmute(starwarsClean, mass_lbs = mass*2.2, mass)

## summarize and group_by: collapses values down to a single summary

summarize(starwarsClean, meanHeight = mean(height, na.rm=TRUE), TotalNumber = n())

## working with NAs
summarize(starwars, meanHeight=mean(height), TotalNumber = n())

starwarsGenders <- group_by(starwars, gender)
head(starwarsGenders)

summarize(starwarsGenders, meanHeight=mean(height, na.rm=TRUE) number=n())

## Piping
# use to emphasize a sequence of actions 
# passes an intermediate result onto next function (takes output of one statement and makes it the input of the next statement)
# avoid if you have meaningful intermediate results or if you want to manipulate ore than one object at a time
# formatting: having a space before the pipe, followed by a new line
# %in%

starwarsClean %>% 
  group_by(gender) %>%
  summarize(meanHeight = mean(height),
number= n())

heightsSW <-starwarsClean %>% 
  group_by(gender) %>%
  summarize(meanHeight = mean(height),
            number= n())
# saves as a variable
