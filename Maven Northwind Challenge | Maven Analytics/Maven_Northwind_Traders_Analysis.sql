CREATE DATABASE northwind_traders_analysis;

USE northwind_traders_analysis;

select * from catergories;

select * from customers;

select * from employees;

select * from orders;

select * from order_details;

select * from products;

select * from shippers;



### No.of Orders for each Shippers Company ###
SELECT a.CompanyName, count(c.OrderID) Orders
FROM shippers a 
JOIN orders b
JOIN order_details c
ON a.shipperID = b.shipperID AND b.orderID = c.orderID
GROUP BY companyname
ORDER BY Orders DESC;



### No.of Customers of each Shippers Company ###
SELECT a.CompanyName, count(distinct(b.CustomerID)) Orders
FROM shippers a 
JOIN orders b
ON a.shipperID = b.shipperID
GROUP BY companyname
ORDER BY Orders DESC;



### AVG Shipping Cost By each Shippers Company ###
SELECT a.CompanyName, CONCAT("$"," ", ROUND(AVG(b.freight),2)) AVG_Freight
FROM shippers a
JOIN orders b
ON a.shipperID = b.shipperID
GROUP BY companyname
ORDER BY AVG_Freight DESC;

### Shipping_Company Sales ###
SELECT (e.companyName) as Shipping_CompanyName, FORMAT((SUM(b.unitprice) * SUM(b.quantity)),0) as Sales
FROM order_details b
JOIN orders c
JOIN shippers e
ON b.orderID = c.orderID AND c.shipperID = e.shipperID
GROUP BY e.companyName
ORDER BY Sales DESC;



select * from order_details;
select * from products;
select * from customers;
select * from orders;
select * from shippers;

SELECT (d.CompanyName) Customer_CompanyName, a.productname, a.quantityperunit, 
CONCAT("$"," " , ROUND((b.unitprice * b.quantity),2)) as Price, (e.companyName) as Shipping_CompanyName
from products a
join order_details b
JOIN orders c
JOIN customers d
JOIN shippers e
on a.productID = b.productID AND b.orderID = c.orderID AND c.customerID = d.customerID AND c.shipperID = e.shipperID;



SELECT (d.CompanyName) Customer_CompanyName, 
FORMAT((SUM(b.unitprice) * SUM(b.quantity)),0) as Amount_Spend
from products a
join order_details b
JOIN orders c
JOIN customers d
JOIN shippers e
on a.productID = b.productID AND b.orderID = c.orderID AND c.customerID = d.customerID AND c.shipperID = e.shipperID
GROUP BY d.CompanyName
ORDER BY Amount_Spend DESC;

select e.categoryname, e.Category_wise_orders, FORMAT(SUM(d.Price),0) as Amount_Spend
FROM
(SELECT a.categoryname, count(b.orderid) as Category_wise_orders
FROM catergories a
JOIN order_details b
JOIN products c
ON a.categoryid = c.categoryid AND c.productid = b.productid
GROUP BY a.categoryname
ORDER BY Category_wise_orders DESC)e
JOIN
(SELECT ((unitprice - (unitprice * discount)) * quantity) as Price
	FROM order_details) d  GROUP BY categoryname;


SELECT FORMAT(SUM(a.Price),0)
FROM
	(SELECT ((unitprice - (unitprice * discount)) * quantity) as Price
	FROM order_details) a;


