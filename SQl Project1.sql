CREATE TABLE retail_sales 
(transactions_id INT8 PRIMARY  KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT8 NOT NULL,
gender VARCHAR(5),
age	VARCHAR(5),
category VARCHAR(10),
quantiy	NUMERIC NOT NULL,
price_per_unit	NUMERIC,
cogs NUMERIC,
total_sale NUMERIC);
---------------------------------DATA CLEANING & EXPLORATION---------------------------------------------

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL 
	OR gender IS NULL
	OR age IS NULL 
	OR category IS NULL 
	OR quantity IS NULL 
	OR price_per_unit IS NULL 
	OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL 
	OR gender IS NULL 
	OR age IS NULL 
	OR category IS NULL 
    OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL;

--------------------------------------DATA ANALYSIS & FINDINGS------------------------------------------

--Write a SQL query to retrieve all columns for sales made on '2022-11-05?
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022?
SELECT * FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;
	
--Write a SQL query to calculate the total sales (total_sale) for each category?
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000?
SELECT transactions_id,total_sale
FROM retail_sales
WHERE total_sale>'1000';

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender
--in each category?
SELECT gender,category,
COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender,category
ORDER BY category;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?
WITH my_cte AS (SELECT ROUND(AVG(total_sale),2) AS avg_sale, 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month
FROM retail_sales
GROUP BY 2,3
ORDER BY 1,2 DESC)

SELECT month,year
DENSE_RANK() OVER(PARTITION BY year ORDER BY avg_sale DESC) AS rnk
FROM my_cte
WHERE rnk='1';

--Write a SQL query to find the top 5 customers based on the highest total sales?
SELECT customer_id,
SUM(total_sale) AS net_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

--Write a SQL query to find the number of unique customers who purchased items from each category?
SELECT category,
COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY 1

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon
--Between 12 & 17, Evening >17)?
WITH my_cte AS (SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) AS Hour < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) AS Hour  BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening' END AS shift
FROM retail_sales)

 SELECT shift, COUNT(transactions_id) AS total_orders
 FROM my_cte
 GROUP BY shift
 



