Sebuah proyek analisis data tingkatan pemula yang dilakukan dari berbagai SQL scripts dan juga merupakan implementasi **belajar mengikuti tutorial** dari [Data with Baraa](http://bit.ly/3GiCVUE). 

Dimana Course dan Dataset dapat diakses pada :
- **SQL Exploratory Data Analysis Project:** [Course Link](https://youtu.be/SSKVgrwhzus) | [Download Materials](https://www.datawithbaraa.com/sql-introduction/advanced-sql-analytics-project/) | [GIT Repo](https://github.com/DataWithBaraa/sql-data-analytics-project)
- **SQL Advanced Data Analysis Project:** [Course Link](https://youtu.be/SSKVgrwhzus) | [Download Materials](https://www.datawithbaraa.com/sql-introduction/advanced-sql-analytics-project/) | [GIT Repo](https://github.com/DataWithBaraa/sql-data-analytics-project)

Scripts ini memuat berbagai analisis seperti database exploration, measures and metrics, time-based trends, cumulative analytics, segmentation, dan masih banyak lagi.

> Proyek ini tetap terinspirasi dari tutorial asli
Namun, Saya melakukan **improvisasi dan pengembangan mandiri** untuk melatih kemampuan Saya dalam menganalisis dan memanfaatkan berbagai tools yang memudahkan Saya dalam proses menganalisis tersebut.

For the record:

Dataset yang digunakan dalam repository ini berfokus pada periode tahun 2012–2013. Setiap penyebutan kata “tahun ini” atau “current year” dalam analisis dan visualisasi merujuk pada tahun 2013, sebagai tahun terakhir dalam cakupan data.

## Modifikasi / Penambahan Pribadi
### 1. Exploratory Data Analysis (EDA) menggunakan SQL 
Pada tahap awal, saya melakukan exploratory data analysis (EDA) menggunakan SQL untuk menjawab berbagai pertanyaan bisnis berdasarkan dataset yang tersedia, antara lain:
- 📈 Sales Performance 
  <details><summary><strong>List Pertanyaan</strong></summary>

  1. Berapa total revenue(sales_amount) tiap produk
  2. Produk mana yang menghasilkan revenue terbesar tahun ini
  3. Berapa total quantity yang terjual per bulan
  4. Berapa rata-rata harga jual (price) per kategori produk
  5. Produk mana yang paling banyak terjual dalam jumlah unit
  6. Produk apa yang paling sedikit terjual
  7. Berapa total penjualan berdasarkan kategori produk
  8. Berapa total penjualan berdasarkan product_line
  9. Bagaimana tren penjualan 6 bulan terakhir
  10. Berapa rata-rata banyak order yang dibuat setiap hari
  11. Berapa rata-rata waktu antara order_date dan shipping_date

</details>

- 👨‍💼 Customer Analysis
  <details><summary><strong>List Pertanyaan</strong></summary>

  1. Berapa jumlah pelanggan per negara
  2. Negara mana yang menghasilkan penjualan tertinggi
  3. Bagaimana distribusi gender pelanggan
  4. Kelompok umur mana yang paling banyak melakukan pembelian
  5. Pelanggan dengan marital_status tertentu (misal married) menghabiskan berapa total belanja
  6. Pelanggan mana yang paling banyak melakukan pembelian
  7. Berapa rata-rata pembelanjaan per pelanggan
  8. Pelanggan mana yang membeli lebih dari 1 kategori produk
  9. Pelanggan mana yang masuk kategori “top 10 spender”
  10. Berapa kontribusi revenue dari 20% pelanggan teratas
  11. Pelanggan mana yang paling sering membeli produk kategori tertentu

</details>

- 📦 Product Analysis
  <details><summary><strong>List Pertanyaan</strong></summary>

  1. Produk mana yang paling menguntungkan (sales_amount – cost)
  2. Produk dengan maintenance = true, menghasilkan berapa revenue
  3. Subkategori mana yang paling laku
  4. Produk mana yang tidak pernah terjual
  5. Produk dengan margin tertinggi berdasarkan kategori
  6. Produk yang memiliki penjualan menurun selama 3 bulan berturut-turut
  7. Produk yang mengalami kenaikan penjualan selama 2 bulan berturut-turut
  8. Produk yang tidak pernah mengalami penurunan dalam 6 bulan terakhir
  9. Identifikasi sub-kategori produk dengan siklus penjualan musiman (seasonality sederhana)
  10. YoY Analisis dari Setiap Category pada tahun 2013 dibandingkan dengan 2012
  11. MoM untuk Bulan Januari 2014 dengan 2013

</details>
   
  Tahap ini berfokus pada pemahaman data secara umum, identifikasi pola, serta penggalian insight awal dari data sebelum dilakukan pemilihan data yang lebih spesifik.
   
### 2. Data Cleaning dan Data Sampling
Setelah tahap eksplorasi, saya melakukan proses data cleaning dan data sampling untuk menyiapkan dataset yang akan digunakan pada tahap analisis dan visualisasi selanjutnya.
Pada tahap ini:

- Data difilter agar hanya mencakup periode tahun 2012–2013
- Menghapus data duplikat dan nilai tidak valid
- Menyeragamkan format data agar konsisten

### 3. Analisis dan Visualisasi menggunakan Excel
Dataset yang telah dibersihkan kemudian diolah menggunakan Microsoft Excel, dengan tujuan:

- Membuat Pivot Table
- Menyusun Dashboard

Tahap ini ditujukan agar hasil analisis mudah dipahami oleh stakeholder dengan latar belakang non-IT.

![Excel Dashboard](assets/Excel%20Dashboard.png)


### 4. Visualisasi Dashboard menggunakan Power BI
Pada tahap ini, data yang telah dianalisis divisualisasikan menggunakan Power BI guna menyajikan informasi dalam bentuk dashboard yang mudah dipahami oleh stakeholder.

- Menampilkan dashboard visual
- Menyajikan insight bisnis secara ringkas dan interaktif
- Mendukung proses pengambilan keputusan berbasis data

![PowerBI Dashboard](assets/PowerBI%20Dashboard.png)
