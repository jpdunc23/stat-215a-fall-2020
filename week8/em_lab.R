library(EMCluster)
library(tidyverse)
library(gridExtra)
library(BDgraph)
set.seed(215)

########################### Illustrative EM Example ############################

# number of samples
n <- 100

# simulate cluster assignments from Bern(0.5)
cluster_asgn <- rbinom(n = n, size = 1, prob = 0.5) + 1

# simulate data from normal mixture model
x <- rep(NA, n)
x[cluster_asgn == 1] <- rnorm(n = sum(cluster_asgn == 1), mean = 3, sd = 1)
x[cluster_asgn == 2] <- rnorm(n = sum(cluster_asgn == 2), mean = 0, sd = 1)

# plot true clusters
plt_df <- data.frame(x = x, cluster = as.factor(cluster_asgn))
p_true <- ggplot(plt_df) +
  aes(x = x, fill = cluster, color = cluster) +
  geom_density(alpha = .3) +
  geom_rug() +
  stat_function(fun = dnorm,
                args = list(mean = 0, sd = 1),
                color = 4, linetype = 2) +
  stat_function(fun = dnorm,
                args = list(mean = 3, sd = 1),
                color = 2, linetype = 2) +
  theme_classic() +
  labs(title = "True Clusters")
p_true

# run EM
x <- as.matrix(x)
em_init <- simple.init(x, nclass = 2)
em_out <- emcluster(x = as.matrix(x), emobj = em_init, assign.class = T)

# plot clusters from EM
plt_df <- data.frame(x = x, cluster = as.factor(em_out$class))
p_em <- ggplot(plt_df) +
  aes(x = x, fill = cluster, color = cluster) +
  geom_density(alpha = .3) +
  geom_rug() +
  stat_function(fun = dnorm,
                args = list(mean = em_out$Mu[1], sd = em_out$LTSigma[1]),
                color = 2, linetype = 2) +
  stat_function(fun = dnorm,
                args = list(mean = em_out$Mu[2], sd = em_out$LTSigma[2]),
                color = 4, linetype = 2) +
  theme_classic() +
  labs(title = "EM Clusters")
p_em

# plot true clusters alongside EM clusters
grid.arrange(p_true, p_em)

# number of misclassified examples
table(cluster_asgn, em_out$class)
sum(cluster_asgn != em_out$class)
sum(cluster_asgn != em_out$class) / n

######################### 2D Illustrative EM Example ##########################

# number of samples
n <- 100

# simulate cluster assignments from Bern(0.5)
cluster_asgn <- rbinom(n = n, size = 1, prob = 0.5) + 1

# simulate data from normal mixture model
x <- matrix(NA, nrow = n, ncol = 2)
x[cluster_asgn == 1, ] <- rmvnorm(n = sum(cluster_asgn == 1), mean = c(3, 2))
x[cluster_asgn == 2, ] <- rmvnorm(n = sum(cluster_asgn == 2), mean = c(0, 0))

# plot true clusters
plt_df <- data.frame(x = x, cluster = as.factor(cluster_asgn))
p_true <- ggplot(plt_df) +
  aes(x = x.1, y = x.2, fill = cluster, color = cluster) +
  geom_point() +
  theme_classic() +
  labs(title = "True Clusters")
p_true

# run EM
x <- as.matrix(x)
em_init <- simple.init(x, nclass = 2)
em_out <- emcluster(x = as.matrix(x), emobj = em_init, assign.class = T)

# plot clusters from EM
plt_df <- data.frame(x = x, cluster = as.factor(em_out$class))
p_em <- ggplot(plt_df) +
  aes(x = x.1, y = x.2, fill = cluster, color = cluster) +
  geom_point() +
  theme_classic() +
  labs(title = "EM Clusters")
p_em

# plot true clusters alongside EM clusters
grid.arrange(p_true, p_em)

# number of misclassified examples
table(cluster_asgn, em_out$class)
sum(cluster_asgn != em_out$class)
sum(cluster_asgn != em_out$class) / n

######################## Misspecified Model EM Example #########################
# Q: What happens when the original data does not arise from normal mixture model? Does EM clustering break down? Try simulating data from a non-normal mixture model.








######################## Implementing EM algorithm ######################### 
# For a normal mixture model with two components, try implementing the EM algorithm from scratch by iterating between the E and M steps, for which we derived formulas in class.










