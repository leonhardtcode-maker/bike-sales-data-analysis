/* 
SELECT * FROM gold.dim_products
SELECT * FROM gold.fact_sales
*/

WITH base_query AS (
SELECT
	dp.product_key,
	dp.product_name,
	dp.category,
	dp.subcategory,
	DATEFROMPARTS(YEAR(fs.order_date),MONTH(fs.order_date),1) AS order_date_month,
	COUNT(DISTINCT(fs.order_number)) AS monthly_order,
	COUNT(DISTINCT(fs.customer_key)) AS monthly_customer,
	SUM(quantity) AS monthly_quantity,
	SUM(sales_amount) AS monthly_revenue,
	SUM(dp.cost * fs.quantity) AS monthly_cost
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE fs.order_date IS NOT NULL
GROUP BY 
	dp.product_key, 
	dp.product_name, 
	dp.category,
	dp.subcategory, 
	DATEFROMPARTS(YEAR(fs.order_date),MONTH(fs.order_date),1)
)
SELECT *
FROM (
SELECT
	product_name,
	order_date_month,
	monthly_revenue,
	LAG(monthly_revenue, 1) OVER(PARTITION BY product_name ORDER BY order_date_month) AS revenue_prev_1,
	LAG(monthly_revenue, 2) OVER(PARTITION BY product_name ORDER BY order_date_month) AS revenue_prev_2
FROM base_query)t
WHERE 
	monthly_revenue < revenue_prev_1 
	AND revenue_prev_1 < revenue_prev_2 
	AND YEAR(order_date_month) = 2013