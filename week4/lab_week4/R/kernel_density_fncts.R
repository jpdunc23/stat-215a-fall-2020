
# Fill in a kernel function
# Could be Gaussian, square, cosine, etc.
Kernel1 <- function(x, h) {
  # A kernel function for use in nonparametric estimation.
  # Args:
  #  x: The point to evaluate the kernel
  #  h: The bandwidth of the kernel.
  # Returns:
  #  The value of a kernel with bandwidth h evaluated at x.



  return()
}

Kernel2 <- function(x, h) {
  # A kernel function for use in nonparametric estimation.
  # Args:
  #  x: The point to evaluate the kernel
  #  h: The bandwidth of the kernel.
  # Returns:
  #  The value of a kernel with bandwidth h evaluated at x.



  return()
}

EstimateDensity <- function(x_data, KernelFun, h, 
                            resolution = length(eval_x), 
                            eval_x = NULL) {
  # Perform a kernel density estimate.
  # Args:
  #   x_data: The observations from the density to be estimated.
  #   KernelFun: A kernel function.
  #   h: the bandwidth.
  #   resolution: The number of points at which to evaluate the density.  
  #               Only necessary
  #               if eval_x is unspecified.
  #   eval_x: Optional, the points at which to evaluate the density. Defaults to
  #           resolution points in [min(x_data), max(x_data)]
  # Returns:
  #  A data frame containing the x values and kernel density estimates with
  #  column names "x" and "f.hat" respectively.
  if (is.null(eval.x)) {
    # Get the values at which we want to plot the function
    eval.x = seq(from = min(x.data), to = max(x.data), length.out=resolution)
  }
  
  # Calculate the estimated function values.
  MeanOfKernelsAtPoint <- function(x) {
    return(mean(KernelFun(x.data - x, h)))
  }
  f.hat <- sapply(eval.x, MeanOfKernelsAtPoint)
  return(data.frame(x=eval.x, f.hat=f.hat,
                    Kernel=as.character(match.call()[[3]]), h=h))
}

# density <- EstimateDensity(rnorm(1000), Kernel1, 1, resolution = 100)
# plot(density$x, density$f.hat)
