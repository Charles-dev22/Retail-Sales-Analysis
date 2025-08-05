SELECT *
FROM retail_sales
WHERE  transactions_id IS NULL
	OR 
		sale_date IS NULL
	OR
		sale_time IS NULL
	OR 
		customer_id IS NULL
	OR 
		gender IS NULL
	OR 
		age IS NULL
	OR
		category IS NULL
	OR
		quantiy IS NULL
	OR 
		price_per_unit IS NULL
	OR
		cogs IS NULL
	OR 
		total_sale IS NULL;
        
DELETE FROM retail_sales
WHERE  transactions_id IS NULL
	OR 
		sale_date IS NULL
	OR
		sale_time IS NULL
	OR 
		customer_id IS NULL
	OR 
		gender IS NULL
	OR 
		age IS NULL
	OR
		category IS NULL
	OR
		quantiy IS NULL
	OR 
		price_per_unit IS NULL
	OR
		cogs IS NULL
	OR 
		total_sale IS NULL;
        
--- How many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales;

---- How many unique customers
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- How many categories we have
SELECT DISTINCT category
FROM retail_sales;

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all the transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy >= 4
AND sale_date >= '2022-11-01' AND sale_date < '2022-12-01';

-- Q3. Write a SQL query to calculate the total sales(total_sale) for each category
SELECT DISTINCT category, SUM(total_sale) AS sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4. Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6.Write a SQL query to find the total number of transactions(transactions_id) made by each gender in each category.
SELECT DISTINCT category, gender, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender,category
ORDER BY 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS sale_month, ROUND(AVG(total_sale),2) AS average_sale
FROM retail_sales
GROUP BY sale_month
ORDER BY sale_month;

SELECT YEAR(sale_date) AS year,
	MONTH(sale_date) AS month, 
    AVG(total_sale) AS avg_sale,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ran 
FROM retail_sales
GROUP BY year,month
;

WITH CTE_one AS
(SELECT YEAR(sale_date) AS year,
	MONTH(sale_date) AS month, 
    AVG(total_sale) AS avg_sale,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ran 
FROM retail_sales
GROUP BY year,month
)
SELECT *
FROM CTE_one 
WHERE ran = 1;

-- Q8. Write an SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) AS sales
FROM retail_sales
GROUP BY customer_id
ORDER BY sales DESC
LIMIT 5;

-- Q9. Write an SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS customers
FROM retail_sales
GROUP BY category;

-- Q10. Write an SQL query to create each shift and number of orders (Example morning <=12, Afternoon Between 12 & 17, Evening > 17)
SELECT *,
	CASE
		WHEN sale_time <= '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        WHEN sale_time > '17:00:00' THEN 'Evening'
    END AS shift
FROM retail_sales;

WITH cte_two AS
(
SELECT *,
	CASE
		WHEN sale_time <= '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        WHEN sale_time > '17:00:00' THEN 'Evening'
    END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM cte_two
GROUP BY shift;