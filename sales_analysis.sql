SELECT * FROM sales_db;
CREATE TABLE retail_sales(
                    transactions_id	INT,
                    sale_date DATE,
                    sale_time TIME,
                    customer_id	INT,
                    gender	VARCHAR(15),
                    age	INT,
                    category VARCHAR(15),
                    quantity INT,
                    price_per_unit FLOAT,
                    cogs FLOAT,
                    total_sale FLOAT
				)

SELECT COUNT(*) FROM retail_sales;
-- UPDATE PRIMARY KEY--
ALTER TABLE retail_sales
ADD PRIMARY KEY(transactions_id);
-- DATA CLEANING
-- CHECK FOR NULL VALUES--
SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL OR
     sale_date IS NULL OR
     sale_time IS NULL OR
     customer_id IS NULL OR
     gender IS NULL OR
     age IS NULL OR
     category IS NULL OR
     quantity IS NULL OR
     cogs IS NULL OR
     total_sale IS NULL;
-- EDA
SELECT * FROM retail_sales;
-- How many customers we have
SELECT COUNT(DISTINCT customer_id ) AS Total_customers FROM retail_sales ;
-- How many categories do we have
SELECT COUNT(DISTINCT category) AS Total_categories FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
SELECT * FROM retail_sales WHERE sale_date = "2022-11-05";

-- Query where category is clothing and quantity is above 4 records for Nov 2022 only
SELECT * FROM retail_sales
WHERE category="clothing" AND
DATE_FORMAT(sale_date,'%Y-%m')="2022-11" AND
quantity >=4;
-- Write a query to calculate the total sales for each category
SELECT category as Categpry, SUM(total_sale) AS net_sale,COUNT(*) AS Total_orders
FROM retail_sales
GROUP BY category;

-- Write a query that finds the average age of customers who purchased from beauty category
SELECT ROUND(avg(age),2), category
FROM retail_sales
WHERE category="Beauty"
group by category;

-- Find the transactions where total sale is greater than 1000
SELECT * FROM retail_sales where total_sale > 1000;
-- Find the total nubers of transactions made by each gender in each category

SELECT gender, category , COUNT(transactions_id) as total_count from retail_sales group by gender, category order by category;

-- Find the average sale of each month. Find the best month of each year
SELECT * FROM
	(
	SELECT DATE_FORMAT(sale_date, "%Y") as Yearr,
	DATE_FORMAT(sale_date, "%m") AS Monthh, AVG(total_sale) AS Average_sales,
	RANK() OVER( PARTITION BY DATE_FORMAT(sale_date, "%Y") order by AVG(total_sale) DESC) AS RNK FROM retail_sales
	group by Yearr, Monthh
		) as ranked_month
	WHERE RNK = 1;
-- Write a query to find the top 5 customers based on highest total sales
SELECT customer_id as Customer, SUM(total_sale) as Total_sales from retail_sales
group by customer_id
order by Total_sales DESC
LIMIT 5;

-- Write a query to find the number unique customers who purchased items from each category 
SELECT DISTINCT category, COUNT(DISTINCT customer_id) from retail_sales
group by category;

-- Write a query to each shift and the number of orders it recieved ( < 12 "morning", 12 and 17 "afternoon" and past that is evening)
SELECT SHIFT, COUNT(transactions_id) FROM
	(
		SELECT *,
			CASE
			   WHEN HOUR(sale_time)<12 THEN "Morning"
			   WHEN HOUR(sale_time) between 12 and 17 THEN "Afternoon"
			   ELSE "Evening" 
			END AS SHIFT 
			from retail_sales
            ) AS shifts
group by SHIFT
    


