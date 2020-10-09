# Example based on Chris Paciorek's tutorial:
# https://github.com/berkeley-scf/tutorial-parallel-basics/blob/master/parallel-basics.html
#
# Note: there is a conflict between openBLAS, the multi-threaded linear
# algebra package, and foreach.  It can cause linear algebra operations
# within a foreach loop to hang
# If your system uses openBLAS (note that the SCF computers do),
# then before running R, execute the command:
#
# export OMP_NUM_THREADS=1
#
# This command sets an environment variable that tells BLAS to only
# use a single thread.


###################################################
########## identify number of cores ###############
###################################################




###################################################
################### FOREACH #######################
###################################################

library(foreach)
library(doParallel)
library(parallel)

# load in data and looFit() function
source("rf.R")

# look at the looFit (leave-one-out fit) function
looFit

# check number of cores on machine
# detectCores(all.tests = FALSE, logical = TRUE)

# set the number of cores to use manually
nCores <- 3
registerDoParallel(nCores) 

# do only first 30 for illustration
nSub <- 30

# without parallelization
ptm <- proc.time()  # start timer
outputs <- rep(NA, nSub)
for (i in 1:nSub) {
  cat('Starting ', i, 'th job.\n', sep = '')
  outputs[i] <- looFit(i, Y, X)
  cat('Finishing ', i, 'th job.\n', sep = '')
}
proc.time() - ptm  # compute time elapsed

str(outputs)

# with parallelization
ptm <- proc.time()  # start timer
result <- foreach(i = 1:nSub) %dopar% {
  cat('Starting ', i, 'th job.\n', sep = '')
  output <- looFit(i, Y, X)
  cat('Finishing ', i, 'th job.\n', sep = '')
  output # this will become part of the out object
}
proc.time() - ptm  # compute time elapsed

str(result)
result_df <- data.frame(results = unlist(result))
str(result_df)

# with parallelization and concatenation of results 
ptm <- proc.time()  # start timer
result <- foreach(i = 1:nSub, .combine = "c", .packages = c("randomForest")) %dopar% {
  cat('Starting ', i, 'th job.\n', sep = '')
  output <- looFit(i, Y, X)
  cat('Finishing ', i, 'th job.\n', sep = '')
  output # this will become part of the out object
}
proc.time() - ptm  # compute time elapsed

str(result)

# remember to save the results of your analysis if 
# you're running it using a shell script!
write.csv(result_df, "results_foreach.csv")


####################################################
################## parLapply #######################

library(parallel)

# set the number of cores to use manually
nCores <- 3  # to set manually 
cl <- makeCluster(nCores) 

nSub <- 30
input <- 1:nSub

# clusterExport(cl, c('x', 'y')) # if the processes need objects
# from master's workspace (not needed here as no global vars used)

# need to load randomForest package within function
# when using parLapply/parSapply
ptm <- proc.time()  # start timer
result <- parLapply(cl = cl, X = 1:nSub,
                    fun = looFit, 
                    # extra arguments to looFit
                    Y = Y, X, loadLib = TRUE)
proc.time() - ptm  # compute time elapsed

result_df <- data.frame(results = unlist(result))


# remember to save the results of your analysis if 
# you're running it using a shell script!
write.csv(result_df, "results_foreach.csv")