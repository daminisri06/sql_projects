CREATE DATABASE EV

SELECT * FROM EV_DATA

-- Count of total vehicles

SELECT COUNT(*) AS Total_vehicles FROM EV_DATA
WHERE VIN_1_10 IS NOT NULL

-- Total Counties
SELECT COUNT(DISTINCT County) AS Distinct_Make_Count
FROM EV_DATA
WHERE VIN_1_10 IS NOT NULL

-- Vehicle in each City

SELECT COUNT(*) AS Total_per_city, City FROM EV_DATA
WHERE City IS NOT NULL
GROUP BY City
ORDER BY Total_per_city DESC

-- Vehicle in each State

SELECT COUNT(*) AS Total_per_state, State FROM EV_DATA
WHERE State is NOT NULL
GROUP BY State
ORDER BY Total_per_state DESC

-- Vehicle in each County

SELECT COUNT(*) AS Total_per_county, County FROM EV_DATA
WHERE County IS NOT NULL
GROUP BY County
ORDER BY Total_per_county DESC

-- Vehicles by year

SELECT COUNT(*) AS Total_by_year, Model_Year
FROM EV_DATA
WHERE VIN_1_10 IS NOT NULL
GROUP BY Model_Year
ORDER BY Total_by_year DESC

-- Total Distinct Make

SELECT COUNT(DISTINCT Make) AS Distinct_Make_Count
FROM EV_DATA
WHERE VIN_1_10 IS NOT NULL


-- Vehicle by Make(Company)

SELECT COUNT(*) AS Total_by_make, Make
FROM EV_DATA
WHERE VIN_1_10 IS NOT NULL
GROUP BY Make
ORDER BY Total_by_make DESC

-- Total distinct model

SELECT COUNT(DISTINCT Model) AS Distinct_Model_Count
FROM EV_DATA
WHERE Model IS NOT NULL

CREATE INDEX idx_ev_make ON EV_DATA(VIN_1_10);
CREATE NONCLUSTERED INDEX index_name
ON EV_DATA (Model);

-- Vehicle by Model

SELECT COUNT(*) AS Total_by_model, Model
FROM EV_DATA
WHERE Model IS NOT NULL
GROUP BY Model
ORDER BY Total_by_model DESC

--

SELECT DISTINCT Model, Make,
COUNT(*) OVER (PARTITION BY Model, Make) AS Total_by_model
FROM EV_DATA
WHERE Model IS NOT NULL
ORDER BY Total_by_model DESC

-- Vehicle by EV Type

SELECT COUNT(*) AS Total_by_type, Electric_Vehicle_Type
FROM EV_DATA
WHERE Electric_Vehicle_Type IS NOT NULL
GROUP BY Electric_Vehicle_Type
ORDER BY Total_by_type DESC

-- Vehicle by Clean alternative fuel

SELECT COUNT(*) AS Total_by_fuel, Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility
FROM EV_DATA
WHERE Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility IS NOT NULL
GROUP BY Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility
ORDER BY Total_by_fuel DESC

-- Vehicle with Top electric range

WITH CTE AS(
SELECT Electric_Range, Model, Make,
ROW_NUMBER() OVER(ORDER BY Electric_Range DESC) AS Range_rank
FROM EV_DATA
WHERE Model IS NOT NULL
)
SELECT Electric_Range, Model, Make FROM CTE
WHERE Range_rank = 1

-- Vehicle by Electric Utility 

SELECT COUNT(*) AS Total_by_utility, Electric_Utility
FROM EV_DATA
WHERE Electric_Utility IS NOT NULL
GROUP BY Electric_Utility
ORDER BY Total_by_utility DESC

-- Best Vehicle by Electric Utility 

SELECT COUNT(*) AS Total_by_utility, Electric_Utility, Model
FROM EV_DATA
WHERE Electric_Utility IS NOT NULL
GROUP BY Electric_Utility, Model
ORDER BY Total_by_utility DESC

-- Best Vehicle by Clean alternative fuel

SELECT COUNT(*) AS Total_by_fuel, Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility, Model
FROM EV_DATA
WHERE Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility IS NOT NULL
GROUP BY Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility, Model
ORDER BY Total_by_fuel DESC


CREATE NONCLUSTERED INDEX index_name_CAFV
ON EV_DATA (Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility);

--INSIGHTS
/**
Among 42 manufacturers, Tesla leads the market with an impressive 90,098 EVs, making it the dominant player.
Out of 152 distinct EV models, Tesla's Model Y emerges as the top choice among consumers.
King County has the highest number of EVs, totaling 105,234 vehicles.
Seattle stands out as the city with the highest EV adoption, with 33,327 vehicles.
The year 2023 recorded the highest EV registrations at 60,062 vehicles, reflecting a 100.2% increase compared to 2022.
Battery Electric Vehicles (BEVs) are more preferred over Plug-in Hybrid Electric Vehicles (PHEVs), indicating a shift towards fully electric mobility.
Tesla's Model S has the highest range at 337 miles, appealing to consumers prioritizing long-distance capabilities.
PUGET SOUND ENERGY INC and CITY OF TACOMA (WA) cater to the largest number of EVs, highlighting the importance of their infrastructure in supporting EV adoption.
Tesla’s Model Y is the most chosen vehicle among utility customers
Battery range eligibility for Clean Alternative Fuel Vehicle (CAFV) incentives remains unknown, indicating the need for further research.
Despite Tesla's dominance, there’s potential to increase competitiveness among other manufacturers.




