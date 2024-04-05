Select * from accident
Select * from vehicle

---1 How many accidents have occured in urban area vs rural?
Select count(AccidentIndex) as total_accidents, Area from accident
Group by Area

---2 Which day of week has highest accidents?
Select top 1 count(AccidentIndex) as total_accidents, Day from accident
Group by Day
Order by total_accidents desc
  
---3 What is the average age vehicle involved in accident based on thier type?
Select count(AccidentIndex) as total_accidents, avg(AgeVehicle) as avg_age, VehicleType
from vehicle
where AgeVehicle is not null
Group by VehicleType
Order by total_accidents desc

---4 Can we identify any trend in accidents based on age of vehicle?
Select AgeGroup, 
count(AccidentIndex) total_accidents, 
avg(AgeVehicle) as avg_age
from (
       Select AccidentIndex, AgeVehicle,
       case
	     when AgeVehicle between 0 and 5 then 'New'
	     when AgeVehicle between 5 and 7 then 'Regular'
	     else 'Old'
		 end as 'AgeGroup'
		 from vehicle
) a
where AgeVehicle is not null
Group by AgeGroup
Order by total_accidents desc

---5 Are there any specific weather conditions that contribute to accidents?

Select count(AccidentIndex) as total_accidents, WeatherConditions, Severity from accident
Group by WeatherConditions, Severity
Order by total_accidents desc

---6 Do accidents often involve impacts on the left-hand side of the vehicle?
select count(AccidentIndex) as total_accidents, LeftHand
from vehicle
where LeftHand is not null
Group by LeftHand

---7 Is there any relationship between journey purpose and severity?
Select count(a.Severity) total_severity, v.JourneyPurpose , a.Severity
from accident a
Join vehicle v on a.AccidentIndex = v.AccidentIndex
Group by v.JourneyPurpose, a.Severity
Order by total_severity desc

---8 Calculate the average age of the vehicles involved in accidents, daylight and point impact
select avg(v.AgeVehicle) as avg_age, v.PointImpact, a.LightConditions
from vehicle v
Join accident a on a.AccidentIndex = v.AccidentIndex
where a.LightConditions = 'Daylight'
Group by v.PointImpact, a.LightConditions
Order by avg_age desc

---9 Which vehicle has the third highest number of accidents?
with cte as(
       Select VehicleType, count(AccidentIndex) as accidents,
	   Rank() over (order by count(AccidentIndex) desc) third_highest
	   from vehicle
	   Group by VehicleType) 

Select VehicleType, accidents
from cte
where third_highest = 3

---10 Is there any impact of road conditions on accidents and which vehicle type has suffered the most from it?
Select count(a.Severity) as severity, a.RoadConditions, v.VehicleType
from accident a
Join vehicle v on a.AccidentIndex = v.AccidentIndex
Group by RoadConditions, v.VehicleType
Order by severity desc

---11 In which month highest number of accidents happened?
Select
datename(MONTH, Date) AS Month_name, count(*) AS AccidentCount
from accident
group by
datename(MONTH, Date)
order by Month_name desc

-- INSIGHTS

-- urban are has more accidents than rural with friday the most accident recorded day
-- cars have been involved the most, followed by Van even on the fine day no high winds
-- there's not enough data but what we have from that we can conclude that Journey as part of work had most casualties
-- in day light accidents have occured frequently, wet & damp roads have the most impact on accidents
-- september to october has more accidents as compare to others
