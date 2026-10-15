CREATE DATABASE restaurant_analytics;
USE restaurant_analytics;

-- RESTAURANTS
SELECT * FROM restaurants LIMIT 10;
SHOW COLUMNS FROM restaurants;
SELECT COUNT(*) AS total_restaurants
FROM restaurants;

-- ORDERS
SELECT * FROM orders LIMIT 10;
SHOW COLUMNS FROM orders;
SELECT COUNT(*) AS total_orders
FROM orders;

-- CUSTOMERS
SELECT * FROM customers LIMIT 10;
SHOW COLUMNS FROM customers;
SELECT COUNT(*) AS total_customers
FROM customers;

-- LOCATIONS
SELECT * FROM locations LIMIT 10;
SHOW COLUMNS FROM locations;
SELECT COUNT(*) AS total_locations
FROM locations;

-- CUISINES
SELECT * FROM cuisines LIMIT 10;
SHOW COLUMNS FROM cuisines;
SELECT COUNT(*) AS total_cuisines
FROM cuisines;

SHOW COLUMNS FROM restaurants;
SHOW COLUMNS FROM orders;
SHOW COLUMNS FROM customers;
SHOW COLUMNS FROM locations;
SHOW COLUMNS FROM cuisines;

ALTER TABLE customers
CHANGE `ï»¿Customer_ID` Customer_ID VARCHAR(10);

ALTER TABLE locations
CHANGE `ï»¿Location_ID` Location_ID VARCHAR(10);


SHOW COLUMNS FROM customers;
SHOW COLUMNS FROM locations;
SHOW COLUMNS FROM cuisines;

-- Q9. Top 10 restaurants by rating

SELECT
    Restaurant_ID,
    Restaurant_Name,
    Rating,
    Votes
FROM restaurants
WHERE Rating IS NOT NULL
ORDER BY Rating DESC, Votes DESC
LIMIT 10;

-- Q10. Top 10 restaurants by number of votes

SELECT
    Restaurant_ID,
    Restaurant_Name,
    Rating,
    Votes
FROM restaurants
WHERE Votes IS NOT NULL
ORDER BY Votes DESC
LIMIT 10;

-- Q11. Average restaurant rating by location

SELECT
    Location_ID,
    ROUND(AVG(Rating), 2) AS average_rating
FROM restaurants
WHERE Rating IS NOT NULL
GROUP BY Location_ID
ORDER BY average_rating DESC;

-- Q12. Restaurants with rating above overall average

SELECT
    Restaurant_ID,
    Restaurant_Name,
    Rating
FROM restaurants
WHERE Rating > (
    SELECT AVG(Rating)
    FROM restaurants
)
ORDER BY Rating DESC;

-- Q13. Online ordering restaurants with below-average rating

SELECT
    Restaurant_ID,
    Restaurant_Name,
    Rating,
    Online_Order
FROM restaurants
WHERE Online_Order = 'Yes'
  AND Rating < (
      SELECT AVG(Rating)
      FROM restaurants
  )
ORDER BY Rating ASC;

SELECT Order_Date
FROM orders
LIMIT 10;

-- Q14. Monthly order revenue for completed orders

SELECT
    DATE_FORMAT(STR_TO_DATE(Order_Date, '%d-%m-%Y'), '%Y-%m') AS order_month,
    ROUND(SUM(Order_Value), 2) AS monthly_revenue
FROM orders
WHERE Order_Status = 'Completed'
GROUP BY order_month
ORDER BY order_month;

-- Q15. Top 10 restaurants by total completed order value

SELECT
    r.Restaurant_ID,
    r.Restaurant_Name,
    ROUND(SUM(o.Order_Value), 2) AS total_completed_order_value
FROM restaurants r
JOIN orders o
    ON r.Restaurant_ID = o.Restaurant_ID
WHERE o.Order_Status = 'Completed'
GROUP BY r.Restaurant_ID, r.Restaurant_Name
ORDER BY total_completed_order_value DESC
LIMIT 10;

-- Q16. Order cancellation rate by restaurant

SELECT
    r.Restaurant_ID,
    r.Restaurant_Name,
    ROUND(
        SUM(CASE WHEN o.Order_Status = 'Cancelled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM restaurants r
JOIN orders o
    ON r.Restaurant_ID = o.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Restaurant_Name
ORDER BY cancellation_rate DESC;

-- Q17. Highest-rated restaurant in each city

SELECT
    l.City,
    r.Restaurant_ID,
    r.Restaurant_Name,
    r.Rating
FROM restaurants r
JOIN locations l
    ON r.Location_ID = l.Location_ID
WHERE r.Rating = (
    SELECT MAX(r2.Rating)
    FROM restaurants r2
    JOIN locations l2
        ON r2.Location_ID = l2.Location_ID
    WHERE l2.City = l.City
)
ORDER BY l.City, r.Rating DESC;