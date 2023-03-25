use sales;

select * from customers;

select * from date;

select * from markets;

select * from products;

select * from transactions where currency = "USD";

select * from products inner join transactions on products.product_code=transactions.product_code 
inner join customers on products.customer_code=customers.customer_code order by transactions.sales_amount desc;

# Joining customers, products and transactions.
SELECT
  *
FROM transactions
JOIN customers
  ON transactions.customer_code = transactions.customer_code
JOIN products
  ON products.product_code = transactions.product_code order by transactions.sales_amount desc ;
  

# Joining date and transactions tables
select * from transactions inner join date on transactions.order_date = date.date;
select * from transactions inner join date on transactions.order_date = date.date where date.year = 2020 and transactions.sales_amount > 10000;
select sum(transactions.sales_amount) from transactions inner join date on transactions.order_date = date.date where date.year = 2020;


select sum(transactions.sales_amount) from transactions inner join markets on transactions.market_code = markets.markets_code 
inner join date on transactions.order_date = date.date
where markets_name = "Chennai" and date.year = 2020;


# Converting USD to INR
select sales_amount*80 from transactions  where currency = "USD" ;
use sales;
select count(*) from transactions where currency != "INR"; 
select count(*) from transactions where currency = "INR\r"; 

select SUM(sales_amount) from transactions inner join date on date.date = transactions.order_date where date.year = "2020" 
and date.cy_date = "2020-01-01" and transactions.currency = "INR\r" or transactions.currency = "USD\r";  

select distinct(zone) from markets;



