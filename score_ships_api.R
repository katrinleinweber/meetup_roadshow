# # Training -------
# # This section of code trains a model m
# # The API assumes the model has already been fit and simply loads the model
# # and uses the predict function
# # Note that for this simple linear model, we could do the prediction easily with math
# 
# 
# library(tidyverse)
# library(mice)
# load("sdata.Rdat")
# 
# vehicle_df <- tibble(
#   name = map_chr(vehicles, "name"),
#   speed = map_chr(vehicles, "max_atmosphering_speed") %>% parse_number(),
#   crew = map_chr(vehicles, "crew") %>% parse_number(),
#   cost = map_chr(vehicles, "cost_in_credits") %>% parse_number(),
#   passengers = map_chr(vehicles, "passengers") %>% parse_number(),
#   cargo = map_chr(vehicles, "cargo_capacity") %>% parse_number(),
#   length = map_chr(vehicles, "length") %>% parse_number()
# )
# 
# # impute the missing values
# imputed <- vehicle_df %>%
#   select(-name) %>%
#   mice(seed = 500) %>%
#   complete(5)
# 
# # fit the linear model against the imputed dataset
# m <- lm(speed ~ ., imputed)
# 
# # save the averages for default values later
# avg <- colMeans(imputed)
# saveRDS(avg, file = "ship_avg.Rds")
# 
# # save the model for later use
# saveRDS(m, file = "model.Rds")


# API ----

library(assertthat)
library(purrr)
library(readr)
m <- readRDS("model.Rds")
avg <- readRDS("ship_avg.Rds")
avg_field <- names(avg)
n_pred <- length(coef(m)) - 1

err_msg <- paste0("Could not parse the `to_score` input, which should be 5 comma seperated values!")

is_numberish <- function(vals) {
  classes <- map_chr(vals, guess_parser)
  tot_numeric <- sum(grepl(pattern = "double|integer", x = classes))
  tot_numeric == length(classes)

}

is_5_csv <- function(to_score) {
  lengths(regmatches(to_score, gregexpr(",", to_score))) == 4
}

on_failure(is_numberish) <- function(call, env) {
  paste0("Arguments contain non-numeric data!")
}

on_failure(is_5_csv) <- function(call, env) {
  err_msg
}

#* @get /score-ship-csv
function(to_score, req) {
  
  # check input
  assert_that(is_5_csv(to_score))
  
  # parse input as csv
  c <- textConnection(to_score)
  vals <- read.csv(c, header = FALSE)  

  # check that the parsed csv has the right types
  assert_that(is_numberish(vals))
  
  # return the score
  sum(coef(m)*c(1, as.numeric(vals)))
}

#* @get /score-ship-named
function(crew = avg[avg_field == "crew"],
         cost = avg[avg_field == "cost"],
         passengers = avg[avg_field == "passengers"],
         cargo =  avg[avg_field == "cargo"],
         length = avg[avg_field == "length"],
         req) {
  
  
  inputs <- list(crew, cost, passengers, cargo, length)
  assert_that(is_numberish(inputs))
  
  vals <- as.numeric(c(1, crew, cost, passengers, cargo, length))
    

  # return the score
  sum(coef(m)*c(1, as.numeric(vals)))
}



