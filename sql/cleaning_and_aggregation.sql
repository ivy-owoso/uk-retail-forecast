CREATE DATABASE IF NOT EXISTS retail_forecast;

USE retail_forecast;
CREATE TABLE raw_online_retail (
	Invoice VARCHAR(20),
	StockCode VARCHAR(20),
	Description VARCHAR(255),
	Quantity INT,
	InvoiceDate DATETIME,
	Price DECIMAL(10,3),
	`Customer ID` INT NULL,
	Country VARCHAR(100)
);

SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS `year_month`,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    COUNT(DISTINCT Invoice) AS total_orders,
    COUNT(DISTINCT `Customer ID`) AS active_customers,
    ROUND(SUM(Quantity * Price)/COUNT(DISTINCT Invoice), 2) AS avg_order_value
FROM raw_online_retail
WHERE Invoice NOT LIKE 'C%'
  AND Quantity>0
  AND Price>0
  AND Country='United Kingdom'
  AND StockCode NOT IN ('POST','DOT','M','C2','BANK CHARGES','ADJUST','ADJUST2','AMAZONFEE','TEST001','TEST002','B','D','S')
  AND StockCode NOT LIKE 'GIFT%'
  AND InvoiceDate>='2009-12-01'
  AND InvoiceDate<'2011-12-01'
GROUP BY `year_month`
ORDER BY `year_month`;