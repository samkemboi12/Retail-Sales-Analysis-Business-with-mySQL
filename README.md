
# Retail Sales Analysis SQL Project

## Project Overview
This project focuses on analyzing retail sales data to answer key business questions and generate actionable insights.
The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.The analysis provides insights into customer behavior, category performance, top performing months, and sales trends by shift, helping businesses make informed, data driven decisions. The repository contains organized SQL scripts that can be easily reused for reporting, decision-making, or further analytics projects.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sales_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sales_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

-  Check the total number of records in the dataset.
-  Find out how many unique customers are in the dataset.
- Identify all unique product categories in the dataset.
- Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to show transactions where category is clothing and quantity is above 4 records for Nov 2022 only**:
```sql
SELECT *
FROM retail_sales
WHERE category="clothing" AND
DATE_FORMAT(sale_date,'%Y-%m')="2022-11" AND
quantity >=4;
```

3. **Write a SQL query to calculate the total sales for each category.**:
```sql
SELECT category as Categpry,
SUM(total_sale) AS net_sale,
COUNT(*) AS Total_orders
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(avg(age),2),
category
FROM retail_sales
WHERE category="Beauty"
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions made by each gender in each category.**:
```sql
SELECT gender,
category,
COUNT(transactions_id) as total_count
FROM retail_sales
GROUP BY gender, category
ORDER BY category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT * FROM
	(
	SELECT DATE_FORMAT(sale_date, "%Y") as Year,
	DATE_FORMAT(sale_date, "%m") AS Month,
    AVG(total_sale) AS Average_sales,
	RANK() OVER(
                PARTITION BY DATE_FORMAT(sale_date, "%Y")
                ORDER BY AVG(total_sale) DESC
               ) AS RNK
    FROM retail_sales
	GROUP BY Year, Month
		) as ranked_month
	WHERE RNK = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id as Customer,
SUM(total_sale) as Total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_sales DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT DISTINCT category,
COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT SHIFT,
COUNT(transactions_id)
FROM
	(
		SELECT *,
			CASE
			   WHEN HOUR(sale_time)<12 THEN "Morning"
			   WHEN HOUR(sale_time) between 12 and 17 THEN "Afternoon"
			   ELSE "Evening" 
			END AS SHIFT 
			from retail_sales
            ) AS shifts
GROUP BY SHIFT
```

## Findings
- **Sales Trends**: Monthly analysis shows July 2022 and February 2023 are the months with high sales within the respective year
- **Customer Demographics**: The data shows that customers from various age groups are represented with average age being 40 years. The are sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.

- **Customer Insights**: The analysis identifies the top-spending customers is customers with Ids 3,5,2,1 spending a total of 38,440 , 30750,  30405 and 25295 respectively.
- **Category with highest orders**: It is evident from my analysis that there are 3 categories of products from our data. Clothing, Beauty and Electronics. Clothing is on the lead with more orders followed by Electronics and finally beauty
- **Shift with high sales**: Based on the shifts, it is evident that sales and orders aare high in the evening , followed by morning and afternoon respectively

## Conclusion

The findings from this project can help drive business decisions by understanding sales patterns and trends, peak hours and months, customer behavior, and product performance. <br>Through this project stake holders can understand the performance of the business and managers can make improvemnets where necessary such as improving marketing of products with low sales.<br> By identifying the customers with highest sales, managers can ensure that the common purchases by those customers are readily available to maintain the customers. 

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
3. **Explore and Modify**: You can modify the queries to explore different aspects of the dataset or answer additional business questions.

