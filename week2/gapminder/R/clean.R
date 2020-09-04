cleanGapminderData <- function(gapminder_data) {
  # A function to clean the gapminder data
  # 
  # Arguments:
  #   gapminder_data: a data.frame in the format of the output of the 
  #     loadGapminderData() function
  # Returns:
  #   a data.frame similar to the input `gapminder_data` but with cleaned
  #     variable names
  
  # the following is a bit unnecessary, but I'm going to it anyway 
  
  # rename the columns of the dataset to suit my consistent code format
  gapminder_data <- gapminder_data %>% 
    rename(life_exp = lifeExp,
           gdp_per_cap = gdpPercap,
           population = pop)
  
  return(gapminder_data)
}
