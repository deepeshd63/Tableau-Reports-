select * from customer;
select * from date;
select * from geography;
select * from internetsales;
select * from product;
select * from productcategory;
select * from productsubcategory;
 select * from internetsales1;
 
DELETE FROM internetsales1
WHERE order_date < '2021-01-01';

ALTER TABLE internetsales1
DROP COLUMN duedate_key,
DROP COLUMN orderdate_key, drop column shipdate_key;

-- Convert date columns to the proper date format
UPDATE internetsales
SET orderdate = TO_DATE(CAST(orderdatekey AS TEXT), 'YYYYMMDD'),
    duedate = TO_DATE(CAST(duedatekey AS TEXT), 'YYYYMMDD'),
    shipdate = TO_DATE(CAST(shipdatekey AS TEXT), 'YYYYMMDD');



/* 1. Create table name of product data*/

create table product_data as select p.productkey as product_key, p.productalternatekey,  
p.englishproductname as product_name, 
pc.englishproductcategoryname as product_category,  
ps.englishproductsubcategoryname as product_subcategory
from product p join
productsubcategory ps on p.productsubcategorykey = ps.productsubcategorykey
join productcategory pc on ps.productcategorykey = pc.productcategorykey;

select * from product_data;


/*2. Customer Data of geaographyic data*/

create table customer_geography as
select
    c.customerkey as Customer_key, 
    c.customeralternatekey as customer_alternet_key, 
    (c.firstname || ' ' || c.lastname) as customer_name,
    c.maritalstatus,
    case
        when c.gender = 'F' THEN 'Female'
        when c.gender = 'M' THEN 'Male' 
        else '' 
    end as gender,
    c.birthdate, 
    AGE(current_date, c.birthdate) as age, 
    c.emailaddress, 
    c.yearlyincome as Yearly_income,  
    c.totalchildren as total_children,
    c.englisheducation as education,   
    c.englishoccupation as occupation, 
    c.numbercarsowned as number_of_cars_owned, 
    c.addressline1 as address, 
    c.phone as phone_number, 
    c.datefirstpurchase as date_of_first_purchase,   
    g.city, 
    g.stateprovincename as state,  
    g.countryregioncode as country_code,  
    g.englishcountryregionname as country, 
    g.postalcode,  
    g.salesterritorykey as sales_territory
from  
    customer c
join   
    geography g on c.geographykey = g.geographykey;

select * from customer_geography;
select * from customer;

/*3. Join product data and internet sales data Tables*/

create table bike_haven_sales as (
  select a.productkey,a.customerkey, a.totalproductcost::numeric, a.salesamount, a.orderdate::timestamp, 
      a.shipdate::timestamp,  b.productkey as b_productkey,b.product_name, b.product_subcategory,
      (a.salesamount - a.totalproductcost::numeric) as profit, AGE(a.shipdate::timestamp, a.orderdate::timestamp) as shipping_time
 from  internetsales as a
 inner join product_data as b  on
                   a.productkey = b.productkey
 where  a.orderdate >= '2021-01-01' and a.orderdate <= '2023-12-31' );

select * from bike_haven_sales;

-- import the total budget data 
	create table salesbudget ( date date, budget numeric);

-- import the total budget data 
	create table salesbudget ( date date, budget numeric);

copy salesbudget from 'C:\Program Files\PostgreSQL\Data\Copy of SalesBudget.csv' delimiter ',' csv header;

select * from salesbudget;

--4. removing the error of currany and date formet importing internetsales data

CREATE TABLE internetsales1 (
    product_key INT,
    orderdate_key int,
    duedate_key int,
    shipdate_key int,
    customer_key INT,
    promotion_key INT,
    currency_key TEXT,
    salesorder_number TEXT,
    total_product_cost NUMERIC,
    sales_amount NUMERIC,
	order_date date, due_date date, ship_date date
);

copy internetsales1 from 'C:\Program Files\PostgreSQL\Data\internetsaledata1.csv' delimiter ',' csv header;

select * from internetsales1;

DELETE FROM internetsales1
WHERE order_date < '2021-01-01';

ALTER TABLE internetsales1
DROP COLUMN duedate_key,
DROP COLUMN orderdate_key, drop column shipdate_key;

drop table internetsales1;

/* Sales and budget of product */

CREATE TABLE Sale_and_budget AS (SELECT a.order_date, a.due_date,
 a.ship_date, a.product_key, a.customer_key, a.sales_amount,
b.budget AS budget, SUM(a.sales_amount) AS total_sales, b.budget AS total_budget
FROM internetsales1 AS a
INNER JOIN salesbudget AS b ON a.order_date = b.date
WHERE a.order_date >= '2021-01-01' AND a.order_date <= '2023-12-31'
GROUP BY a.order_date, a.due_date,
        	a.ship_date, a.product_key,
        	a.customer_key, a.sales_amount, b.budget);
			
select * from Sale_and_budget;


	
	
	
	
	
	
	
	
	
	
	
	
	
	
/* Calculate total sales amount for each order
SELECT orderdate, SUM(salesamount) AS total_sales
FROM internetsales
GROUP BY orderdate;

-- Query to retrieve budget data from SalesBudget table
SELECT date, budget
FROM SalesBudget;

-- Join the sales data with the budget data to compare sales vs budget
SELECT s.order_date AS sales_date,
SUM(s.sales_amount) AS total_sales,
b.budget AS total_budget
FROM internetsales1 s
JOIN Salesbudget b ON s.order_date = b.date
GROUP BY s.order_date, b.budget;*/


	














