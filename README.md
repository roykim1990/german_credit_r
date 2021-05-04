# german_credit_r
A sample data science project that uses a Logitistic Regression model built in R to predict default or pay off of loands from the German Credit dataset. Specifically, this example is used to demonstrate the creating of ModelOp Center(MOC)-compliant code.

## Assets:
- `german_credit.R` is the R code that houses the MOC-compliant code to predict and get metrics on data.
- `trained_model.RData` is the trained model artifact that is loaded upon prediction. In our case, the artifact is a workflow built on top of a recipe that includes a few data cleaning steps and a call to a linear regression model.
- The datasets used for **scoring** are `df_baseline.json` and `df_sample.json`. These datasets represent raw data that would first be run into a batch scoring job. A sample of the outcome to the scoring job is provided in the `output_action_sample.json` file.
- The datasets for **metrics** are `df_baseline_scored.json` and `df_sample_scored.json`. These datasets represent data that has appended the predictions from a scoring job. The columns are renamed to be compliant with MOC; `label` is renamed to `label_value` and the prediction column is named `score`.

## Directions:
1. For a **scoring** job, use the `df_baseline.json` or the `df_sample.json` files. The output is a JSON string object that has the orignal `label` and `.pred_class` for each input row.
2. For a **metrics** job, use the `df_baseline_scored.json` or the `df_sample_scored.json` files. THe output is a list of the relevant metrics (F1 score, Accuracy, Sensitivity, Specificity, Precision) for the classification model.

The input data to the **scoring** job is `df_sample.json`, which is a JSONS file (one-line JSON records). Here are the first three records:
```json
{"id":1,"duration_months":48,"credit_amount":5951,"installment_rate":2,"present_residence_since":2,"age_years":22,"number_existing_credits":1,"checking_status":"A12","credit_history":"A32","purpose":"A43","savings_account":"A61","present_employment_since":"A73","debtors_guarantors":"A101","property":"A121","installment_plans":"A143","housing":"A152","job":"A173","number_people_liable":1,"telephone":"A191","foreign_worker":"A201","gender":"female","label":"Default"}
{"id":4,"duration_months":24,"credit_amount":4870,"installment_rate":3,"present_residence_since":4,"age_years":53,"number_existing_credits":2,"checking_status":"A11","credit_history":"A33","purpose":"A40","savings_account":"A61","present_employment_since":"A73","debtors_guarantors":"A101","property":"A124","installment_plans":"A143","housing":"A153","job":"A173","number_people_liable":2,"telephone":"A191","foreign_worker":"A201","gender":"male","label":"Default"}
{"id":20,"duration_months":9,"credit_amount":2134,"installment_rate":4,"present_residence_since":4,"age_years":48,"number_existing_credits":3,"checking_status":"A14","credit_history":"A34","purpose":"A40","savings_account":"A61","present_employment_since":"A73","debtors_guarantors":"A101","property":"A123","installment_plans":"A143","housing":"A152","job":"A173","number_people_liable":1,"telephone":"A192","foreign_worker":"A201","gender":"male","label":"Pay Off"}
```

The input data to the **metrics** job is `df_sample_scored.json`, which is a JSONS file (one-line JSON records). Here are the first three records:
```json
{"label_value":"Default","score":"Pay Off","id":1,"duration_months":48,"credit_amount":5951,"installment_rate":2,"present_residence_since":2,"age_years":22,"number_existing_credits":1,"checking_status":"A12","credit_history":"A32","purpose":"A43","savings_account":"A61","present_employment_since":"A73","debtors_guarantors":"A101","property":"A121","installment_plans":"A143","housing":"A152","job":"A173","number_people_liable":1,"telephone":"A191","foreign_worker":"A201","gender":"female"}
{"label_value":"Default","score":"Default","id":4,"duration_months":24,"credit_amount":4870,"installment_rate":3,"present_residence_since":4,"age_years":53,"number_existing_credits":2,"checking_status":"A11","credit_history":"A33","purpose":"A40","savings_account":"A61","present_employment_since":"A73","debtors_guarantors":"A101","property":"A124","installment_plans":"A143","housing":"A153","job":"A173","number_people_liable":2,"telephone":"A191","foreign_worker":"A201","gender":"male"}
{"label_value":"Pay Off","score":"Pay Off","id":20,"duration_months":9,"credit_amount":2134,"installment_rate":4,"present_residence_since":4,"age_years":48,"number_existing_credits":3,"checking_status":"A14","credit_history":"A34","purpose":"A40","savings_account":"A61","present_employment_since":"A73","debtors_guarantors":"A101","property":"A123","installment_plans":"A143","housing":"A152","job":"A173","number_people_liable":1,"telephone":"A192","foreign_worker":"A201","gender":"male"}
```
