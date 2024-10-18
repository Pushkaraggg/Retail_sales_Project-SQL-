# Retail_sales_Project-SQL-
Objectives:
Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
Project Structure
1. Database Setup
Database Creation: The project starts by creating a database .
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount`sql
```sql
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
```
###2. Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.

```sql
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
```
###3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

1.**Write a SQL query to retrieve all columns for sales made on '2022-11-05?**
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2.**Write a SQL query to retrieve all transactions where the category is 'Clothing'and the quantity sold is more than 4 in the month of Nov-2022?**
```sql
SELECT * FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;
```
	
3.**Write a SQL query to calculate the total sales (total_sale) for each category?**
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;
```

4.**Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?**
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

5.**Write a SQL query to find all transactions where the total_sale is greater than 1000?**
```sql
SELECT transactions_id,total_sale
FROM retail_sales
WHERE total_sale>'1000';
```

6.**Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?**
```sql
SELECT gender,category,
COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender,category
ORDER BY category;
```

7.**Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?**
```sql
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
```

8.**Write a SQL query to find the top 5 customers based on the highest total sales?**
```sql
SELECT customer_id,
SUM(total_sale) AS net_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;
```

9.**Write a SQL query to find the number of unique customers who purchased items from each category?**
```sql
SELECT category,
COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY 1
```

10.**Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?**
```sql
WITH my_cte AS (SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) AS Hour < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) AS Hour  BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening' END AS shift
FROM retail_sales)

 SELECT shift, COUNT(transactions_id) AS total_orders
 FROM my_cte
 GROUP BY shift
```
 ##Findings
1.**Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
2.**High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
3.**Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
4.**Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

##Reports
1.**Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
2.**Trend Analysis**: Insights into sales trends across different months and shifts.
3.**Customer Insights**: Reports on top customers and unique customer counts per category.

##Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.




