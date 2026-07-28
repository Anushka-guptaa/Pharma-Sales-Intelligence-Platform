CREATE DATABASE pharma_sales_db;
USE pharma_sales_db;
SHOW DATABASES;
SELECT DATABASE();
USE pharma_sales_db;

CREATE TABLE pharma_sales (
    Distributor VARCHAR(255),
    `Customer Name` VARCHAR(255),
    City VARCHAR(100),
    Country VARCHAR(100),
    Latitude DOUBLE,
    Longitude DOUBLE,
    Channel VARCHAR(100),
    `Sub-channel` VARCHAR(100),
    `Product Name` VARCHAR(255),
    `Product Class` VARCHAR(100),
    Quantity DOUBLE,
    Price DOUBLE,
    Sales DOUBLE,
    Month VARCHAR(20),
    Year INT,
    `Name of Sales Rep` VARCHAR(255),
    Manager VARCHAR(255),
    `Sales Team` VARCHAR(100),
    `Calculated Sales` DOUBLE
);
SHOW TABLES;
SELECT COUNT(*) FROM pharma_sales;
SELECT *
FROM pharma_sales
LIMIT 200;

-- random examination

SHOW TABLES;
DESCRIBE pharma_sales;
SELECT COUNT(*) FROM pharma_sales;
SELECT Country,
       Sales,
       Quantity
FROM pharma_sales
LIMIT 10;

-- analysis

SELECT SUM(Sales) AS Total_Revenue
FROM pharma_sales;       # to check total revenue

SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM pharma_sales;                    # how many units sold

SELECT COUNT(*) AS Total_Transactions
FROM pharma_sales;

SELECT AVG(Sales) AS Average_Sale
FROM pharma_sales;

SELECT MAX(Sales) AS Highest_Sale
FROM pharma_sales;

SELECT MAX(Sales) AS Highest_Sale
FROM pharma_sales;

SELECT Country,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY Country;

SELECT `Sales Team`,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY `Sales Team`;
#ORDER BY Revenue DESC; add this to find the best sales team

SELECT Manager,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY Manager;
#again add order by desc for best manager

SELECT `Product Name`,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY `Product Name`;

SELECT `Product Name`,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY `Product Name`
ORDER BY Total_Revenue DESC
LIMIT 10;  # top 10 products

SELECT `Customer Name`,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY `Customer Name`
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT Channel,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY Channel
ORDER BY Total_Revenue DESC;

SELECT `Product Class`,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY `Product Class`
ORDER BY Total_Revenue DESC;

#adding column .. primary key
ALTER TABLE pharma_sales
ADD COLUMN Sale_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

Describe pharma_sales;
SELECT *
FROM pharma_sales
LIMIT 200;

ALTER TABLE pharma_sales
MODIFY COLUMN Quantity INT;

ALTER TABLE pharma_sales
MODIFY COLUMN Price DECIMAL(10,2);

ALTER TABLE pharma_sales
MODIFY COLUMN Sales DECIMAL(12,2);

-- more analysis

SELECT Sale_ID,
       Country,
       `Product Name`,
       Sales
FROM pharma_sales
WHERE Country = 'Germany';

SELECT Sale_ID,
       `Customer Name`,
       Sales
FROM pharma_sales
WHERE Sales > 5000
ORDER BY Sales DESC;

SELECT *
FROM pharma_sales
WHERE Country='Germany'
AND Year=2020;

SELECT *
FROM pharma_sales
WHERE Country='Germany'
OR Country='Poland';

# same thing could be written as 
SELECT *
FROM pharma_sales
WHERE Country IN ('Germany','Poland');

SELECT DISTINCT `Product Name`
FROM pharma_sales
WHERE `Product Name`
LIKE 'A%';

SELECT DISTINCT Country
FROM pharma_sales;

SELECT Country,
       SUM(Sales) AS Total_Revenue
FROM pharma_sales
GROUP BY Country
HAVING SUM(Sales)>1000000;

SELECT Year,
       SUM(Sales) AS Revenue
FROM pharma_sales
GROUP BY Year
ORDER BY Year; #yearly revenue change by month for monthly

SELECT Sale_ID,
       Sales,
       CASE
           WHEN Sales >=5000 THEN 'High Value'
           ELSE 'Regular'
       END AS Transaction_Type
FROM pharma_sales;

CREATE VIEW product_revenue AS
SELECT `Product Name`,
       SUM(Sales) AS Revenue
FROM pharma_sales
GROUP BY `Product Name`;

SELECT *
FROM product_revenue
ORDER BY Revenue DESC;

SELECT Sale_ID,
       Country,
       Sales
FROM pharma_sales
WHERE Country NOT IN ('Germany');

SELECT DISTINCT `Product Name`
FROM pharma_sales
WHERE `Product Name` LIKE 'A%';

SELECT DISTINCT Country
FROM pharma_sales
WHERE Country LIKE '_e%';

SELECT *
FROM pharma_sales
WHERE Manager IS NULL;

-- multiple group by 

SELECT Country,
       Year,
       SUM(Sales) AS Revenue
FROM pharma_sales
GROUP BY Country, Year
ORDER BY Country, Year;

#Show managers in Germany whose revenue exceeded $500,000.
SELECT Manager,
       SUM(Sales) AS Revenue
FROM pharma_sales
WHERE Country='Germany'
GROUP BY Manager
HAVING SUM(Sales)>500000
ORDER BY Revenue DESC;

-- column alias
SELECT SUM(Sales) AS Revenue
FROM pharma_sales;

-- table alias
SELECT p.Country,
       p.Sales
FROM pharma_sales AS p;

-- subquery
SELECT Sale_ID,
       Sales
FROM pharma_sales
WHERE Sales >
(
    SELECT AVG(Sales)
    FROM pharma_sales
);

#cte(common table expression)
WITH CountryRevenue AS
(
    SELECT Country,
           SUM(Sales) AS Revenue
    FROM pharma_sales
    GROUP BY Country
)

SELECT *
FROM CountryRevenue
WHERE Revenue > 1000000;
#Instead of nesting multiple subqueries,
# you create a temporary named result that is easier to read and reuse.

# ADVANCED SQL 
#WINDOWS FUNCITON
#ROWNUM RANK DENSE RANK
SELECT Sale_ID,
       Sales,
       ROW_NUMBER() OVER (ORDER BY Sales DESC) AS Row_Num
FROM pharma_sales;

SELECT Sale_ID,
       Sales,
       RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank
FROM pharma_sales;

SELECT Sale_ID,
       Sales,
       DENSE_RANK() OVER (ORDER BY Sales DESC) AS dense_Ranks
FROM pharma_sales;
