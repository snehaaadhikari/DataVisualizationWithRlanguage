# DataVisualizationWithRlanguage
This is R programming language Data visualization based Bank's Churn Prediction. 
DataSet Descriptions: 
This dataset was obtained from kaggle "https://www.kaggle.com/datasets/gauravtopre/bank-customer-churn-dataset", as it covers data into 10,000 rows and 12 primary columns in a tabular and raw form claimed to be sourced from the Multistate Bank also known as ABC bank. The columns are maintained based on customer id, credit score, geography, gender, age, balance, tenure (number of years of customer’s collaboration), NumofProducts, HasCRCredit (checking if customer has credit card or not), IsActiveMember (Active Status checking with binary coding i.e., 1 and 0), EstimatedSalary (customer’s annual salary), and Exited (checking whether the customer churn the bank).  These columns can also be classified into logical categories like demographics to represent age, gender, and geography, financial profile to represent credit score, account balance, and salary, and relationship metrics to represent tenure, number of products, credit card, and activity status. 


Findings:
The findings of this bank churn data visualization report include several key insights across data cleaning, exploratory analysis, and statistical modeling:
1. Germany has a significantly higher customer churn rate at 32.3% compared to Spain (16.5%) and France (16.1%).
2. These results indicate an acute retention problem in Germany, while customer behavior remains relatively stable in Spain and France.



Findings from Data Cleaning and Transformation: 
1.The analysis identified outliers in the `credit_score` column, with the lowest scores ranging from approximately 300 to 350. After removing these outliers, the median credit scores were found to be stable between 580 and 720.
2. Min-Max scaling was found to be more accurate than log transformation for this dataset. Log transformation introduced unwanted skewness, while Min-Max scaling maintained the original distribution shape within a normalized range.
3. Initial inspections confirmed there were no missing or null values in the dataset.
Statistical Modeling Outcome:
Balance Predictors were acknowledge through Multiple Linear Regression model that indicates customers in Germany have significantly higher bank balances—approximately 57,518 units higher—compared to the reference country (USA).
