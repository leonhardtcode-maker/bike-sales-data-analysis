/* 
SELECT * FROM gold.dim_customers
SELECT * FROM gold.fact_sales
;
*/

WITH base_quary AS (
SELECT
	fs.customer_key,
	CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
	fs.order_date,
	dc.country,
	dc.marital_status,
	dc.gender,
	DATEDIFF(YEAR, dc.birthdate, GETDATE()) AS age, 
	SUM(fs.quantity) AS total_bought,
	SUM(fs.sales_amount) AS revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
WHERE YEAR(fs.order_date) IN (2012, 2013)
  AND dc.gender IS NOT NULL
  AND dc.country IS NOT NULL
  AND LOWER(dc.gender) <> 'n/a'
  AND LOWER(dc.country) <> 'n/a'
GROUP BY 
	fs.customer_key, 
	CONCAT(dc.first_name, ' ', dc.last_name),
	fs.order_date,
	dc.country,
	dc.marital_status,
	dc.gender,
	DATEDIFF(YEAR, dc.birthdate, GETDATE())
)


SELECT *
FROM base_quary
