SELECT * FROM dataset_airbnb
               ------------ AIRBNB ANALYSIS--------------

SELECT id, COUNT(id) AS id_count
FROM dataset_airbnb
GROUP BY id
HAVING COUNT(id) > 1

-- Total Guests
SELECT COUNT(*) AS Total_Guests FROM dataset_airbnb

-- Total Hotels
SELECT COUNT(DISTINCT(name)) AS Total_Hotels FROM dataset_airbnb

-- Total Hosts
SELECT COUNT(DISTINCT(host_name)) AS Total_Hosts FROM dataset_airbnb

-- Average Price
SELECT AVG(price) AS Average_price FROM dataset_airbnb

-- Average Service fee
SELECT AVG(service_fee) AS Average_service_fee FROM dataset_airbnb

-- Average number of Reviews
SELECT AVG(number_of_reviews) AS avg_reviews FROM dataset_airbnb

-- Hotels with 365 days availability
SELECT COUNT(DISTINCT(name)) AS days_365 FROM dataset_airbnb
WHERE availability_365 = 365

-- Top 10 Total Hosts who attended most guests
SELECT TOP 10 COUNT(*) AS Top_10_Total_Hosts, host_name FROM dataset_airbnb
GROUP BY host_name 
ORDER BY Top_10_Total_Hosts DESC

-- Top 10 Total Hotels whith most guests
SELECT TOP 10 COUNT(*) AS Top_10_Total_Hotels, name FROM dataset_airbnb
GROUP BY name 
ORDER BY Top_10_Total_Hotels DESC

-- Guests by Neighbourhood group
SELECT COUNT(*) AS Total, neighbourhood_group FROM dataset_airbnb
WHERE neighbourhood_group NOT IN('brookln')
GROUP BY neighbourhood_group
ORDER BY Total DESC

-- Guests by Neighbourhood
SELECT COUNT(*) AS Total, neighbourhood FROM dataset_airbnb
GROUP BY neighbourhood
ORDER BY Total DESC

-- Instant booking
SELECT COUNT(*) AS Total, instant_bookable FROM dataset_airbnb
GROUP BY instant_bookable

-- Cancellation Policy
SELECT COUNT(*) AS Total, cancellation_policy FROM dataset_airbnb
GROUP BY cancellation_policy
ORDER BY Total DESC

-- Room Type
SELECT COUNT(*) AS Total, room_type FROM dataset_airbnb
GROUP BY room_type
ORDER BY Total DESC

-- Room type with flexible cancellation policy
SELECT COUNT(*) AS Total, room_type, cancellation_policy FROM dataset_airbnb
WHERE cancellation_policy = 'Flexible'
GROUP BY room_type, cancellation_policy
ORDER BY Total DESC

-- Average price & service fee by Room type
SELECT AVG(price) AS avg_price, AVG(service_fee) AS avg_service_fee, room_type FROM dataset_airbnb
GROUP BY room_type
ORDER BY avg_price DESC, avg_service_fee DESC

-- Average price by neighbourhood group
SELECT AVG(price) AS avg_price, neighbourhood_group FROM dataset_airbnb
WHERE neighbourhood_group NOT IN('brookln')
GROUP BY neighbourhood_group
ORDER BY avg_price DESC

-- Top 10 Hotels with highest no. of Reviews
SELECT TOP 10 MAX(number_of_reviews) AS Top_10_reviews, name FROM dataset_airbnb
GROUP BY name 
ORDER BY Top_10_reviews DESC


-- Correlation between price & service fee
SELECT price, service_fee FROM dataset_airbnb
ORDER BY price DESC, service_fee DESC

-- Insights
/*Total number of guests are 60.93k, Total Hotels are 39757

There are 9816 number of hosts, Michael has attended the most guest 478, followed by Sonder 425

Number Of Hotels With 365 days Availability are 1420

Total Hotels By Neighbourhood Group: highest Manhattan 25794, however average price is highest for Bronx

Total Hotels By Neighbourhood: Bedford-Stuyvesant 4743

Only 49.7% hotels has instant booking system

33.4% hotels has moderate cancellation policy

Entire home/apartment is the most preferred choice of stay in & more flexible at cancellation

Price distribution is uniform, max price of hotel is $999, 𝑎𝑣𝑒𝑟𝑎𝑔𝑒 525

Average price of each room type: Hotel room $558, Shared room $519, Private room $523, Entire home/apt $527

Service fee is also uniformally distributed, with average of $105

With increase in hotel price, service fee also increases

Average number of reviews is 32.33, highest is for Sonder Battery Park | Studio Apartment: 1024

More cancellation flexibility should be provided for other room type & may be few discount offers if want to boost booking for other room types

365 days availability should be provide by more hotels

Price of Home rooms are high that could be the potential reason for less booking so offers should be provided to invite more guests
*/