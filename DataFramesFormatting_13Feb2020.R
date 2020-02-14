# Finishing data frames, lists
# Formating data
# 13 Feb 2020
# JCS


#   -----------------------------------------------------------------------

# Matrix and data frame similarites and differences

z_mat <- matrix(data=1:30,ncol=3,byrow=TRUE)
z_dataframe <- as.data.frame(z_mat)

# structure
str(z_mat)
str(z_dataframe)

# appearance
head(z_mat)
head(z_dataframe)

# element referencing
z_mat[2,3]
z_dataframe[2,3]

# column referencing
z_mat[,2]
z_dataframe[,2]
z_dataframe$V2

# rows referencing
z_mat[2,]
z_dataframe[2,]

# specifying single elements is different!
z_mat[2] #z_mat[1,2] is the better way
z_dataframe[2] #z_dataframe$V2 is the better way

# complete.cases for scrubbing out atomic vector, when you have NA's in the dataset

# make the vector
zD <- c(runif(3),NA,NA,runif(2))
print(zD)

# pull out the complete cases
complete.cases(zD)
zD[complete.cases(zD)] # selects the values that are not NA's
zD[!complete.cases(zD)] # brings just the NA

# using this for a matrix
m <- matrix(1:20,nrow=5)
m[1,1] <- NA
m[5,4] <- NA

# sweep out all rows with missing values
m[complete.cases(m),]

# get complete cases for only certain columns
m[complete.cases(m[,c(1,2)]),] # drop out row #1
m[complete.cases(m[,c(2,3)]),] # this is only checking for missing values in 2 and 3, doesnt drop any of the rows because R isn't looking there

m[complete.cases(m[,c(3,4)]),] # drops row #4
m[complete.cases(m[,c(1,4)]),] # drops row #1 and #4

# techniques for assignments and subsetting matrices and data frames
m <- matrix(data=1:12,nrow=3)
dimnames(m) <-
  list(paste("Species",LETTERS[1:nrow(m)], sep=""),
       paste("Site",1:ncol(m),sep=""))
m

m[1:2,3:4]
m[c("SpeciesA", "SpeciesB"), c("Site3","Site4")]

# use blanks to pull out all rows or columns:
m[c(1,2),]
m[,c(1,2)]

# use logicals for more complex subsetting
# e.g. select all columns have totals > 15

colSums(m) > 15
m[, colSums(m) > 15]

# Select all rows for which row total equal 22
m[rowSums(m)!=22,]

m[,"Site1"]<3

m["SpeciesA",] <5

m[m[,"Site1"]<3,m["SpeciesA",]<5]

# caution simple subscripting can change data type!
z <- m[1,]
print(z)

# use drop=FALSE to retain dimensions
z2 <- m[1, , drop=FALSE]
str(z2)


# basic format is a csv file


#   -----------------------------------------------------------------------

my_data <- read.table(file="FirstData.csv",
                      header = TRUE,
                      sep=",",
                      stringsAsFactors=FALSE)
str(my_data)

# use saveRDS() will save an R object as a binary
saveRDS(my_data,file="my_RDSobject")
z <- readRDS("my_RDSobject")

?read.csv
?read.table
