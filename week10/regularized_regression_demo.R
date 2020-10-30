library(glmnet)
library(ncvreg)
library(tidyverse)
library(GGally)
library(cosso)  # for ozone data
set.seed(123)

############################## Toy Example ############################## 
# simulate correlated data
n <- 20  # number of samples
x1 <- rnorm(n)
x2 <- rnorm(n, mean = x1, sd = 0.01)
X <- cbind(x1, x2)

# simulate responses via y = 3 + x1 + x2 + noise
y <- rnorm(n, mean = 3 + x1 + x2, sd = 1)

# take a quick look at the correlation
plot(x1, x2)
cor(x1, x2)

# apply OLS to the correlated data
lm_fit <- lm(y ~ x1 + x2)
summary(lm_fit)  # -> coefficients have opposite signs!

# apply ridge regression to the correlated data
ridge_fit <- glmnet(x = X, y = y, alpha = 0, lambda = 1)
coef(ridge_fit)  # -> coefficients are shrunk together

# apply lasso regression to the correlated data
lasso_fit <- glmnet(x = X, y = y, alpha = 1, lambda = 1)
coef(lasso_fit)  # -> only one coefficient is selected from the correlated group



############################## Ozone Data ############################## 

# load in data 
data(ozone)
str(ozone)
? ozone

# helper variables
y <- ozone$ozone
X.df <- ozone %>%
  select(-ozone)
X <- as.matrix(X.df)
Xc <- scale(X, center = T, scale = T)  # centered and scaled data
yc <- scale(y, center = T, scale = F)  # centered responses
n <- nrow(ozone)
p <- ncol(X)

#### Fit OLS ####

# directly fit OLS
X1 <- cbind(1, X)
betah_ls <- solve(t(X1) %*% X1) %*% t(X1) %*% y  # estimated coefficients

# fit OLS using "lm"
lm_fit <- lm(ozone ~ ., data = ozone)
summary(lm_fit)

# check if lm results agree
cbind(betah_ls, lm_fit$coefficients)

#### Fit Ridge ####
# grid of tuning parameters to try
lams <- exp(seq(log(.01), log(100 * n), l = 100))

# fit ridge directly
betah_r <- map_dfc(
  lams,
  function(lam) {
    return(solve(t(Xc) %*% Xc + diag(lam, p)) %*% t(Xc) %*% yc)
  }
) %>%
  setNames(lams) %>%
  mutate(Variable = as.factor(colnames(X)))

# plot ridge regression paths  
betah_r %>%
  gather(key = "Lambda", value = "Coefficient", -Variable) %>%
  mutate(`log(Lambda)` = log(as.numeric(`Lambda`))) %>%
  ggplot() +
  aes(x = `log(Lambda)`, y = Coefficient, color = Variable) %>%
  geom_line() +
  geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
  labs(title = "Ridge Regularization Paths") +
  theme_classic()

# fit ridge using glmnet
ridge_fit <- glmnet(x = X, y = y, alpha = 0, lambda = lams)
plot(ridge_fit, xvar = "lambda")

# look at correlation among pairs of features
ggpairs(ozone)

# compare coefficient estimates between ridge and OLS
data.frame(betah_ls[-1],  # don't care about OLS intercept term
           ridge_fit$beta[, 60],  # can play with ridge penalty parameter
           row.names = colnames(X)) %>%
  setNames(c("OLS", "Ridge"))

#### Fit Lasso ####

# fit lasso using glmnet
lasso_fit <- glmnet(x = X, y = y, alpha = 1)
plot(lasso_fit, xvar = "lambda", col = 1:p, main = "Lasso")
legend("topright", legend = colnames(X), col = 1:p, lty = 1, cex = .75)

# compare coefficient estimates between ridge and OLS
data.frame(betah_ls[-1],  # don't care about OLS intercept term
           ridge_fit$beta[, 60],  # can play with ridge penalty parameter
           lasso_fit$beta[, 20],  # can play with lasso penalty parameter
           row.names = colnames(X)) %>%
  setNames(c("OLS", "Ridge", "Lasso"))

#### OLS, Ridge, Elastic Net, Lasso, Adaptive Lasso, SCAD, MCP ####

lam <- 1

betah_ls <- solve(t(X1) %*% X1) %*% t(X1) %*% y
betah_r <- glmnet(x = X, y = y, lambda = lam, alpha = 0)$beta
betah_el <- glmnet(x = X, y = y, lambda = lam, alpha = .5)$beta
betah_l <- glmnet(x = X, y = y, lambda = lam, alpha = 1)$beta
betah_al <- glmnet(x = X, y = y, lambda = lam, alpha = 1, 
                     penalty.factor = 1 / abs(betah_ls[-1]))$beta
betah_scad <- ncvreg(X = X, y = y, penalty = "SCAD", lambda = lam)$beta[-1]
betah_mcp <- ncvreg(X = X, y = y, penalty = "MCP", lambda = lam)$beta[-1]
data.frame(betah_ls[-1], as.matrix(betah_r), as.matrix(betah_l), 
           as.matrix(betah_al), as.matrix(betah_el), betah_scad, betah_mcp) %>%
  setNames(c("LS", "Ridge", "Lasso", "A-Lasso", "EL", "SCAD", "MCP"))

# note that the output of glmnet is a sparse matrix; to convert a sparse matrix into a regular matrix, use as.matrix()

#### compare ridge, lasso, elastic net, SCAD, MCP regualrization paths ####

par(mfrow = c(2, 3))
par(mar = c(5, 4, 3, 2))

ridge_fit <- glmnet(x = X, y = y, alpha = 0)
plot(ridge_fit, xvar = "lambda", label = T, col = 1:p, main = "Ridge")

lasso_fit <- glmnet(x = X, y = y, alpha = 1)
plot(lasso_fit, xvar = "lambda", label = T, col = 1:p, main = "Lasso")

elnet_fit1 <- glmnet(x = X, y = y, alpha = 0.5)
plot(elnet_fit1, xvar = "lambda", label = T, col = 1:p, 
     main = "EL alpha = 0.5")

elnet_fit2 <- glmnet(x = X, y = y, alpha = 0.25)
plot(elnet_fit2, xvar = "lambda", label = T, col = 1:p, 
     main = "EL alpha = 0.25")

scad_fit = ncvreg(X = X, y = y, penalty = "SCAD")
plot(scad_fit, col = 1:p, main = "SCAD", shade = F, log.l = T)

mcp_fit = ncvreg(X = X, y = y, penalty = "MCP")
plot(mcp_fit, col = 1:p, main = "MCP", shade = F, log.l = T)





