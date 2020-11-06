library(tidyverse)
library(glmnet)
library(BDgraph)  # for rmvnorm()
library(GGally)
library(ggpubr)
library(e1071)  # for naiveBayes()
library(MASS)  # for lda()
library(class)  # for knn()
set.seed(215)


############ Toy Example 1: simulate from correlated Gaussians ################
n <- 100  # number of samples
p <- 2  # number of features
# mean of class 0
mu0 <- c(3, 1)
# mean of class 1
mu1 <- c(1, 1)
# simulate from correlated features
Sig <- matrix(c(1, .7, .7, 1), byrow = T, nrow = 2, ncol = 2)

# simulate binary class assignments (y = 0 or 1)
ytr <- sample(0:1, n, replace = T)  
yts <- sample(0:1, n, replace = T)

# initialize training and test data matrices
Xtr <- matrix(NA, nrow = n, ncol = p)
Xts <- matrix(NA, nrow = n, ncol = p)
# simulate X | y = 0 ~ N(mu0, Sig) 
Xtr[ytr == 0, ] <- rmvnorm(n = sum(ytr == 0), mean = mu0, sigma = Sig)
Xts[yts == 0, ] <- rmvnorm(n = sum(yts == 0), mean = mu0, sigma = Sig)
# simulate X | y = 1 ~ N(mu1, Sig) 
Xtr[ytr == 1, ] <- rmvnorm(n = sum(ytr == 1), mean = mu1, sigma = Sig)
Xts[yts == 1, ] <- rmvnorm(n = sum(yts == 1), mean = mu1, sigma = Sig)

# take a quick look at the data and true classes for training
ggplot(as.data.frame(Xtr)) +
  aes(x = V1, y = V2, color = as.factor(ytr)) +
  geom_point() +
  coord_fixed() +
  labs(color = "Class", x = "x1", y = "x2", title = "True Classes (Training)")

# see true classes for test
p_true <- ggplot(as.data.frame(Xts)) +
  aes(x = V1, y = V2, color = as.factor(yts)) +
  geom_point() +
  coord_fixed() +
  labs(color = "Class", x = "x1", y = "x2", title = "True Classes (Test Data)")
p_true

# apply lda
fit_lda <- lda(x = Xtr, grouping = as.factor(ytr))
predict_lda <- predict(fit_lda, Xts)$class
(err_tab_lda <- table(predict_lda, yts))
(err_lda <- sum(predict_lda != yts) / length(yts))
p_lda <- ggplot(as.data.frame(Xts)) +
  aes(x = V1, y = V2, color = as.factor(predict_lda)) +
  geom_point() +
  coord_fixed() +
  labs(color = "Class", x = "x1", y = "x2", title = "LDA Predictions")
p_lda

# compute lda decision boundary by finding eigenvectors of Sigma_w^-1 * Sigma_b
mu_hat <- colMeans(Xtr)  # total means
mu0_hat <- colMeans(Xtr[ytr == 0, ])  # within group 0 mean
mu1_hat <- colMeans(Xtr[ytr == 1, ])  # within group 1 mean
group_mean <- matrix(NA, ncol = 2, nrow = n)
group_mean[ytr == 0, ] <- matrix(mu0_hat, byrow = T, 
                                 ncol = 2, nrow = sum(ytr == 0))
group_mean[ytr == 1, ] <- matrix(mu1_hat, byrow = T,
                                 ncol = 2, nrow = sum(ytr == 1))
Sigw <- 1/(n-2) * t(Xtr - group_mean) %*% (Xtr - group_mean)
Sigb <- 1/(n-1) * (sum(ytr == 0) * (mu0_hat - mu_hat) %*% t(mu0_hat - mu_hat) +
                     sum(ytr == 1) * (mu1_hat - mu_hat) %*% t(mu1_hat - mu_hat))
V <- eigen(x = solve(Sigw) %*% Sigb)$vectors
lda_proj <- scale(Xtr, center = T, scale = F) %*% V
p1 <- ggplot(as.data.frame(scale(Xts, center = T, scale = F))) +
  aes(x = V1, y = V2, color = as.factor(predict_lda)) +
  geom_point() +
  labs(color = "Class", x = "x1", y = "x2", title = "LDA Predictions") +
  geom_abline(intercept = 0, slope = V[2, 1] / V[1, 1], color = "blue")
p2 <- ggplot(as.data.frame(Xts %*% V)) +
  aes(x = V1, y = V2, color = as.factor(predict_lda)) +
  geom_point() +
  labs(color = "Class", x = "LDA1", y = "LDA2", title = "LDA Predictions") 
# compare to PCA
pca_out <- prcomp(x = Xtr)
p3 <- ggplot(as.data.frame(pca_out$x)) +
  aes(x = PC1, y = PC2, color = as.factor(predict_lda)) +
  geom_point() +
  labs(color = "Class", title = "PC Plot with LDA Predictions") 
ggarrange(p1, p2, p3, nrow = 1, ncol = 3, common.legend = T)
# interpret V vector
V[, 1]

# apply logistic
log_df <- data.frame(y = as.factor(ytr), Xtr)
log_ts_df <- data.frame(Xts)
fit_log <- glm(y ~., data = log_df, family = "binomial")
predict_log <- as.numeric(predict(fit_log, log_ts_df, "response") > .5)
(err_tab_log <- table(predict_log, yts))
(err_log <- sum(predict_log != yts) / length(yts))
p_log <- ggplot(as.data.frame(Xts)) +
  aes(x = V1, y = V2, color = as.factor(predict_log)) +
  geom_point() +
  coord_fixed() +
  labs(color = "Class", x = "x1", y = "x2", title = "Logistic Predictions")

# apply naive bayes
fit_nb <- naiveBayes(x = Xtr, y = as.factor(ytr))
predict_nb <- predict(fit_nb, Xts)
(err_tab_nb <- table(predict_nb, yts))
(err_nb <- sum(predict_nb != yts) / length(yts))
p_nb <- ggplot(as.data.frame(Xts)) +
  aes(x = V1, y = V2, color = as.factor(predict_nb)) +
  geom_point() +
  coord_fixed() +
  labs(color = "Class", x = "x1", y = "x2", title = "Naive Bayes Predictions")

ggarrange(p_true, p_nb, p_lda, p_log, nrow = 2, ncol = 2, common.legend = T)

############# Toy Simulation 2: Efficiency of LDA and logistic  ###############
# simulate train and test data from LDA model and logistic model
ns <- seq(from = 25, to = 500, by = 25)
gaus_sim_res <- matrix(NA, nrow = length(ns), ncol = 2)
log_sim_res <- matrix(NA, nrow = length(ns), ncol = 2)
for (i in 1:length(ns)) {
  n <- ns[i]  # number of samples
  p <- 2  # number of features
  
  # lda model parameters
  Sig <- matrix(c(1, .7, .7, 1), byrow = T, nrow = 2, ncol = 2) # wi covariance
  mu0 <- c(3, 1)  # mean of class 0
  mu1 <- c(1, 3)  # mean of class 1
  
  # logistic model parameters
  alpha <- 2
  beta <- matrix(c(1, -3), nrow = 2, ncol = 1)
  
  # run 100 trials under LDA model
  gaus_sim_res[i, ] <- sapply(
    X = 1:100,
    FUN = function(X) {
      # simulate binary class assignments (y = 0 or 1)
      ytr <- sample(0:1, n, replace = T)  
      yts <- sample(0:1, n, replace = T)
      # initialize training and test data matrices
      Xtr <- matrix(NA, nrow = n, ncol = p)
      Xts <- matrix(NA, nrow = n, ncol = p)
      # simulate X | y = 0 ~ N(mu0, Sig) 
      Xtr[ytr == 0, ] <- rmvnorm(n = sum(ytr == 0), mean = mu0, sigma = Sig)
      Xts[yts == 0, ] <- rmvnorm(n = sum(yts == 0), mean = mu0, sigma = Sig)
      # simulate X | y = 1 ~ N(mu1, Sig) 
      Xtr[ytr == 1, ] <- rmvnorm(n = sum(ytr == 1), mean = mu1, sigma = Sig)
      Xts[yts == 1, ] <- rmvnorm(n = sum(yts == 1), mean = mu1, sigma = Sig)
      
      # apply lda
      fit_lda <- lda(x = Xtr, grouping = as.factor(ytr))
      predict_lda <- predict(fit_lda, Xts)$class
      err_lda <- sum(predict_lda != yts) / length(yts)
      
      # apply logistic
      log_df <- data.frame(y = as.factor(ytr), Xtr)
      log_ts_df <- data.frame(Xts)
      fit_log <- glm(y ~., data = log_df, family = "binomial")
      predict_log <- as.numeric(predict(fit_log, log_ts_df, "response") > .5)
      err_log <- sum(predict_log != yts) / length(yts)
      return(c(err_lda, err_log))
    } 
  ) %>%
    rowMeans()
  
  # run 100 trials under logistic model
  log_sim_res[i, ] <- sapply(
    X = 1:100,
    FUN = function(X) {
      # simulate data matrix from non-Gaussian
      Xtr <- matrix(rexp(n * p), nrow = n, ncol = p)
      Xts <- matrix(rexp(n * p), nrow = n, ncol = p)
      
      # simulate binary class assignments (y = 0 or 1)
      ytr <- rbinom(n = n, size = 1, 
                    prob = exp(alpha + Xtr %*% beta) / 
                      (1 + exp(alpha + Xtr %*% beta)))
      yts <- rbinom(n = n, size = 1, 
                    prob = exp(alpha + Xts %*% beta) / 
                      (1 + exp(alpha + Xts %*% beta)))
      
      # apply lda
      fit_lda <- lda(x = Xtr, grouping = as.factor(ytr))
      predict_lda <- predict(fit_lda, Xts)$class
      err_lda <- sum(predict_lda != yts) / length(yts)
      
      # apply logistic
      log_df <- data.frame(y = as.factor(ytr), Xtr)
      log_ts_df <- data.frame(Xts)
      fit_log <- glm(y ~., data = log_df, family = "binomial")
      predict_log <- as.numeric(predict(fit_log, log_ts_df, "response") > .5)
      err_log <- sum(predict_log != yts) / length(yts)
      return(c(err_lda, err_log))
    } 
  ) %>%
    rowMeans()
}
colnames(gaus_sim_res) <- c("LDA", "Logistic")
colnames(log_sim_res) <- c("LDA", "Logistic")
p_gaus_sim <- as.data.frame(gaus_sim_res) %>%
  mutate(n = ns) %>%
  gather(key = "Method", value = "Mean Error", -n) %>%
  ggplot() +
  aes(x = n, y = `Mean Error`, color = Method) +
  geom_line() +
  labs(title = "Simulation under LDA Model")
p_log_sim <- as.data.frame(log_sim_res) %>%
  mutate(n = ns) %>%
  gather(key = "Method", value = "Mean Error", -n) %>%
  ggplot() +
  aes(x = n, y = `Mean Error`, color = Method) +
  geom_line() +
  labs(title = "Simulation under Logistic Model")
ggarrange(p_gaus_sim, p_log_sim, ncol = 2, common.legend = T)

################################ Abalone Data #################################
ab_train <- read.csv("./data/abalone-training.csv", header = T)
ab_test <- read.csv("./data/abalone-test.csv", header = T)
yts <- ab_test$old
ab_test <- ab_test %>% 
  dplyr::select(-old)

# perform logistic regression
fit_log <- glm(old ~., data = ab_train, family = "binomial")
predict_log <- as.numeric(predict(fit_log, ab_test, "response") > .5)
(err_tab_log <- table(predict_log, yts))
(err_log <- sum(predict_log != yts) / length(yts))

# for regularized logistic regression: 
# use glmnet(..., family = "binomial", alpha = ...)
# or ncvreg(..., family = "binomial", penalty = ...)

# apply naive bayes
fit_nb <- naiveBayes(old ~., data = ab_train)
predict_nb <- predict(fit_nb, ab_test)
(err_tab_nb <- table(predict_nb, yts))
(err_nb <- sum(predict_nb != yts) / length(yts))

# apply lda
fit_lda <- lda(old ~., data = ab_train)
predict_lda <- predict(fit_lda, ab_test)$class
(err_tab_lda <- table(predict_lda, yts))
(err_lda <- sum(predict_lda != yts) / length(yts))

# apply qda
fit_qda <- qda(old ~., data = ab_train)
predict_qda <- predict(fit_qda, ab_test)$class
(err_tab_qda <- table(predict_qda, yts))
(err_qda <- sum(predict_qda != yts) / length(yts))

