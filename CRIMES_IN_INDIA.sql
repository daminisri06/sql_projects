CREATE DATABASE CRIME

SELECT * FROM Crimes_in_india

--1 Total Crimes in each YEAR
SELECT SUM(TOTAL) AS Total, YEAR FROM Crimes_in_india
GROUP BY YEAR
ORDER BY Total DESC

--2 Total Crimes in each STATE
SELECT SUM(TOTAL) AS Total, STATES FROM Crimes_in_india
GROUP BY STATES
ORDER BY Total DESC

--3 Total Murders in each YEAR
SELECT SUM(MURDER) AS Total, YEAR FROM Crimes_in_india
GROUP BY YEAR
ORDER BY Total DESC

--4 Total Murders in each STATE
SELECT SUM(MURDER) AS Total, STATES FROM Crimes_in_india
GROUP BY STATES
ORDER BY Total DESC

--5 Total Rape in each State
SELECT (SUM(RAPE) + SUM(OTHER_RAPE) + SUM(CUSTODIAL_RAPE)) AS TOTAL_RAPE_CASES, STATES
FROM Crimes_in_india
GROUP BY STATES
ORDER BY TOTAL_RAPE_CASES DESC

--6 Total kidnapping & abduction cases in each State
SELECT (SUM(KIDNAPPING_ABDUCTION) + SUM(KIDNAPPING_AND_ABDUCTION_OF_OTHERS) + SUM(KIDNAPPING_AND_ABDUCTION_OF_WOMEN_AND_GIRLS)) AS KIDNAPPING_ABDUCTION, STATES
FROM Crimes_in_india
GROUP BY STATES
ORDER BY KIDNAPPING_ABDUCTION DESC

--7 Total Theft cases in each State
SELECT (SUM(THEFT) + SUM(OTHER_THEFT) + SUM(AUTO_THEFT)) AS THEFT_CASES, STATES
FROM Crimes_in_india
GROUP BY STATES
ORDER BY THEFT_CASES DESC

--8 Total dowry deaths cases in each State
SELECT SUM(DOWRY_DEATHS) AS DOWRY_DEATHS, STATES
FROM Crimes_in_india
GROUP BY STATES
ORDER BY DOWRY_DEATHS DESC

--9 Total burglary cases in each State
SELECT SUM(BURGLARY) AS BURGLARY, STATES
FROM Crimes_in_india
GROUP BY STATES
ORDER BY BURGLARY DESC

--10 Total hurt greviously cases in each State
SELECT SUM(HURT_GREVIOUS_HURT) AS HURT_GREVIOUSLY, STATES
FROM Crimes_in_india
GROUP BY STATES
ORDER BY HURT_GREVIOUSLY DESC

--11 state with least amount of crimes
SELECT TOP 1 SUM(TOTAL) AS Total, STATES FROM Crimes_in_india
GROUP BY STATES
ORDER BY Total ASC

--12 crime in particular state, district and year
CREATE PROCEDURE CRIME_DETAIL(@STATE VARCHAR(50), @DISTRICT VARCHAR(50), @YEAR INT)
AS
SELECT * FROM Crimes_in_india
WHERE STATES = @STATE
AND DISTRICT = @DISTRICT
AND YEAR = @YEAR
GO

EXEC CRIME_DETAIL @STATE = 'UTTAR PRADESH', @DISTRICT = 'SITAPUR', @YEAR = 2008

--13 crimes majorily involving women in each state
SELECT (SUM(RAPE) + SUM(KIDNAPPING_AND_ABDUCTION_OF_WOMEN_AND_GIRLS) + SUM(INSULT_TO_MODESTY_OF_WOMEN) + 
SUM(ASSAULT_ON_WOMEN_WITH_INTENT_TO_OUTRAGE_HER_MODESTY) + SUM(DOWRY_DEATHS) +
SUM(CRUELTY_BY_HUSBAND_OR_HIS_RELATIVES) + SUM(IMPORTATION_OF_GIRLS_FROM_FOREIGN_COUNTRIES)) AS CRIMES_MAJORILY_INVOVLING_WOMEN, 
STATES FROM Crimes_in_india
GROUP BY STATES
ORDER BY CRIMES_MAJORILY_INVOVLING_WOMEN DESC

-- 14 year on year change in cases(murder)
SELECT STATES, YEAR, SUM(MURDER) AS TOTAL_MURDER,
LAG(SUM(MURDER)) OVER(PARTITION BY STATES ORDER BY YEAR) AS PREVIOUS_YEAR
FROM Crimes_in_india
GROUP BY STATES, YEAR
ORDER BY TOTAL_MURDER DESC
 
 -- INSIGHTS

 /*
 
Total Cases Registered 115M, constant increase from 2003 to 2013 going from 7.4M to 11.5M

Maharashtra has observed highest number of crimes

Out of total number of crimes Murder cases are 775k mostly committed in Uttar Pradesh

Deaths by Dowry also observed the most in Uttar Pradesh

Robbery cases registered mostly in Maharashtra followed by Uttar Pradesh

Burglary cases registered mostly in Maharashtra followed by Madhya Pradesh

West Bengal was highest in number of Cheating Cases

Rape cases happened in Madhya Pradesh followed by Uttar Pradesh, which also topped in Kidnapping & Abduction Cases

Theft cases committed most in Maharashtra followed by Uttar Pradesh

Cheating cases registered mostly in Rajasthan followed by Andhra Pradesh then Uttar Pradesh

Crimes against women in totality has been observed by West Bengal with Uttar Pradesh making in top 5

If take a look at overall data Maharashtra has highest cases but Uttar Pradesh is also making headline in every category.*/