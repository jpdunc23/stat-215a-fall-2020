library(dbscan)
library(kernlab)
library(tidyverse)

############################ DBSCAN Demo ############################

# presidential_speech data: which measures how often the 44 U.S. presidents used
# certain words in their public addresses
presidential_speech <- readRDS("./data/presidential_speech.rds")

# quickly look at the dataset
presidential_speech[1:6, 1:6]
hist(presidential_speech)

# visualize the data via PCA
pca.out <- prcomp(x = presidential_speech, center = F, scale = F)
pc.scores <- as.data.frame(pca.out$x)
ggplot(pc.scores) +
  aes(x = PC1, y = PC2) +
  geom_point()

# run DBSCAN
dbscan.out <- dbscan(presidential_speech, eps = 10.5, minPts = 3)

# see number of samples in each DBSCAN cluster (note: 0 = outlier group)
table(dbscan.out$cluster)

# plot clusters on PC1 vs PC2 plot
ggplot(pc.scores) +
  aes(x = PC1, y = PC2, color = as.factor(dbscan.out$cluster)) +
  geom_point() +
  labs(color = "Cluster")

# plot clusters on PC1 vs PC2 plot with president names
ggplot(pc.scores) +
  aes(x = PC1, y = PC2, 
      color = as.factor(dbscan.out$cluster),
      label = rownames(pc.scores)) +
  geom_text() +
  labs(color = "Cluster")
