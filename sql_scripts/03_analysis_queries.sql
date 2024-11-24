---------------------------------------------------------
/****************Analysis Queries***********************/
---------------------------------------------------------

/*1.Prevalence of Diabetes by Age Group*/
SELECT 
    dd.age_group,
    COUNT(fhd.diabetes) AS diabetes_cases,
    COUNT(*) AS total_cases,
    ROUND(COUNT(fhd.diabetes) * 100.0 / COUNT(*), 2) AS diabetes_percentage
FROM fact_health_data fhd
JOIN dim_demographics dd ON fhd.demographic_id = dd.demographic_id
GROUP BY dd.age_group
ORDER BY diabetes_percentage DESC;


/*BMI and Diabetes Correlation*/
SELECT 
    ROUND(BMI, 1) AS bmi_range,
    COUNT(*) AS total_count,
    COUNT(CASE WHEN diabetes = 1 THEN 1 ELSE NULL END) AS diabetes_count,
    ROUND(COUNT(CASE WHEN diabetes = 1 THEN 1 ELSE NULL END) * 100.0 / COUNT(*), 2) AS diabetes_percentage
FROM fact_health_data
GROUP BY ROUND(BMI, 1)
ORDER BY bmi_range;


/*Impact of Physical Activity on Diabetes*/
SELECT 
    dl.physical_activity_level,
    COUNT(fhd.diabetes) AS diabetes_cases,
    COUNT(*) AS total_cases,
    ROUND(COUNT(fhd.diabetes) * 100.0 / COUNT(*), 2) AS diabetes_percentage
FROM fact_health_data fhd
JOIN dim_lifestyle dl ON fhd.lifestyle_id = dl.lifestyle_id
GROUP BY dl.physical_activity_level
ORDER BY diabetes_percentage DESC;


/*Diabetes Outcome Distribution*/
SELECT 
    DIABETES,
    COUNT(*) AS COUNT,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS PERCENTAGE
FROM FACT_DIABETES
GROUP BY DIABETES;

/*Average Health Metrics by Diabetes Status*/
SELECT 
    f.DIABETES,
    AVG(h.BMI) AS AVG_BMI,
    AVG(h.WEIGHT) AS AVG_WEIGHT,
    AVG(h.DIABETES_PEDIGREE_FUNCTION) AS AVG_DIABETES_PEDIGREE_FUNCTION
FROM FACT_DIABETES f
JOIN DIM_HEALTH_METRICS h ON f.HEALTH_METRIC_ID = h.HEALTH_METRIC_ID
GROUP BY f.DIABETES;


/*Lifestyle Factors and Diabetes Link*/
SELECT 
    l.DIET_TYPE,
    l.PHYSICAL_ACTIVITY_LEVEL,
    l.ALCOHOL_CONSUMPTION,
    f.DIABETES,
    COUNT(*) AS COUNT
FROM FACT_DIABETES f
JOIN DIM_LIFESTYLE l ON f.LIFESTYLE_ID = l.LIFESTYLE_ID
GROUP BY l.DIET_TYPE, l.PHYSICAL_ACTIVITY_LEVEL, l.ALCOHOL_CONSUMPTION, f.DIABETES
ORDER BY COUNT DESC;

/*Gender and Age Group Distribution by Diabetes*/
SELECT 
    p.GENDER,
    CASE 
        WHEN p.AGE < 20 THEN 'Under 20'
        WHEN p.AGE BETWEEN 20 AND 39 THEN '20-39'
        WHEN p.AGE BETWEEN 40 AND 59 THEN '40-59'
        ELSE '60 and above'
    END AS AGE_GROUP,
    f.DIABETES,
    COUNT(*) AS COUNT
FROM FACT_DIABETES f
JOIN DIM_PERSON p ON f.PERSON_ID = p.PERSON_ID
GROUP BY p.GENDER, 
         CASE 
             WHEN p.AGE < 20 THEN 'Under 20'
             WHEN p.AGE BETWEEN 20 AND 39 THEN '20-39'
             WHEN p.AGE BETWEEN 40 AND 59 THEN '40-59'
             ELSE '60 and above'
         END,
         f.DIABETES
ORDER BY AGE_GROUP, GENDER;

/*Hypertension and Diabetes*/
SELECT 
    h.HYPERTENSION,
    f.DIABETES,
    COUNT(*) AS COUNT
FROM FACT_DIABETES f
JOIN DIM_HEALTH_METRICS h ON f.HEALTH_METRIC_ID = h.HEALTH_METRIC_ID
GROUP BY h.HYPERTENSION, f.DIABETES
ORDER BY COUNT DESC;

/*Physical Activity and Diabetes*/
SELECT 
    l.PHYSICAL_ACTIVITY_LEVEL,
    f.DIABETES,
    COUNT(*) AS COUNT
FROM FACT_DIABETES f
JOIN DIM_LIFESTYLE l ON f.LIFESTYLE_ID = l.LIFESTYLE_ID
GROUP BY l.PHYSICAL_ACTIVITY_LEVEL, f.DIABETES
ORDER BY COUNT DESC;

/*Sleep Duration and Diabetes*/
SELECT 
    f.DIABETES,
    ROUND(AVG(l.SLEEP_DURATION), 2) AS AVG_SLEEP_DURATION
FROM FACT_DIABETES f
JOIN DIM_LIFESTYLE l ON f.LIFESTYLE_ID = l.LIFESTYLE_ID
GROUP BY f.DIABETES;

/*Contributing Factors to Diabetes*/
SELECT 
    l.DIET_TYPE,
    l.PHYSICAL_ACTIVITY_LEVEL,
    l.STRESS_LEVEL,
    COUNT(*) AS DIABETES_COUNT
FROM FACT_DIABETES f
JOIN DIM_LIFESTYLE l ON f.LIFESTYLE_ID = l.LIFESTYLE_ID
WHERE f.DIABETES = 1
GROUP BY l.DIET_TYPE, l.PHYSICAL_ACTIVITY_LEVEL, l.STRESS_LEVEL
ORDER BY DIABETES_COUNT DESC
LIMIT 10;

/*Summary Table*/
SELECT 
    (SELECT COUNT(*) FROM FACT_DIABETES) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM DIM_PERSON) AS TOTAL_PERSONS,
    (SELECT COUNT(*) FROM DIM_LIFESTYLE) AS TOTAL_LIFESTYLES,
    (SELECT COUNT(*) FROM DIM_HEALTH_METRICS) AS TOTAL_HEALTH_METRICS;
