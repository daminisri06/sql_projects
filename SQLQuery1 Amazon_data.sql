select * from Amazon_data;

--1 What are the total no of orders placed?--
select Count(Order_ID) as Total_Orders from Amazon_data;

--2 What is the total amount generated?
select Sum(Amount) as Total_Amount from Amazon_data;

--3 What is total quantity of all the orders?
select Sum(Qty) as Total_Qty from Amazon_data;

--4 Which month has highest no of orders?--
select DateName(Month,Date) as "Month", Count(Date) as No_of_orders from Amazon_data
group by DateName(Month,Date) Order by No_of_orders desc;

--5 How many orders delivered to buyers?--
select Count(Status) "Count", Status from Amazon_data
where Status = 'Shipped - Delivered to Buyer'
Group by Status

--6 What is count of different Status?--
select Count(Status) as "Count", Status from Amazon_data
group by Status order by "Count" desc;

--7 What are the different sales channel and orders placed through them?--
select Count(Sales_Channel) as Total, Sales_Channel from Amazon_data
Group by Sales_Channel 

--8 How many product shipped and fulfilled by amazon?--
select Count(Status) as Product_Shipped from Amazon_data
where Status = 'Shipped' and Fulfilment = 'Amazon'

--9 Which product has sold in highest quantity and generated highest amount?--
select Sum(Qty) as Total, Sum(Amount) as Total_Amount, Category from Amazon_data
group by Category order by Total desc, Total_Amount;

--10 Which state placed highest order?--
select Top 1 Count(Order_ID) as Total, ship_state from Amazon_data
Group by ship_state order by Total desc;

--11 Which size ordered the most from different categories?--
select Count(Size) as Most_Orderd_Size, Size, Category from Amazon_data
group by Size, Category Order by Most_Orderd_Size desc;

--12 How many orders has been unshipped in each sate?--
select Count(Courier_Status) as Unshipped, ship_state from Amazon_data
where Courier_Status = 'Unshipped'
group by ship_state order by Unshipped desc;

--13 Which categories have generated amount more than 1000000?--
select Sum(Amount) as Total, Category from Amazon_data
group by Category
having Sum(Amount) > 1000000

--14 On which date highest quantity was ordered?--
select Top 1 MAX(Qty) as Qty, Date from Amazon_data
Group by Date Order by Qty desc;
