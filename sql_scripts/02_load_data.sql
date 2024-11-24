---------------------------------------------------------
/***************Load CSV File from github****************/
---------------------------------------------------------

--Load Data into Staging Table
COPY INTO diabetes_staging
FROM 'https://raw.githubusercontent.com/romaan7/Datathon/refs/heads/main/analysis/cleaned_diabetes_data.csv'
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);




---------------------------------------------------------
/*****ETL Logic: Populate Dimension and Fact Tables*****/
---------------------------------------------------------

-- Insert into Demographics Dimension
INSERT INTO dim_demographics (gender, age_group, hypertension)
SELECT 
    gender,
    CASE 
        WHEN age < 18 THEN 'Child'
        WHEN age BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN age BETWEEN 36 AND 55 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS age_group,
    hypertension
FROM diabetes_staging
GROUP BY gender, age_group, hypertension;

-- Insert into Lifestyle Dimension
INSERT INTO dim_lifestyle (diet_type, social_media_usage, physical_activity_level, stress_level, alcohol_consumption)
SELECT 
    diet_type,
    social_media_usage,
    physical_activity_level,
    stress_level,
    alcohol_consumption
FROM diabetes_staging
GROUP BY diet_type, social_media_usage, physical_activity_level, stress_level, alcohol_consumption;

-- Insert into Fact Table
INSERT INTO fact_health_data (demographic_id, lifestyle_id, BMI, weight, diabetes_pedigree_function, sleep_duration, pregnancies, diabetes)
SELECT 
    (SELECT demographic_id FROM dim_demographics WHERE gender = ds.gender AND hypertension = ds.hypertension),
    (SELECT lifestyle_id FROM dim_lifestyle WHERE diet_type = ds.diet_type AND stress_level = ds.stress_level),
    BMI,
    weight,
    diabetes_pedigree_function,
    sleep_duration,
    pregnancies,
    diabetes
FROM diabetes_staging AS ds;
