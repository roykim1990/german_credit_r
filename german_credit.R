# import libraries
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
}

# modelop.metrics
metrics <- function(data){
    df <- data.frame(data)
    get_metrics <- metric_set(f_meas, accuracy, sensitivity, specificity, precision)
    output <- get_metrics(data=df, truth=as.factor(X0.label_value), estimate=as.factor(X0.score))
    emit(output)
}
