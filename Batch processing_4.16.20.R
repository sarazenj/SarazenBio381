# ---------------------------------------------
# Script for file creation and batch processing
# 16 Apr 2020
# JCS
# ---------------------------------------------

# Notes on setting up new files:
# First discussion on directories, getwd() tells you what the current directory is. list.files() tells you the files in the current folder

# absolute path names start all the way up at the root and take you down to where you are
# relative path names, start where you are, no forward slash for the root, and go forward from where you are.

# dir.create() makes a new file in the current wd that you are in.
# create a file with a sub folder in it too


# Setting and creating up a new data file --------------------------------
# normally, would not need to do this in real analysis b/c you would have own data, but it uses some good programming skills anyways

# ---------------------------------------------
# FUNCTION file_builder
# description: creates a set of random files for regression
# inputs: file_n = number of data files to create
#         file_folder = name of colder for random files
#         file_size = c(min,max) number of rows in file
#         file_NA = average number of NA values per column
# outputs: creates a set of random files
###############################################
file_builder <- function(file_n=10,
                         file_folder="RandomFiles/",
                         file_size=c(15,100),
                         file_NA=3) {

  for (i in seq_len(file_n)) {
    file_length <- sample(file_size[1]:file_size[2], size=1)
    var_x <- runif(file_length) # create random x
    var_y <- runif(file_length) # create random y
    df <- data.frame(var_x,var_y) # bind into a data frame
    bad_vals <- rpois(n=1,lambda=file_NA) # discrete distibution, count data
    df[sample(nrow(df),size=bad_vals),1] <- NA # randomly sample rows and populate them with an NA
    df[sample(nrow(df),size=bad_vals),2] <- NA
    
    
# create label for file name with padded zeroes - keeps file names ordered with the consecutive ones we want
    file_label <- paste(file_folder, "ranFile",
                        formatC(i,
                                 width=3,
                                 format="d",
                                 flag="0"),
                                 ".csv",
                                 sep="")

    # set up the data file and incorporate time stamp and minimal metadata
  write.table(cat("# Simulated random data file for batch processing", "\n",
                  "# timestamp: ", as.character(Sys.time()),
                  "\n",
                  "# JCS", "\n",
                  "# ------------------------", "\n",
                  "\n",
                  file=file_label,
                  row.names="",
                  col.names="",
                  sep=""))
  
  # now add the data frame
  write.table(x=df,
              file=file_label,
              sep=",",
              row.names=FALSE,
              append=TRUE) # this is important because we don't want to write over the table that we made above
  
  
} # end of for loop
} # end of file_builder
#----------------------------------------------


# ---------------------------------------------
# FUNCTION reg_stats
# description: fits linear models, extract model stats
# inputs: 2-column data frame (x and y)
# outputs: slope, p-value, and r2
###############################################
reg_stats <- function(d=NULL) {
             if(is.null(d)) {
               x_var <- runif(10)
               y_var <- runif(10)
               d <- data.frame(x_var,y_var)
             }

  . <- lm(data=d,d[,2]~d[,1])
  . <- summary(.)
  stats_list <- list(Slope=.$coefficients[2,1],
                     pVal=.$coefficients[2,4],
                     r2=.$r.squared)
  return(stats_list)
    
} # end of reg_stats
#----------------------------------------------
# program body using the two functions

library(TeachingDemos)
char2seed("Running")

#####################################################
# Global variables
# notation note - lower case r variables, upper case for file names

file_folder <- "RandomFiles/"
n_files <- 100
file_out <- "StatsSummary.csv"
#####################################################

# Create 100 data sets
dir.create(file_folder) # creates directory for where files are going
file_builder(file_n=n_files)
file_names <- list.files(path=file_folder)

# Create a data frame to hold summary file statistics
ID <- seq_along(file_names)
file_name <- file_names
slope <- rep(NA,length(file_names))
p_val <- rep(NA,length(file_names))
r2 <- rep(NA,length(file_names))

stats_out <- data.frame(ID,file_name,slope,p_val,r2)

# note- in stats_out, it is empty, we haven't ran anything with our files yet, just set up the output structure


# Batch process by looping through individuals --------------------------------

for (i in seq_along(file_names)) { # by calling file names grab what is in there
  data <- read.table(file=paste(file_folder,file_names[i],
                                sep=""), # referes to paste() function
                                sep=",", # refers to read.table() function
                                header=TRUE)
  d_clean <- data[complete.cases(data),] # subset for clean cases to remove the NAs
  
  . <- reg_stats(d_clean) # pull out regression stats from clean file
  stats_out[i,3:5] <- unlist(.) # need to fill data frame with values not in a list form, so this part unlists and copies into last 3 columns
  
}

# set up an output file and incorporate time stamp and minimal metadata

write.table(cat("# Summary stats for", 
            "batch processing of regression models",
            "\n",
            "# timestamp: ", as.character(Sys.time()),
            "\n",
            file=file_out,
            row.names="",
            col.names="",
            sep=""))

# now add the data frame
write.table(x=stats_out,
            file=file_out,
            row.names=FALSE,
            col.names=TRUE,
            sep=",",
            append=TRUE) # don't overright header material at top of file



# so now we have a file called stats summary, that has 6 columns with ID, file_name, slope, pval, r2, which comes from the 100 files we made that have all been systematicallly processed


# As a way to think about the batch proccessing a bit more, we deleted the first 12 files in random files and then ran the batch processing code again after creating a new StatsSummary1 file. Then in this new file, we only got stats summary for files #013-100 since #001-0012 were not in random files anymore. 
# I changed this back after to the original code without the deleted files.
