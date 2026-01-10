/* 
SELECT * FROM gold.dim_products
SELECT * FROM gold.fact_sales
SELECT * FROm gold.dim_customers
*/

WITH base_query AS (
SELECT
	fs.order_number,
	fs.customer_key,
	cs.country,
	pd.product_key,
	pd.product_name,
	pd.category,
	pd.subcategory,
	fs.order_date,
	fs.quantity,
	fs.sales_amount,
	pd.cost
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products pd
ON fs.product_key = pd.product_key
RIGHT JOIN gold.dim_customers cs
ON fs.customer_key = cs.customer_key
WHERE fs.order_date IS NOT NULL
AND cs.country != 'n/a'
GROUP BY 
	fs.order_number,
	fs.customer_key,
	cs.country,
	pd.product_key,
	pd.product_name,
	pd.category,
	pd.subcategory,
	fs.order_date,
	fs.quantity,
	fs.sales_amount,
	pd.cost
)
SELECT *
FROM base_query
WHERE YEAR(order_date) = 2012
OR YEAR(order_date) = 2013