## 2020-03-05
## LVA
## dplyr II

## Exporting and importing data

library(dplyr)
data(starwars)

starwars1 <- select(starwars, name:species)

## write.table
write.table(starwars1, file = "StarwarsNamesInfo.csv", row.names = FALSE, sep = ",") #creating a CSV

data <- read.csv(file = "StarwarsNameInfo.csv", header = TRUE, sep = ",",
                 stringsAsFactors = FALSE, comment.char = "#")

data <- read.table(file = "StarwarsNamesInfo.csv", header=TRUE, sep = ",", 
                   stringsAsFactors = FALSE)

class(data)
data <- as_tibble(data)
glimpse(data)

## only working in R
# saveRDS() good for if you are only working in R

saveRDS(starwars1, file = "StarwarsTibble")
## saves R object as a file

sw <- readRDS("StarwarsTibble")
# restores the R object
class(sw)




# Futher into dplyr -------------------------------------------------------


glimpse(sw)

## count of NAs
sum(is.na(sw))
# how many not NAs
sum(!is.na(sw))

# using pipign
# ascending order is the default
swSp <- sw %>%
  group_by(species) %>%
  arrange(desc(mass))

# determine the sample size

swSp %>% 
  summarize(avgMass = mean(mass, na.rm = TRUE), avgHeight = mean(height, na.rm = TRUE), n= n())

# filter out the sample size

swSp %>% 
  summarize(avgMass = mean(mass, na.rm = TRUE), avgHeight = mean(height, na.rm = TRUE), n= n()) %>%
  filter(n >= 2) %>%
  arrange(desc(n))

#### count helper 

swSp %>%
  count(eye_color) # gives the number of individuals with a given eye color

swSp %>%
  count(wt=height) # gives 'weight' (sum)

### useful summary function
## use a lot of base R functions too

starwarsSummary <- swSp %>%
  summarize(avgHeight = mean(height, na.rm = TRUE), 
            medHeight = median(height, na.rm =TRUE), 
            height_sd = sd(height, na.rm = TRUE), 
            heightIQR = IQR(height, na.rm = TRUE),
            min_height = min(height, na.rm = TRUE), 
            first_height = first(height), n=n(), n_eyecolors = n_distinct(eye_color)) %>%
              filter(n >=2) %>%
            arrange(desc(n)) 
            starwarsSummary

# %>% piping automatically uses what was previously done into the next arguement
            
          
### Grouping multiple variables/ungroup

sw2 <- sw[complete.cases(sw),]

sw2groups <- group_by(sw2, species, hair_color)

summarize(sw2groups, n=n())

sw3groups <- group_by(sw2, species, hair_color, gender)
summarize(sw3groups, n = n())


### Grouping with mutate
## Ex. standardize within groups

sw3 <- sw2 %>%
  group_by(species) %>%
  mutate(prop_height = height/sum)

mutate(group_by(sw2, species), prop_height = height/sum)

## there was some here that I missed



# pivot_longer/pivot_wider functions --------------------------------------


# compare to gather() spread()

TrtA <- rnorm(n=20, mean=50, sd=10)
TrtB <- rnorm(n=20, mean=45, sd=10)
TrtC <- rnorm(n=20, mean=62, sd=10)
z <- data.frame(TrtA, TrtB, TrtC)
library(tidyr)

long_z <- gather(z, Treatment, Data, TrtA:TrtC)

z %>%
  pivot_longer(TrtA:TrtC, names_to="Treatment", values_to="Data")

### pivot_wider - names_from and values_from

vignette("pivot")