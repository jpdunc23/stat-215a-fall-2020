# K-means
library(R.utils)

# simulate data from three clusters with mean mu1, mu2, mu3, and variance Sig
sim1 <- function() {
  n <- 300
  mu1 <- c(3, 3)
  mu2 <- c(7, 4)
  mu3 <- c(6, 5.5)
  Sig <- matrix(c(1, .5, .5, 1), 2, 2)
  x1 <- t(matrix(mu1, 2, n / 3)) + matrix(rnorm(n), n / 3, 2)
  xx <- matrix(rnorm(n * 2 / 3), n / 3, 2)
  x2 <- t(matrix(mu2, 2, n / 3)) + xx %*% chol(Sig)
  xx <- matrix(rnorm(n * 2 / 3), n / 3, 2)
  x3 <- t(matrix(mu3, 2, n / 3)) + xx %*% chol(Sig)
  x <- rbind(x1, x2, x3)
  Y <- c(rep(1, n / 3), rep(2, n / 3), rep(3, n / 3))
  y <- factor(Y)
  return(list(x = x, y = y))
}

# simulate data from two unequally-sized clusters with mean mu1, mu2, and 
# variances Sig1, Sig2
sim2 <- function() {
  n1 <- 250
  n2 <- 50
  mu1 <- c(3, 3)
  mu2 <- c(6, 5)
  Sig1 <- diag(2)  # var = 1
  Sig2 <- diag(2) / 10  # var = .1
  x1 <- t(matrix(mu1, 2, n1)) + matrix(rnorm(n1 * 2), n1, 2) %*% chol(Sig1)
  x2 <- t(matrix(mu2, 2, n2)) + matrix(rnorm(n2 * 2), n2, 2) %*% chol(Sig2)
  x <- rbind(x1, x2)
  Y <- c(rep(1, n1), rep(2, n2))
  y <- factor(Y)
  return(list(x = x, y = y))
}

# code to understand K-means algorithm
require("animation")
mv.kmeans <- function(x, k, cens = NULL) {
  n <- nrow(x)
  if (is.null(cens)) {
    cens <- x[sample(1:n, k), ]
  }
  plot(x[, 1], x[, 2], pch = 16)
  points(cens[, 1], cens[, 2], col = 1:k, pch = 16, cex = 3)
  thr <- 1e-6
  ind <- 1
  iter <- 1
  while (ind > thr) {
    oldcen <- cens
    km <- kmeans(x, centers = cens, iter.max = 1, nstart = 1, algorithm = "MacQueen")
    plot(x[, 1], x[, 2], col = km$cluster, pch = 16)
    points(cens[, 1], cens[, 2], col = 1:k, pch = 16, cex = 3)
    cens <- km$centers
    # print(cens)
    plot(x[, 1], x[, 2], col = km$cluster, pch = 16)
    points(cens[, 1], cens[, 2], col = 1:k, pch = 16, cex = 3)
    ind <- sum(diag((oldcen - cens) %*% t(oldcen - cens)))
    # print(ind)
  }
}

# simulate data from sim1
sim_data <- sim1()
x <- sim_data$x
y <- sim_data$y

# plot true groups
plot(x[, 1], x[, 2], col = as.numeric(y), pch = 16)

# watch K-means algorithm movie
# start from random starting points
saveHTML(mv.kmeans(x, 3, cens = NULL), img.name = "km-video-k3")

removeDirectory("js", recursive = T)
removeDirectory("css", recursive = T)
removeDirectory("images", recursive = T)
file.remove("index.html")

# now, simulate data from sim2
sim_data <- sim2()
x <- sim_data$x
y <- sim_data$y

# plot true groups
plot(x[, 1], x[, 2], col = as.numeric(y), pch = 16)

# watch K-means algorithm movie
# start from random starting points
saveHTML(mv.kmeans(x, 2, cens = NULL), img.name = "km-video-k2")

removeDirectory("js", recursive = T)
removeDirectory("css", recursive = T)
removeDirectory("images", recursive = T)
file.remove("index.html")
