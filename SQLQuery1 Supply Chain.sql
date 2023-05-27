Use supply_chain;

select * from Products;
select * from Shipping;


--1 What are the different product types?
select distinct(Product_type) from Products;

--2 What are the total count of all the different products?
select Count(Product_Type) as "Count", Product_Type from Products
Group by Product_Type Order by "Count" DESC;

--3 Which product generated the highest revenue?
select Sum(Revenue_generated) as Highest_Revenue, Product_Type from Products
Group by Product_Type Order by Highest_Revenue DESC;

--4 Which customer demographic has highest sales?
select Sum(Products_sold) AS sold, Customer_demographics  from Products
group by Customer_demographics Order by sold desc;

--5 What is the average revenue?
select round(avg(Revenue_generated),0)from Products;

--6 Find Products where revenue is more than average revenue.
select Product_ID, Product_Type, Revenue_generated from Products
where Revenue_generated > (select (avg(Revenue_generated))from Products);

--7 define product sold in category of low,high & very low.
select Product_ID, Product_Type, Products_sold,
CASE 
WHEN Products_sold >= 700 THEN 'High'
WHEN Products_sold <= 700 and Products_sold >= 400 THEN 'Low'
ELSE 'Very Low'
END as Status
from Products
go

--8 Which Location has the highest sales?
select TOP 1 Sum(Products_sold) as "Total", Location from Products
Group by Location Order by "Total" DESC;


--9 Which product is sold highest by Kolkata?
select Count(Product_Type) as Product, Product_Type from Products
Where Location = 'Kolkata'
Group by Product_Type Order by Product desc;

--10 how many inspection results are pending?
select Count(Inspection_results) as Pending from Products
where Inspection_results = 'Pending'

--11 find top 2 highest cost and 2 lowest cost locations
drop table if exists highest_cost
create table highest_cost
(State nvarchar(255),
 highest_cost float
 )
 insert into highest_cost
select Location, round(Sum(Costs),0) As Total from Products
group by Location order by Total DESC;

select top 2 * from highest_cost order by highest_cost desc;

drop table if exists lowest_cost
create table lowest_cost
(State nvarchar(255),
 lowest_cost float
 )
 insert into lowest_cost
select Location, round(Sum(Costs),0) As Average_Pop from Products
group by Location order by Average_Pop Asc;

select top 2 * from lowest_cost order by lowest_cost asc;

--12 Whichis the most preferred mode of transportation?
select Count(Transportation_modes) as Top_mode , Transportation_modes from Shipping
group by Transportation_modes order by Top_mode desc;

--13 find total shipping cost of each shipping carrier. 
select Sum(Shipping_costs) as Total, Shipping_carriers from Shipping
Group by Shipping_carriers

--14 what are the different mode of transportation used for each loaction
select p.Product_ID, p.Location,s.Transportation_modes,s.Shipping_carriers from Products as p
join Shipping as s
on p.Product_ID = s.Product_ID

--15 What are the locations where shipping cost is more than $8?
select p.Product_ID, p.Location,s.Transportation_modes,round(s.Shipping_costs,0) as shipping_costs from Products as p
join Shipping as s
on p.Product_ID = s.Product_ID
where Shipping_costs > 8

--16 What is ther total cost spent by each product?
select p.Product_ID, p.Product_Type, round(p.Costs,0) as product_cost, round(s.Shipping_costs,0) as shipping_costs 
, round(p.Costs,0) - round(s.Shipping_costs,0) as Total_Cost
from Products as p
join Shipping as s
on p.Product_ID = s.Product_ID

select p.Product_ID, p.Product_Type, round(p.Costs,0) as product_cost, round(s.Shipping_costs,0) as shipping_costs 
, round(p.Costs,0) + round(s.Shipping_costs,0) as Total_Cost
from Products as p
join Shipping as s
on p.Product_ID = s.Product_ID

--17 What are the top 10 products having highest production volume with less defect rates?
select top 10 Product_ID, Product_Type, Production_volumes, round(Defect_rates,2) as Defect_rates from Products
where Production_volumes > 700 and Defect_rates < 2
