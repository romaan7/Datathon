---------------------------------------------------------
/***************Create Staging Tables******************/
---------------------------------------------------------

--Create a Staging Table
CREATE OR REPLACE TABLE diabetes_staging (
    id INT,
    gender VARCHAR,
    age FLOAT,
    hypertension VARCHAR,
    diabetes_pedigree_function FLOAT,
    diet_type VARCHAR,
    BMI FLOAT,
    weight FLOAT,
    family_diabetes_history VARCHAR,
    social_media_usage VARCHAR,
    physical_activity_level VARCHAR,
    sleep_duration FLOAT,
    stress_level VARCHAR,
    pregnancies FLOAT,
    alcohol_consumption VARCHAR,
    diabetes FLOAT
);

---------------------------------------------------------
/***************Create Dimension Tables******************/
---------------------------------------------------------

--Dimension: Demographics
CREATE OR REPLACE TABLE dim_demographics (
    demographic_id INT AUTOINCREMENT PRIMARY KEY,
    gender VARCHAR,
    age_group VARCHAR,
    hypertension VARCHAR
);

--Dimension: Lifestyle
CREATE OR REPLACE TABLE dim_lifestyle (
    lifestyle_id INT AUTOINCREMENT PRIMARY KEY,
    diet_type VARCHAR,
    social_media_usage VARCHAR,
    physical_activity_level VARCHAR,
    stress_level VARCHAR,
    alcohol_consumption VARCHAR
);

--Fact: Health Data
CREATE OR REPLACE TABLE fact_health_data (
    health_data_id INT AUTOINCREMENT PRIMARY KEY,
    demographic_id INT REFERENCES dim_demographics(demographic_id),
    lifestyle_id INT REFERENCES dim_lifestyle(lifestyle_id),
    BMI FLOAT,
    weight FLOAT,
    diabetes_pedigree_function FLOAT,
    sleep_duration FLOAT,
    pregnancies FLOAT,
    diabetes FLOAT
);