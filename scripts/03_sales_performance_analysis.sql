Select * From INFORMATION_SCHEMA.TABLES
Select * From INFORMATION_SCHEMA.COLUMNS

Select * From gold.fact_sales
Select * From gold.dim_customers
Select * From gold.dim_products

-- SALES PERFORMANCE QUESTIONS

--Berapa total revenue(sales_amount) tiap produk
Select
	p.product_name,
	Sum(f.sales_amount) As product_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Group By p.product_name
Order By product_revenue Desc

--Produk mana yang menghasilkan revenue terbesar tahun ini?
Select
	p.product_key,
	p.product_name,
	Sum(f.sales_amount) As product_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Where Year(f.order_date) = 2014
Group By p.product_key,p.product_name
Order By product_revenue Desc

--Berapa total quantity yang terjual per bulan?
SELECT 
    MONTH(order_date) AS production_month,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY 
    MONTH(order_date)
ORDER BY 
    production_month;

--Berapa rata-rata harga jual (price) per kategori produk?
Select
	p.category,
	Avg(f.price) As average_selling_price,
	Sum(f.sales_amount) As product_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Group By p.category
Order By p.category

--Produk mana yang paling banyak terjual dalam jumlah unit?
Select Top 1
	p.product_name,
	Sum(f.quantity) As total_quantity
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Group By p.product_name
Order By total_quantity Desc

--Produk apa yang paling sedikit terjual?
Select Top 1
	p.product_name,
	Sum(f.quantity) As total_quantity
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Group By p.product_name
Order By total_quantity

--Berapa total penjualan berdasarkan kategori produk?
Select
	p.category,
	Sum(f.sales_amount) As total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Group By p.category
Order By total_revenue

--Berapa total penjualan berdasarkan product_line?
Select
	p.product_line,
	Sum(f.sales_amount) As total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
Group By p.product_line
Order By total_revenue

--Bagaimana tren penjualan 6 bulan terakhir?
SELECT
    FORMAT(f.order_date, 'yyyy-MM') AS bulan,
	Sum(f.quantity) as total_quantity,
    SUM(f.sales_amount) AS total_revenue,
    AVG(f.sales_amount) AS average_price
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE 
    YEAR(f.order_date) = 2013
    AND MONTH(f.order_date) >= 7
GROUP BY FORMAT(f.order_date, 'yyyy-MM')
ORDER BY FORMAT(f.order_date, 'yyyy-MM');

--Berapa rata-rata banyak order yang dibuat setiap hari?
Select
	Avg(order_per_day) As avg_order_per_day
From (
	Select 
		order_date,
		Count(quantity) As order_per_day
	From gold.fact_sales
	Group By order_date
	)t
--
SELECT
    FORMAT(f.order_date, 'dd') AS tanggal,
    SUM(f.quantity) AS total_order_per_day
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY FORMAT(f.order_date, 'dd')
ORDER BY FORMAT(f.order_date, 'dd');

--Berapa rata-rata waktu antara order_date dan shipping_date?
SELECT 
    AVG(ABS(DATEDIFF(Day, shipping_date, order_date))) AS avg_shipping_days
FROM gold.fact_sales;
