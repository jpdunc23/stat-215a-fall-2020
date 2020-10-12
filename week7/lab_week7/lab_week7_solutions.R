# load libraries
library(tidyverse)
library(foreach)
library(doParallel)
library(Rcpp)

# load data
working.directory <- file.path("./data")                              
ling.location <- read.delim(file.path(working.directory, 
                                      "lingLocation.txt"), 
                            header = T, sep = "")
data <- ling.location %>%
  select(-Number.of.people.in.cell, -Latitude, -Longitude)
  
# set number of repetitions for k-means
repetitions <- 100

# set number of clusters
K <- 3


# Exercise 1: Run kmeans 100 times in serial using a for loop and time how long 
# it takes to run.
ptm <- proc.time()
for (i in 1:repetitions) {
  kmeans.out <- kmeans(x = data, centers = K)
}
dur1 <- proc.time() - ptm


# Exercise 2: Run kmeans 100 times in serial using the sapply() function and time
# how long it takes to run
ptm <- proc.time()
kmeans.runs <- sapply(X = 1:repetitions, 
                      FUN = function(X) {
                        kmeans.out <- kmeans(x = data, centers = K)
                        return(kmeans.out$cluster)
                      })
dur2 <- proc.time() - ptm


# Exercise 3: Run kmeans 100 times in serial using the lapply() function. What 
# is the difference between sapply() and lapply()?
kmeans.runs <- lapply(X = 1:repetitions, 
                      FUN = function(X) {
                        kmeans.out <- kmeans(x = data, centers = K)
                        return(kmeans.out$cluster)
                      })
# lapply returns a list while sapply simplifies the output


# Exercise 4: Run kmeans 100 times in parallel using foreach() and compare how
# long it takes to running kmeans in serial.
ncores <- 3  # set number of cores
registerDoParallel(ncores)
ptm <- proc.time()
kmeans.runs <- foreach(i = 1:repetitions, .combine = "cbind") %dopar% {
  kmeans.out <- kmeans(x = data, centers = K)
  kmeans.out$cluster
}
dur3 <- proc.time() - ptm

# timing comparisons
dur1  # for loop
dur2  # sapply
dur3  # for loop in parallel


# Exercise 5: Write a shell script and run this script on the SCF clusters 



# Exercise 6: Write an Rcpp function called rcpp_sum() that
# takes in a numeric vector and computes the cumulative sum of that vector.
# To check your implementation, compute the sum of a 1e7-length vector generated
# from rnorm() (i.e., compute the sum of x = rnorm(1e7)). Does your rcpp_sum()
# function give the same result as the base R sum() function?
sourceCpp("sum.cpp")
x <- rnorm(1e7)
rcpp_sum(x)
all.equal(sum(x), rcpp_sum(x))
