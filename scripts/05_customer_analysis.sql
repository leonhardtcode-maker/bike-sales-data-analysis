-- Pertanyaan Terkait Pelanggan (Customer Analysis)
Select * From INFORMATION_SCHEMA.TABLES
Select * From INFORMATION_SCHEMA.COLUMNS

Select * From gold.fact_sales
Select * From gold.dim_customers
Select * From gold.dim_products

/*=========== DEMOGRAFI PELANGGAN ===========*/

--Berapa jumlah pelanggan per negara?
Select 
	country,
	Count(customer_key) as total_customers
From gold.dim_customers
Group By country
Order By total_customers

--Negara mana yang menghasilkan penjualan tertinggi?
Select 
	c.country,
	Sum(f.sales_amount) As total_revenue
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.country
Order By total_revenue Desc

--Bagaimana distribusi gender pelanggan?
Select 
	gender,
	Count(customer_key)
From gold.dim_customers
Group By gender

--Kelompok umur mana yang paling banyak melakukan pembelian?
Select 
	DateDiff(Year, birthdate, GETDATE()) As customers_age,
	Sum(f.quantity) As total_bought_item
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By DateDiff(Year, birthdate, GETDATE())
Order By total_bought_item Desc

--Pelanggan dengan marital_status tertentu (misal married) menghabiskan berapa total belanja?
Select 
	c.marital_status,
	Sum(f.sales_amount) As total_revenue
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.marital_status
Order By total_revenue Desc



/*=========== PERILAKU PELANGGAN ===========*/

--Pelanggan mana yang paling banyak melakukan pembelian?
Select 
	c.customer_key,
	c.first_name,
	c.last_name,
	Count(f.quantity) As total_bought_item
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.customer_key, c.first_name, c.last_name
Order By total_bought_item Desc

--Berapa rata-rata pembelanjaan per pelanggan?
Select Avg(total_bought_item) as avg_purchase
From (
	Select 
		c.customer_key,
		Count(f.quantity) As total_bought_item
	From gold.fact_sales f
	Left Join gold.dim_customers c
	On f.customer_key = c.customer_key
	Group By c.customer_key
	)t

--Pelanggan mana yang membeli lebih dari 1 kategori produk?
Select * 
From (
	Select 
			c.customer_key,
			c.first_name,
			c.last_name,
			Count(Distinct(f.product_key)) As item_type_purchase
		From gold.fact_sales f
		Left Join gold.dim_customers c
		On f.customer_key = c.customer_key
		Group By c.customer_key, first_name, c.last_name
		)t
Where item_type_purchase > 1
Order By item_type_purchase Desc



/*=========== ANALISIS LOYALTY & HIGH-VALUE CUSTOMER ===========*/

--Pelanggan mana yang masuk kategori “top 10 spender”?
Select Top 10
	c.customer_key,
	c.first_name,
	c.last_name,
Sum(f.sales_amount) As total_revenue
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.customer_key, first_name, c.last_name
Order By total_revenue Desc

--Berapa kontribusi revenue dari 20% pelanggan teratas?
Select Top 20 Percent
	c.customer_key,
	c.first_name,
	c.last_name,
Sum(f.sales_amount) As revenue
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Group By c.customer_key, first_name, c.last_name
Order By revenue Desc
--Kalau di total
Select Sum(revenue) As total_revenue
From (
	Select Top 20 Percent
		c.customer_key,
		c.first_name,
		c.last_name,
	Sum(f.sales_amount) As revenue
	From gold.fact_sales f
	Left Join gold.dim_customers c
	On f.customer_key = c.customer_key
	Group By c.customer_key, first_name, c.last_name
	Order By revenue Desc
	)t

--Pelanggan mana yang paling sering membeli produk kategori tertentu?
Select 
	c.customer_key,
	c.first_name,
	c.last_name,
	p.category,
	Count(Distinct(f.product_key)) As purchase_category_item
From gold.fact_sales f
Left Join gold.dim_customers c
On f.customer_key = c.customer_key
Left Join gold.dim_products p 
On f.product_key = p.product_key
Group By c.customer_key, c.first_name, c.last_name, p.category
Order By purchase_category_item Desc