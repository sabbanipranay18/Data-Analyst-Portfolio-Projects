create database pizza_analysis;

use pizza_analysis;

# Imported Data from CSV file
select * from order_details;


# Imported Data from CSV file in TEXT and INT datatypes
SELECT * FROM orders;

# ALTERING datatypes of DATE and TIME columns
ALTER TABLE orders MODIFY column date DATE;
ALTER TABLE orders MODIFY COLUMN time TIME;



# Making "order_id" column in orders TABLE as Primary Key
ALTER TABLE orders MODIFY COLUMN order_id int primary key;

# Making "order_id" column in order_details TABLE as Foreign Key
ALTER TABLE order_details ADD foreign key(order_id) references orders(order_id);

# Joining "Orders" and "Order_Details" Tables...
select o.*, od.* from orders o
JOIN order_details od ON o.order_id = od.order_id;



# Making "pizza_id" column in pizzas TABLE as Primary Key
ALTER TABLE pizzas MODIFY COLUMN pizza_id varchar(50) primary key;

ALTER TABLE order_details MODIFY COLUMN pizza_id varchar(50);

# Making "pizza_id" column in Orders_Details TABLE as Foreign Key
ALTER TABLE order_details ADD foreign key(pizza_id) references pizzas(pizza_id);

# Joining "Pizzas" and "Order_Details" Tables...
SELECT p.*, od.* FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id;




ALTER TABLE pizza_types MODIFY COLUMN pizza_type_id varchar(50);
ALTER TABLE pizzas MODIFY COLUMN pizza_type_id varchar(50);

# Making "pizza_type_id" column in "pizza_types" TABLE as Primary Key
ALTER TABLE pizza_types MODIFY COLUMN pizza_type_id varchar(50) primary key;

# Making "pizza_type_id" column in "Pizzas" TABLE as Foreign Key
ALTER TABLE pizzas ADD foreign key(pizza_type_id) references pizza_types(pizza_type_id);

# Joining "Pizza_Types" and "Pizzas" Tables...
SELECT PT.*, P.* FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id;


# 
SELECT size, sum(price) 
FROM pizzas
GROUP BY size;


SELECT * FROM pizzas;

SELECT * FROM pizza_types;

SELECT * FROM orders;

SELECT * FROM order_details;

select order_id, sum(quantity) as quantity from order_details group by order_id order by quantity desc;
select pizza_id, count(pizza_id), sum(quantity) from order_details group by pizza_id;