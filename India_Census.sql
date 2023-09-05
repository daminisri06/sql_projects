Select * from Census_2011;

--1. What are total number of States in Table?--

Select Distinct(State_name) from Census_2011

--2. What is the count of number of District in each State?--

Select Count(District_name) as District, State_name from Census_2011
Group by State_name Order by District desc;

--3. What are the top 3 States having highest number of Population--
Select Top 3 Sum(Population) as Total_Population, State_name from Census_2011
Group by State_name Order by Total_Population desc;

--4. What are the top 3 States having least number of Population--

Select Top 3 Sum(Population) as Total_Population, State_name from Census_2011
Group by State_name Order by Total_Population;

--5. Which District in Uttar Pradesh has highest Population?--

Select max(Population) as pop, District_name from Census_2011
where State_Name = 'Uttar Pradesh'
Group by District_name order by pop desc; 

--6. What is the total Male Population in Maharastra?--

Select Sum(Male) as total_male from Census_2011
where State_Name = 'Maharashtra'

--7. Which State has highest no. of Household workers?

Select Top 1 Sum(Household_Workers) as Total_Household, State_name from Census_2011
Group by State_name Order by Total_Household desc;

--8. Find Total Population of each Religion.-- 

Select Sum(Hindus) as Total_Hindus, Sum(Muslims) as Total_Muslims,
Sum(Christians) as Total_Christians, Sum(Sikhs) as Total_Sikhs,
Sum(Buddhists) as Total_Buddhists, Sum(Jains) as Total_Jains from Census_2011

--9. Find Total Population of each Religion in Punjab-- 

Select Sum(Hindus) as Total_Hindus, Sum(Muslims) as Total_Muslims,
Sum(Christians) as Total_Christians, Sum(Sikhs) as Total_Sikhs,
Sum(Buddhists) as Total_Buddhists, Sum(Jains) as Total_Jains from Census_2011
where State_name = 'Punjab'

--10. What no. of people in each district who completed Higher Education didn't pursue Graduation?--

Select Sum(Higher_Education - Graduate_Education) as Graduation_not_pursued, District_name from Census_2011
Group by District_name Order by Graduation_not_pursued desc;

--11. Find States where Female population is more than Male--

Select State_name, Sum(Male) as Male, Sum(Female) as Female from Census_2011
where Male < Female
Group by State_name order by Female desc;

--12. Which State has Highest no of literates?

Select Top 1 Sum(Literate) as Literate, State_name from Census_2011
Group by State_name Order by Literate desc;


