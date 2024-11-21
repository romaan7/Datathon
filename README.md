
# Diabetes Analysis and Prediction Project

This project focuses on exploratory data analysis (EDA), dimensional modeling, and machine learning to derive insights and predict diabetes status using a comprehensive dataset. The project includes data cleaning, feature engineering, model development, and analysis.

---
The dashboard is live at https://datathon.rosh.dev/

---

## 1. Exploratory Data Analysis (EDA)

### Objectives
The dataset contains information about individuals with attributes like gender, age, BMI, and lifestyle factors. The goal is to identify patterns, relationships, and potential predictors of diabetes.

### Key Steps
1. **Data Cleaning**:
   - Missing values were handled using imputation (mean/median for numerical, mode or "Unknown" for categorical).
   - Outliers in numerical variables (e.g., age, BMI) were removed using the Interquartile Range (IQR) method.
   - The dataset was reduced to 62,545 rows after cleaning.

2. **Insights**:
   - **Age**: Even distribution with peaks in specific age groups.
   - **BMI**: Right-skewed distribution, consistent with population data.
   - **Weight**: Strong positive correlation with diabetes (r=0.253).
   - Other variables like sleep duration and pregnancies showed weak correlations with diabetes.

3. **Correlation Heatmap**:
   - Highlighted relationships between variables. Weight and BMI had the strongest correlation with diabetes.

---

## 2. Dimensional Data Modeling

### Steps to Create a Dimensional Model
1. **Fact Table**:
   - Central table storing diabetes status, weight, BMI, and pregnancies.

2. **Dimension Tables**:
   - **Person Dimension**: Gender, age group, diet type.
   - **Lifestyle Dimension**: Physical activity level, stress level, social media usage.
   - **Health Metrics Dimension**: BMI categories, diabetes pedigree function.

3. **Schema Design**:
   - A **Star Schema** was created with the fact table surrounded by dimension tables for efficient querying.

### Example Queries
- **Average BMI by Age Group**:
  ```sql
  SELECT age_group, AVG(BMI) AS avg_bmi
  FROM fact_diabetes
  JOIN dim_person ON fact_diabetes.person_key = dim_person.person_key
  GROUP BY age_group;
  ```

- **Diabetes Cases by Physical Activity Level**:
  ```sql
  SELECT physical_activity_level, COUNT(*) AS total_cases
  FROM fact_diabetes
  JOIN dim_lifestyle ON fact_diabetes.lifestyle_key = dim_lifestyle.lifestyle_key
  WHERE diabetes_status = 1
  GROUP BY physical_activity_level;
  ```

---

## 3. Machine Learning Approach

### Modeling Steps
1. **Data Preparation**:
   - Features were selected and categorical variables encoded using one-hot encoding.
   - Numerical variables were normalized, and data split into training (70%) and testing (30%).

2. **Models Used**:
   - Logistic Regression
   - Random Forest
   - XGBoost
   - Neural Networks
   - k-Nearest Neighbors (k-NN)

3. **Model Evaluation Metrics**:
   - **Accuracy**: Proportion of correct predictions.
   - **Precision, Recall, F1-Score**: Performance metrics for imbalanced datasets.
   - **ROC-AUC**: Discrimination capability between classes.

### Results
#### Logistic Regression
- **Accuracy**: 97.33%
- **ROC-AUC**: 0.962
- **Insights**:
  - High precision for diabetic cases.
  - Recall for non-diabetic cases can be improved with class imbalance handling.

#### Random Forest
- **Accuracy**: 97.23%
- **ROC-AUC**: 0.965
- **Insights**:
  - Strong prediction capabilities, slightly better than logistic regression for discrimination.

### Recommendations
- Handle class imbalance using oversampling or class weighting.
- Use feature importance from Random Forest or XGBoost for feature selection in further models.

---

## 4. Key Takeaways
- **EDA** revealed strong correlations between weight, BMI, and diabetes.
- **Dimensional Modeling** enabled efficient analysis with a star schema.
- **Machine Learning** models achieved high accuracy, with Random Forest and Logistic Regression performing best.

---

## How to Run the Project
1. **Setup**:
   - Install necessary Python packages: `pandas`, `numpy`, `scikit-learn`, `xgboost`, `matplotlib`, `seaborn`.

2. **Run Analysis**:
   - Use the provided Jupyter notebooks to explore the dataset, build models, and visualize results.

3. **Database**:
   - Load the dimensional model using SQL scripts provided in `sql_scripts` directory.

---

## Acknowledgments
- **Dataset**: Includes synthetic health data for analysis.
- **Tools Used**:
  - Python: For data cleaning, visualization, and machine learning.
  - SQL: For dimensional modeling and queries.
  - Chart.js: For interactive visualizations.

---

## Contact
For questions or collaborations, please reach out at [roman@rosh.dev].
