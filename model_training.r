library(tidymodels)
library(readr)
library(yardstick)
library(jsonlite)
library(purrr)
library(stringr)
library(xgboost)
library(dplyr)

# function to write json files
write_json <- function(object, filename){
    s <- toJSON(object)
    s <- substring(s, 2, nchar(s) - 1)
    s <- str_replace_all(s, "\\},", "\\}\n")
    write(s, filename)
}

# importing data
df = readr::read_csv("german_credit_data.csv")

# converting 0,1s in label to string counterparts and then to factor
df <- transform(df, label = ifelse((label>0), "Default", "Pay Off"))
df <- df %>% mutate(label = factor(label))

# setting random seed for reproducibility
set.seed(777)

# train/test split
df_split <- initial_split(df, prop=0.8, strata=label)
df_baseline <- training(df_split)
df_sample <- testing(df_split)

glimpse(df_baseline)

# save the train and test data for later use
write_json(df_baseline, 'df_baseline.json')
write_json(df_sample, 'df_sample.json')

# dropping id and gender columns from dataframes
# df_baseline <- df_baseline %>% select(-c(id, gender))
# df_sample <- df_sample %>% select(-c(id, gender))

# feature engineering
gc_recipe <-
    # selecting all columns to predict `label`
    recipe(label ~ ., data=df_baseline) %>%
    # removing the id and gender columns from being predictive variables
    step_rm(id, gender) %>% 
    # dummying all categorical features
    step_dummy(all_nominal(), -all_outcomes()) %>%
    # dropping columns with 0 variance ie. are only one value
    step_zv(all_predictors()) %>%
    # normalizing all columns to have a mean of 0, std of 1
    step_normalize(all_predictors())

# check out summary of recipe
summary(gc_recipe)

# fitting the model, simple logistic regression
logreg <- logistic_reg(penalty=tune(), mixture=tune()) %>% 
    set_engine("glm") %>%
    set_mode("classification")

# creating workflow by combining recipe and model
logreg_wflow <-
    workflow() %>%
    add_model(logreg) %>%
    add_recipe(gc_recipe)

# training the model
logreg_fit <- fit(logreg_wflow, df_baseline)

# predicting on baseline and sample data
train_preds <- predict(logreg_fit, df_baseline)
test_preds <- predict(logreg_fit, df_sample)

# binding predictions to original dataframes
df_baseline_scored <- bind_cols(train_preds, df_baseline)
df_sample_scored <- bind_cols(test_preds, df_sample)

glimpse(df_baseline_scored)

# evaluate outcomes
metrics <- metric_set(recall, precision, f_meas, accuracy, kap)
metrics(df_baseline_scored, truth=label, estimate=.pred_class)
metrics(df_sample_scored, truth=label, estimate=.pred_class)

# rename columns: label -> label_value, .pred -> score
df_baseline_scored <- rename(df_baseline_scored, label_value=label, score=.pred_class) %>% relocate(label_value, score)
df_sample_scored <- rename(df_sample_scored, label_value=label, score=.pred_class) %>% relocate(label_value, score)

# save "scored" dataframes for later analysis
write_json(df_baseline_scored, "df_baseline_scored.json")
write_json(df_sample_scored, "df_sample_scored.json")

# persisting the fit model (the trained workflow)
save(logreg_fit, file="trained_model.RData")

# --------------------------------------------------------

# testing loading and predicting with fit model
# run below code without running above code to test

# importing necessary libraries
library(tidymodels)
library(readr)
library(jsonlite)

# importing test data (flatten to prevent nesting)
data_in <- stream_in(file("df_sample.json"),flatten = TRUE)
test_data <- tibble(data_in)

# loading fit model
load("trained_model.RData")

# re-assigning model for clarity
model <- logreg_fit

# predicting
predict(model, test_data)
