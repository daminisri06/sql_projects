CREATE DATABASE ZOMATO

SELECT * FROM users
SELECT * FROM orders
SELECT * FROM menu
SELECT * FROM restaurant
SELECT * FROM food

--1 number of customers who order veg & non veg
SELECT COUNT(u.user_id) AS Total, f.veg_or_non_veg FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN menu m ON m.r_id = o.r_id
JOIN food f ON f.f_id = m.f_id
GROUP BY f.veg_or_non_veg

--2 customers who have never ordered
SELECT COUNT(user_id) Not_ordered From users
WHERE user_id NOT IN (SELECT user_id FROM orders)

--3 average price of each item
SELECT AVG(m.price) AS Avg_price, f.item FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN menu m ON m.r_id = o.r_id
JOIN food f ON f.f_id = m.f_id
WHERE m.price IS NOT NULL AND m.price > 10
GROUP BY f.item
ORDER BY Avg_price DESC

-- 4 Find the top restaurant in terms of number of orders from a given month
SELECT r.name, COUNT(*) AS total_orders, DATENAME(MONTH, order_date) AS order_date FROM restaurant r
JOIN orders o ON o.user_id = r.id
WHERE r.name IS NOT NULL
GROUP BY r.name, DATENAME(MONTH, order_date)
ORDER BY r.name
-- OR
SELECT r.name, COUNT(*) AS total_orders, DATENAME(MONTH, order_date) AS order_date FROM restaurant r
join orders o ON o.user_id = r.id
WHERE r.name IS NOT NULL AND DATENAME(MONTH, order_date) = 'June'
GROUP BY r.name, DATENAME(MONTH, order_date)
ORDER BY r.name

--5 restaurant with monthly sales > x 
SELECT r.name, SUM(o.sales_amount) AS Total, DATENAME(MONTH, order_date) order_date FROM restaurant r
JOIN orders o ON r.id = o.r_id
WHERE DATENAME(MONTH, order_date) = 'June' -- @month
GROUP BY r.name, DATENAME(MONTH, order_date) 
HAVING SUM(o.sales_amount) > 10000
ORDER BY Total DESC

--6 most ordered food item from each restaurant
With Fav_food AS(
SELECT COUNT(o.user_id) AS Total, f.item, r.name,
ROW_NUMBER() OVER(PARTITION BY r.id ORDER BY COUNT(o.user_id) DESC) AS RowNum
FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
JOIN food f ON f.f_id = m.f_id
GROUP BY f.item, r.name, r.id
)
SELECT item, name FROM Fav_food
WHERE RowNum = 1;

--7 top 10 highest amount generating Restaurant
SELECT TOP 10 SUM(o.user_id) AS Total_Sales, r.name FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
GROUP BY r.name
ORDER BY Total_Sales DESC

--8 most preferred cuisines
SELECT TOP 10 COUNT(o.user_id) AS Total, m.cuisine FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
WHERE m.cuisine IS NOT NULL
GROUP BY m.cuisine
ORDER BY Total DESC
-- grouping
SELECT
CUISINE, COUNT(user_id) AS Total FROM (
SELECT
CASE 
WHEN m.cuisine IN ('North Indian,Chinese', 'Chinese,Indian', 'Indian,Chinese', 'Chinese,North Indian') THEN 'Chinese Indian'
WHEN m.cuisine IN ('North Indian', 'South Indian,North Indian', 'North Indian,South Indian') THEN 'North Indian'
WHEN m.cuisine IN ('South Indian,North Indian', 'North Indian,South Indian') THEN 'Chinese'
WHEN m.cuisine IN ('Chinese') THEN 'NorthIndian'
ELSE 'Pizza' 
END AS CUISINE, o.user_id FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
WHERE m.cuisine IS NOT NULL
) AS CuisineOrders
GROUP BY CUISINE
ORDER BY Total DESC

--9 total order by cities
SELECT COUNT(o.user_id) AS Total, r.city FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
GROUP BY r.city
ORDER BY Total DESC

--10 average rating of each restaurant
SELECT ROUND(AVG(rating),2) AS Avg_rating, name FROM restaurant
WHERE rating IS NOT NULL
GROUP BY name
ORDER BY Avg_rating DESC

--11 item ordered in max qty by each restaurant 
With Fav_food AS(
SELECT MAX(o.sales_qty) AS Highest_qty, f.item, r.name,
ROW_NUMBER() OVER(PARTITION BY r.id ORDER BY MAX(o.user_id) DESC) AS RowNum
FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
JOIN food f ON f.f_id = m.f_id
GROUP BY f.item, r.name, r.id
)
SELECT item, name, Highest_qty FROM Fav_food
WHERE RowNum = 1
ORDER BY Highest_qty DESC