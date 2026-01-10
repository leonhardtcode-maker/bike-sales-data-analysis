-- Pertanyaan Terkait Produk (Product Analysis)
Select * From INFORMATION_SCHEMA.TABLES
Select * From INFORMATION_SCHEMA.COLUMNS

SELECT * FROM gold.fact_sales
SELECT * FROM gold.dim_customers
SELECT * FROM gold.dim_products 


/*=========== PERFORMANCE PER PRODUCT ===========*/

--Produk mana yang paling menguntungkan (sales_amount – cost)?
Select 
	p.product_name,
	p.category,
	p.cost,
	f.sales_amount,
	Sum(f.quantity) As purchase_count,
	Sum(f.sales_amount - p.cost) As income
From gold.fact_sales f
Left Join gold.dim_products p
On f.product_key = p.product_key
Group By p.product_name, p.category, p.cost, f.sales_amount
Order By income Desc

--Produk dengan maintenance = true menghasilkan berapa revenue?
Select Sum(revenue) As total_revenue
From (
	Select 
		p.product_name,
		Sum(f.sales_amount) As revenue
	From gold.fact_sales f
	Left Join gold.dim_products p
	On f.product_key = p.product_key
	Where p.maintenance = 'Yes'
	Group By p.product_name
	)t

--Subkategori mana yang paling laku?
Select 
	p.product_name,
	p.category,
	p.subcategory,
	Sum(f.quantity) As quantity_count
From gold.fact_sales f
Left Join gold.dim_products p
On f.product_key = p.product_key
Group By p.product_name, p.category, p.subcategory
Order By quantity_count Desc

--Produk mana yang tidak pernah terjual?
Select 
	p.product_name,
	p.category,
	p.subcategory
From gold.fact_sales f
Left Join gold.dim_products p
On f.product_key = p.product_key
Where f.quantity = 0
Group By p.product_name, p.category, p.subcategory
Order By p.category


/*===========  LIFE CYCLE MANAGEMENT ===========*/

--Produk dengan margin tertinggi berdasarkan kategori?
Select 
	p.category,
	Sum(f.sales_amount - p.cost) As income
From gold.fact_sales f
Left Join gold.dim_products p
On f.product_key = p.product_key
Group By p.category
Order By income Desc

--Produk yang memiliki penjualan menurun selama 3 bulan berturut-turut?
WITH monthly_sales AS (
    SELECT
        fs.product_key,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1) AS month_start,
        SUM(fs.quantity) AS total_qty
    FROM gold.fact_sales fs
    GROUP BY 
        fs.product_key,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1)
),
with_lag AS (
    SELECT
        product_key,
        month_start,
        total_qty,
        LAG(total_qty, 1) OVER (PARTITION BY product_key ORDER BY month_start) AS qty_prev1,
        LAG(total_qty, 2) OVER (PARTITION BY product_key ORDER BY month_start) AS qty_prev2
    FROM monthly_sales
)
SELECT 
    dp.product_id,
    dp.product_number,
    dp.product_name,
    wl.month_start,
    wl.total_qty,
    wl.qty_prev1,
    wl.qty_prev2,
	((wl.qty_prev2 - wl.total_qty) * 1.0 / wl.qty_prev2) * 100 AS drop_perncentage
FROM with_lag wl
JOIN gold.dim_products dp ON dp.product_key = wl.product_key
WHERE wl.total_qty < wl.qty_prev1
  AND wl.qty_prev1 < wl.qty_prev2
  AND YEAR(wl.month_start) = 2013
ORDER BY (wl.qty_prev2 - wl.total_qty) DESC, drop_perncentage DESC;

-- Produk yang mengalami kenaikan penjualan selama 2 bulan berturut-turut
WITH monthly_sales AS (
	SELECT
		product_key,
		DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS starting_month,
		SUM(quantity) AS starting_month_quantity
	FROM gold.fact_sales
	GROUP BY product_key, DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
),
monthly_lead AS (
	SELECT
		product_key,
		starting_month,
		starting_month_quantity,
		LEAD(starting_month_quantity, 1) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_next_1,
		LEAD(starting_month_quantity, 2) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_next_2
	FROM monthly_sales
)
SELECT
	dp.product_number,
	dp.product_name,
	dp.category,
	ml.starting_month,
	ml.starting_month_quantity,
	ml.quantity_next_1,
	ml.quantity_next_2,
	((ml.quantity_next_2 - ml.starting_month_quantity) * 1.0 / ml.starting_month_quantity) * 100 AS up_percentage
FROM
	monthly_lead AS ml
	JOIN gold.dim_products dp ON ml.product_key = dp.product_key
WHERE YEAR(starting_month) = 2013
ORDER BY (ml.quantity_next_2 - ml.starting_month_quantity) DESC

-- Produk yang tidak pernah mengalami penurunan dalam 6 bulan terakhir
WITH monthly_sales AS (
	SELECT
		product_key,
		DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS starting_month,
		SUM(quantity) AS starting_month_quantity
	FROM gold.fact_sales
	GROUP BY product_key, DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
),
monthly_lead AS (
	SELECT
		product_key,
		starting_month,
		starting_month_quantity,
		LAG(starting_month_quantity, 1) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_prev_1,
		LAG(starting_month_quantity, 2) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_prev_2,
		LAG(starting_month_quantity, 3) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_prev_3,
		LAG(starting_month_quantity, 4) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_prev_4,
		LAG(starting_month_quantity, 5) OVER (PARTITION BY product_key ORDER BY starting_month) AS quantity_prev_5
	FROM monthly_sales
)
SELECT
	dp.product_number,
	dp.product_name,
	dp.category,
	ml.starting_month_quantity,
	ml.quantity_prev_1,
	ml.quantity_prev_2,
	ml.quantity_prev_3,
	ml.quantity_prev_4,	
	ml.quantity_prev_5
FROM monthly_lead AS ml
JOIN gold.dim_products dp ON ml.product_key = dp.product_key
WHERE YEAR(starting_month) = 2013
AND ml.starting_month_quantity < ml.quantity_prev_5
ORDER BY (starting_month_quantity-quantity_prev_5)

-- Identifikasi sub-kategori produk dengan siklus penjualan musiman (seasonality sederhana)
WITH monthly_sales AS (
	SELECT 
		dp.subcategory AS subcategory,
		MONTH(fs.order_date) AS sales_month,
		YEAR(fs.order_date) AS sales_year,
		SUM(fs.quantity) AS total_qty
	FROM gold.fact_sales fs
	JOIN gold.dim_products dp ON fs.product_key = dp.product_key
	GROUP BY dp.subcategory, MONTH(fs.order_date), YEAR(fs.order_date)
), 
sales_with_season AS (
	SELECT
		subcategory,
		CASE 
			WHEN sales_month IN (12, 1, 2) THEN 'Winter'
			WHEN sales_month IN (3, 4, 5) THEN 'Spring'
			WHEN sales_month IN (6, 7, 8) THEN 'Summer'
			WHEN sales_month IN (9, 10, 11) THEN 'Fall'
		END AS season,
		sales_year,
		total_qty
	FROM monthly_sales
)
SELECT
	sws.subcategory,
	sws.season,
	sws.sales_year,
	SUM(sws.total_qty) AS total_qty
FROM sales_with_season sws
GROUP BY sws.subcategory, sws.season, sws.sales_year
ORDER BY sws.subcategory

-- YoY Analisis dari Setiap Category pada tahun 2013 dibandingkan dengan 2012?
WITH yearly_sales AS (
	SELECT
		dp.category,
		YEAR(fs.order_date) AS sales_year,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales fs
	JOIN gold.dim_products dp ON fs.product_key = dp.product_key
	GROUP BY YEAR(order_date), dp.category
	),
sales_with_lag AS (
	SELECT
		category,
		sales_year,
		total_sales,
		LAG(total_sales, 1) OVER (PARTITION BY category ORDER BY sales_year) AS total_sales_year_before
	FROM yearly_sales
	)
SELECT
	category,
	sales_year,
	total_sales,
	total_sales_year_before,
	CASE 
		WHEN total_sales_year_before IS NULL OR total_sales_year_before = 0
			THEN NULL
		ELSE CAST(
				(total_sales * 1.0 / total_sales_year_before - 1) * 100
				AS DECIMAL(18,1))
	END AS yoy_prcnt
FROM sales_with_lag
WHERE sales_year = 2013

-- MoM untuk Bulan Januari 2014 dengan 2013?
WITH yearly_sales AS (
	SELECT
		dp.category,
		MONTH(fs.order_date) AS sales_month,
		YEAR(fs.order_date) AS sales_year,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales fs
	JOIN gold.dim_products dp ON fs.product_key = dp.product_key
	GROUP BY dp.category, MONTH(order_date), YEAR(order_date)
	),
sales_with_lag AS (
	SELECT
		category,
		sales_month,
		sales_year,
		total_sales,
		LAG(total_sales, 1) OVER (PARTITION BY category ORDER BY sales_month) AS month_sales_year_before
	FROM yearly_sales
	)
SELECT
	category,
	sales_month,
	sales_year,
	total_sales,
	month_sales_year_before,
	CASE 
		WHEN month_sales_year_before IS NULL OR month_sales_year_before = 0
			THEN NULL
		ELSE CAST(
				(total_sales * 1.0 / month_sales_year_before - 1) * 100
				AS DECIMAL(18,1))
	END AS yoy_prcnt
FROM sales_with_lag
WHERE sales_year = 2014 AND sales_month = 1