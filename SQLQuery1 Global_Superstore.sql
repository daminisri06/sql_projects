select * from [Global superstore]

--1 How many total orders have been placed?--
select Count(Order_ID) from [Global superstore];

--2 How many oders has been placed between 2014-06-26 to 2015-10-18?--
select Count(Order_Date) as Orders from [Global superstore]
where Order_Date Between '2014-06-26' And '2015-10-18';

--3 What are the different segments?--
select Distinct(Segment) from [Global superstore];

--4 In how many countries services are provided?--
select Count(Distinct(Country)) as total_countries from [Global superstore]

--5 What are different category and sub-category?--
select Distinct(Category) as Category from [Global superstore]
select Distinct(Sub_Category) as sub_category from [Global superstore]

--6 What is the average no of sales?--
select round(avg(Sales),0) as avg_sales from [Global superstore]

--7 Which category has the highest sales?--
select Sum(Sales) as Highest_Sales, Category from [Global superstore]
Group by Category Order by Highest_Sales DESC;

---8 Which is the highest selling product?--
select Top 1 Sum(Sales) as Highest_Sales, Sub_Category from [Global superstore]
Group by Sub_Category Order by Highest_Sales DESC;

--9 How many orders have been shipped through different mode and what is the total cost by each mode?--
select Count(Ship_Mode) as Total, Round(Sum(Shipping_Cost),0) as Total_cost, Ship_Mode from [Global superstore]
Group by Ship_Mode order by Total desc, Total_cost;

--10 Which product has ordered in highest quantity?--
select Sum(Quantity) as Highest_quanity, Sub_Category from [Global superstore]
group by Sub_Category order by Highest_quanity desc;

--11 Which is the most profitable product?--
select MAX(Profit) as Highest_Profit, Sub_Category from [Global superstore]
group by Sub_Category order by Highest_Profit desc;

--12 which category has witnessed highest loss?--
select Sum(Profit) as In_Loss, Category from [Global superstore]
where Profit < 0
group by Category order by In_Loss asc;

--13 Find category in which sales is more than 10000 and profit is more than 5000--
select Category, Sales, Profit from [Global superstore]
where Sales > 10000  and Profit > 5000;

--14 Which country has the highest sales and the lowest sales?--
select Top 3 Sum(Sales) as Total_Sale, Country from [Global superstore]
Group by Country order by Total_Sale desc ;
select Top 3 Sum(Sales) as Total_Sale, Country from [Global superstore]
Group by Country order by Total_Sale asc;

--15 On which date highest no of orders were placed?--
Select Count( Order_Date) as Number_of_Orders, Order_Date from [Global superstore]
group by Order_Date Order by Number_of_Orders desc;

--16 What are the days to ship in each country once the order is placed?--
select Distinct(Country), datediff(day,Order_Date,Ship_Date) as Days_to_ship from [Global superstore]
order by Days_to_ship desc;

--17 Which product got the higesht Discount?--
select MAX(Discount*100) as Discount, Sub_Category from [Global superstore]
Group by Sub_Category Order By Discount desc;

--18 Which region has the highest average profit?--
select avg(Profit) as Avg_Profit, Region from [Global superstore]
Group by Region Order by Avg_Profit desc;