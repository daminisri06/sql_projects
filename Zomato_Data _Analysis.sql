CREATE DATABASE ZOMATO

SELECT * FROM users
SELECT * FROM orders
SELECT * FROM menu
SELECT * FROM restaurant
SELECT * FROM food

-- Total Customers
SELECT COUNT(*) AS Total FROM users

--1 number of customers who order veg & non veg
SELECT COUNT(o.user_id) AS Total, f.veg_or_non_veg FROM users u
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

--4 Find the top restaurant in terms of number of orders
SELECT r.name, COUNT(o.user_id) AS total_orders FROM restaurant r
JOIN orders o ON o.r_id = r.id
WHERE r.name IS NOT NULL
GROUP BY r.name
ORDER BY total_orders desc

-- 5 Find the top restaurant in terms of number of orders from a given month
SELECT r.name, COUNT(o.user_id) AS total_orders, DATENAME(MONTH, order_date) AS order_date FROM restaurant r
JOIN orders o ON o.user_id = r.id
WHERE r.name IS NOT NULL
GROUP BY r.name, DATENAME(MONTH, order_date)
ORDER BY total_orders desc
-- OR
SELECT r.name, COUNT(*) AS total_orders, DATENAME(MONTH, order_date) AS order_date FROM restaurant r
join orders o ON o.user_id = r.id
WHERE r.name IS NOT NULL AND DATENAME(MONTH, order_date) = 'June'
GROUP BY r.name, DATENAME(MONTH, order_date)
ORDER BY r.name

--6 restaurant with monthly sales > x 
SELECT r.name, SUM(o.sales_amount) AS Total, DATENAME(MONTH, order_date) order_date FROM restaurant r
JOIN orders o ON r.id = o.r_id
WHERE DATENAME(MONTH, order_date) = 'June' -- @month
GROUP BY r.name, DATENAME(MONTH, order_date) 
HAVING SUM(o.sales_amount) > 10000
ORDER BY Total DESC

--7 most ordered food item from each restaurant
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

--8 top 10 highest amount generating Restaurant
SELECT TOP 10 SUM(o.(o.sales_amount) AS Total_Sales, r.name FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
GROUP BY r.name
ORDER BY Total_Sales DESC

--9 top 10 highest amount generating Food
SELECT TOP 10 SUM(o.(o.sales_amount) AS Total_Sales, f.item FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
JOIN food f ON f.f_id = m.f_id
GROUP BY f.item
ORDER BY Total_Sales DESC

--10 most preferred cuisines
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

--11 total order by cities
SELECT COUNT(o.user_id) AS Total, r.city FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
GROUP BY r.city
ORDER BY Total DESC
 
--12 average rating of each restaurant
SELECT ROUND(AVG(rating),2) AS Avg_rating, name FROM restaurant
WHERE rating IS NOT NULL
GROUP BY name
ORDER BY Avg_rating DESC

--13 Maximum orders placed by highest rated restaurants
SELECT r.name, r.rating, MAX(o.user_id) AS Max_order FROM restaurant r
JOIN orders o ON o.r_id = r.id
JOIN users u ON u.user_id = o.user_id
WHERE rating IS NOT NULL AND r.rating = 5
GROUP BY r.name, r.rating
ORDER BY Max_order DESC

--14 Who has been placing orders most in terms of occupation
SELECT COUNT(*) AS Total_Orders, Occupation
FROM users
GROUP BY Occupation
ORDER BY Total_Orders DESC

--15 item ordered in max qty by each restaurant 
With Fav_food AS(
SELECT MAX(o.sales_qty) AS Highest_qty, f.item, r.name,
ROW_NUMBER() OVER(PARTITION BY r.id ORDER BY MAX(o.sales_qty) DESC) AS RowNum
FROM orders o 
JOIN menu m ON m.r_id = o.r_id
JOIN restaurant r ON r.id = m.r_id
JOIN food f ON f.f_id = m.f_id
GROUP BY f.item, r.name, r.id
)
SELECT item, name, Highest_qty FROM Fav_food
WHERE RowNum = 1
ORDER BY Highest_qty DESC

-- 16 month-over-month growth in active users for each city.
WITH MonthlyUsers AS (
SELECT r.city, FORMAT(o.order_date, 'yyyy-MM') AS YearMonth,
COUNT(DISTINCT o.user_id) AS ActiveUsers
FROM orders o
JOIN restaurant r ON r.id = o.r_id
GROUP BY r.city, FORMAT(o.order_date, 'yyyy-MM')
),
MOM AS (
SELECT city, YearMonth, ActiveUsers,
LAG(ActiveUsers) OVER (PARTITION BY city ORDER BY YearMonth) AS PrevMonthUsers
FROM MonthlyUsers
)
SELECT city, YearMonth, ActiveUsers, PrevMonthUsers,
CASE 
WHEN PrevMonthUsers IS NULL THEN NULL
ELSE ROUND(((ActiveUsers - PrevMonthUsers) * 100.0) / PrevMonthUsers, 2)
END AS MoMUserGrowthPercent
FROM MOM
ORDER BY city, YearMonth; 

-- INSIGHTS

--- Total customers 100000 out of which 22071 user have made account on zomato but haven't place any order yet,
/* the priciest items on the menu are the one which comes in package for 10 or more people, 
cakes which are about a 1 kg, or large box meals and combos*/
--- domino's top the list of restaurants, they do have the big chain of restaurant but highest amount is generated by Subway followed by Domino's
/* north india food is most favourite choice, and if food is vegetarian it is more preferred but if
talk about quantity, veg hakka noodle is been ordered in bulk, and the dish that generated highest amount is Jeera Rice*/
--- Ahemdabad is ordering food from zomato the most
--- Highest rated restaurants with highest number of orders is MY KEBAB BITE
--- Veg is most preferred choice
-- students are placing more orders as compare to employed

-- Suggestions

-- Sell more about Zomato to customers who still haven't placed any orders through promotions, personalizede emails, extra discounts on 1st order
-- Big packaged orders with special discounts on festive occassions
-- Collaborating with big food chains for more deal & highlighting on app more
-- Food combos with reasonal prices could also be a good strategy
-- Collaborating more with restuarants which are nearby College Campuses for group orders & late night orders
-- Recommending best food of each resturant on top of the menu
-- Providing memberships to frequent customers with extra discounts, free delivery

CREATE INDEX idx_orders_r_id ON orders (r_id);
CREATE INDEX idx_menu_r_id ON menu (r_id);
CREATE INDEX idx_users_user_id ON users (user_id);
CREATE INDEX idx_restaurant_id ON restaurant (id);
CREATE INDEX idx_food_f_id ON food (f_id);
CREATE INDEX idx_menu_f_id ON menu (f_id);

