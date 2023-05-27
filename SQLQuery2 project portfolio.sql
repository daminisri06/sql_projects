--USA and India population detail

           --India--

select * from Data1;
select * from Data2;

--1 what is the average growth?
select avg(Growth)*100 As Avg_Growth from Data1;

--2 Find dataset just for Jharkhand and Bihar.
select * from Data1 where State in ('Jharkhand','Bihar')

--3 what is the total population of India?
select sum(Population) as Total_Population from Data2

--4 what is the count of state where sex ratio is less than 90?
select state, Count(*) as count
from Data1
where Sex_Ratio < 1000 and Literacy <80
Group by State
order by count desc;

--5 combine top 3 states of two tables.
select * from (
select top 3 * from top_states order by top_states desc) a
union
select * from (
select top 3 * from bottom_states order by bottom_states asc) b;

--6 what is the avg growth percentage by states in descending order?
select State, round(avg(Growth)*100,0) As Avg_Growth from Data1
group by State order by Avg_Growth desc;

--find all the distinct states
select distinct(State) from Data1

--7 find avg sex ratio.
select State, avg(Sex_Ratio) As Average from Data1
group by State order by Average DESC;

--8 find states in different category where sex ratio is less than and more than 1000
select * from Data1
 
select *,
case
when Sex_Ratio < 1000 then 'less'
when Sex_Ratio > 1000 then 'more'
Else 'Balance'
End AS status
from Data1
go

--9 what is the average literacy rate?
select State, round(avg(Literacy),0) As Average_literacy from Data1
group by State having round(avg(Literacy),0) > 90 order by Average_literacy DESC;

--10 what are the top 3 states showing highest growth ratio?
select top 3 State, avg(Growth)*100 As Avg_Growth from Data1
group by State order by Avg_growth desc;

--11 what are the bottom 3 states showing highest growth ratio?
select top 3 State, avg(Growth)*100 As Avg_Growth from Data1
group by State order by Avg_growth asc;

--12 which state starts with letter A or ends with H?
select distinct(state) from Data1 where State LIKE 'A%' or (State) LIKE 'B%'

--13 which state starts with letter A and ends with H?
select distinct(state) from Data1 where State LIKE 'A%' and (State) LIKE '%H'
select distinct(state) from Data1 where State LIKE 'A%H'

--14 find all the distinct states
select distinct(State) from Data1

--15 find districts starting with a,e,i,o,u
select District from Data2
where District Like 'a%' or District Like 'e%' or District Like 'i%' or District Like 'o%' or District Like 'u%'

--16 find total number of districts in each state.
select State,count(*) as total_District from Data1
group by State order by total_District desc;

--17 find states, sexratio and population in one table.
select c.District, c.State, c.sex_ratio, b.Population
from Data1 as c
inner join Data2 as b
on c.District = b.District
Order by b.Population desc; 

--18 find states, sexratio, area and population in one table.
select c.District, c.State, c.sex_ratio, b.Population, b.Area_km2
from Data1 as c
inner join Data2 as b
on c.District = b.District
Order by b.Area_km2 desc; 

--19 add 100 to sex_ratio where state is west bengal
Update Data1 set Sex_Ratio = Sex_Ratio+100 from Data1 as c
Join Data2 as b
On c.District = b.District
where c.State = 'West Bengal'

--20 Find top 3 District from each state with highest literacy rate

select a.* from
(select District,State,Literacy, Rank() Over(Order by Literacy desc) as "Rank" from Data1) a
where a.Rank in(1,2,3)

                  --USA--

select * from Population
select * from Gender
select * from Literacy
select * from [Employment Rate]

--1 what is the avg density of all states?
select round(avg(Density),0) as AvgDensity from Population

--2 what are the top 3 states with highest population?
select top 3 StatePopulation, State from Population
Order by StatePopulation desc

--3 find states arranged according to length of letters
select State from [Employment Rate]
order by LEN(State) 

--4 find state with highest lietracy rate
select top 1 state, MAX(LiteracyRateInPercent) as highest_literacy_rate from Literacy
group by state order by highest_literacy_rate desc;

--5 how many states are there where civilian labor force is less than 1905529?
select COUNT(Civilian_Labor_Force) as Total_Count FROM [Employment Rate]
Where Civilian_Labor_Force < 1905529

--6 find state, population,density,sex_ratio and growth in one table.
select p.State, p.Density, p.StatePopulation, g.Growth, g.Sex_Ratio
from Population as p
inner join Gender as g
on p.State = g.State
Order by p.StatePopulation desc; 

--7 Find literacy rate,employment rate with density and growth.
select Literacy.State, Literacy.LiteracyRateInPercent, Population.Density, Gender.Growth, [Employment Rate].EmploymentRateInPercent
from Literacy
join Population on Literacy.State=Population.State
join Gender on Population.State=Gender.State
join [Employment Rate] on Gender.State=[Employment Rate].State
order by Population.Density desc;

--8 Find state civilian labor force where population is than 300000.
select p.State, p.StatePopulation, e.Civilian_Labor_Force
from Population as p
inner join [Employment Rate] as e
on p.State = e.State
where p.StatePopulation<3000000

--9 create stored procedure with parameter for states in population table
Create procedure USA_population @State
varchar(20)
as
select * from Population
where State = @State
go
exec USA_population @State = 'Mississippi'

--10 state with highest bachelor's degree
select Top 1 Bachelor_s_DegreeInPercent as Highest, State from Literacy
Order by Bachelor_s_DegreeInPercent desc;

--11 find states where growth rate is in negative value
select * from Gender
where Growth < 0
Order by Growth desc;

--12 update data state population t0 1000000 where state is alabama
begin transaction
update Population set StatePopulation = 1000000
where State = 'Alabama'

select * from Population

rollback transaction --or commit transaction for permanent change

--13 combine all table in one table
select Literacy.State,Literacy.LiteracyRateInPercent,Literacy.Bachelor_s_DegreeInPercent,Literacy.IlliteracyRateInPercent,Literacy.NumeracyRateInPercent,
Population.Density,Population.StatePopulation,
Gender.Growth,Gender.Sex_Ratio, 
[Employment Rate].EmploymentRateInPercent,[Employment Rate].Civilian_Labor_Force
from Literacy
join Population on Literacy.State=Population.State
join Gender on Population.State=Gender.State
join [Employment Rate] on Gender.State=[Employment Rate].State;

--14 find average of numeracy of all state
Select round(Avg(NumeracyRateInPercent),0) as Average from Literacy

--15 assign result as good/bad based on lieracy rate and illiteracy rate
select round(LiteracyRateInPercent,0),round(illiteracyRateInPercent,0),
iif( round(LiteracyRateInPercent,0)>round(illiteracyRateInPercent,0),'good','bad') as result
from Literacy


--16 what are the top and bottom 3 states with respect to avg rate?
drop table if exists highest_density
create table highest_density
(State nvarchar(255),
 highest_density float
 )
 insert into highest_density
select State, round(avg(Density),0) As Average_Pop from Population
group by State order by Average_Pop DESC;

select top 3 * from highest_density order by highest_density desc;

drop table if exists lowest_density
create table lowest_density
(State nvarchar(255),
 lowest_density float
 )
 insert into lowest_density
select State, round(avg(Density),0) As Average_Pop from Population
group by State order by Average_Pop Asc;

select top 3 * from lowest_density order by lowest_density asc;
select * from Population

--17 which state starts with vowel?
select distinct(state) from Literacy where State LIKE 'a%' or State Like 'e%' or State Like 'i%' or State Like 'o%' or State Like 'u%'

