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

cleanProblyData <- function(probly_orig) {
  # A function to clean the perception probability data
  # 
  # Arguments:
  #   probly_orig: a data.frame in the format of the output of the 
  #     loadPerceptData(filename = "probly.csv") function
  # Returns:
  #   a data.frame similar to the input `probly_orig` but with cleaned
  #     variable names
  
  # convert from wide to long forma
  probly <- probly_orig %>%
    rownames_to_column("id") %>%
    gather(key = "phrase", value = "prob", -id) %>%
    mutate(phrase = str_replace_all(phrase, "[.]", " "),  # replace . with space
           prob = prob / 100,  # convert to %
           id = as.factor(id))  
  
  # order phrases
  probly$phrase <- factor(probly$phrase,
                            c("Chances Are Slight",
                              "Highly Unlikely",
                              "Almost No Chance",
                              "Little Chance",
                              "Probably Not",
                              "Unlikely",
                              "Improbable",
                              "We Doubt",
                              "About Even",
                              "Better Than Even",
                              "Probably",
                              "We Believe",
                              "Likely",
                              "Probable",
                              "Very Good Chance",
                              "Highly Likely",
                              "Almost Certainly"))
  return(probly)
}

cleanNumberlyData <- function(numberly_orig) {
  # A function to clean the perception number data
  # 
  # Arguments:
  #   numberly_orig: a data.frame in the format of the output of the 
  #     loadPerceptData(filename = "numberly.csv") function
  # Returns:
  #   a data.frame similar to the input `numberly_orig` but with cleaned
  #     variable names
  
  # convert from wide to long forma
  numberly <- numberly_orig %>%
    rownames_to_column("id") %>%
    gather(key = "phrase", value = "number", -id) %>%
    mutate(phrase = str_replace_all(phrase, "[.]", " "),  # replace . with space
           id = as.factor(id))  
  
  # order phrases
  numberly$phrase <- factor(numberly$phrase, 
                              c("Hundreds of",
                                "Scores of",
                                "Dozens",
                                "Many",
                                "A lot",
                                "Several",
                                "Some",
                                "A few",
                                "A couple",
                                "Fractions of"))
  return(numberly)
}

