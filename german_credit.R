# import libraries
packages <- c("readr", "tidymodels")
install.packages(setdiff(packages, rownames(installed.packages())), repos="http://cran.us.r-project.org")

library(tidymodels)
library(readr)

# modelop.init
begin <- function(){
    # model <- read_rds("trained_model.rds")
    load("trained_model.RData")
    model <<- logreg_fit
}   

# modelop.score
action <- function(data){
    df <- data.frame(data, stringsAsFactors=F)
    preds <- predict(model, df)
    output <- list(label_value=df$label, score=preds$.pred_class)
    emit(output)

# modelop.metrics
metrics <- function(data){
    df <- data.frame(data)
    get_metrics <- metric_set(recall, precision, f_meas, accuracy, 
        kap, sensitivity, specificity)
    output <- get_metrics(data=df, truth=X0.label_value, estimate=X0.score)
    emit(output)
}