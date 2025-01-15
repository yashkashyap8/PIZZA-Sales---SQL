create database pizzahut;
use pizzahut;


# Retrieve the total number of orders placed.
select
	count(*) as 'TOTAL orders'
from
	orders;


# Calculate the total revenue generated from pizza sales.

select
	round(sum(order_details.quantity * pizzas.price), 2) as 'Total Sales'
from
	order_details
join pizzas 
on
	order_details.pizza_id = pizzas.pizza_id;

# Identify the highest-priced pizza.
select
	name,
	price
from
	pizzas p1
join pizza_types p2
on
	p1.pizza_type_id = p2.pizza_type_id
order by
	p1.price desc
limit 1;

# Show number of Pizza ordered as per their size. 
select
	o2.size as 'Size of Pizza' ,
	count(o2.size) as 'Total Pizza Ordered'
from
	order_details o1
join pizzas o2 
on
	o1.pizza_id = o2.pizza_id
group by
	o2.size
order by
	o2.size desc;

# List the top 5 most ordered pizza types along with their quantities.
select
	p3.name ,
	sum(p1.quantity) as 'Total quantity ordered'
from
	order_details p1
join pizzas p2 
on
	p1.pizza_id = p2.pizza_id
join pizza_types p3 
on
	p3.pizza_type_id = p2.pizza_type_id
group by
	p3.name
order by
	sum(p1.quantity) desc
limit 5;

# Join the necessary tables to find the total quantity of each pizza category ordered.
select
	p3.category ,
	sum(p1.quantity) as 'Total quantity'
from
	order_details p1
join pizzas p2 
on
	p1.pizza_id = p2.pizza_id
join pizza_types p3 
on
	p2.pizza_type_id = p3.pizza_type_id
group by
	p3.category;

# Determine the distribution of orders by hour of the day.

select
	hour(time1) ,
	count(order_id)
from
	orders
group by
	hour(time1)
order by
	hour(time1);

# Join relevant tables to find the category-wise distribution of pizzas.
select
	category ,
	count(name) as 'Number of pizzas'
from
	pizza_types
group by
	category;

# Group the orders by date and calculate the average number of pizzas ordered per day.
select
	round(avg(pwd.quant), 0) as 'Average pizza ordered per day'
from
	(
	select
		date(date1) as 'Date' ,
		sum(o2.quantity) as 'quant'
	from
		orders o1
	join order_details o2
on
		o1.order_id = o2.order_id
	group by
		date(date1)) as pwd;



# Determine the top 3 most ordered pizza types based on revenue.
select
	o3.name ,
	round(sum(o1.quantity * o2.price), 2) as 'Total Sales'
from
	order_details o1
join pizzas o2 
on
	o1.pizza_id = o2.pizza_id
join pizza_types o3 on
	o2.pizza_type_id = o3.pizza_type_id
group by
	o3.name
order by
	round(sum(o1.quantity * o2.price), 2) desc
limit 3;


# Calculate the percentage contribution of each pizza type to total revenue.
select
	p1.category ,
	round((sum(p3.quantity * p2.price)) / (select sum(order_details.quantity * pizzas.price) from order_details join pizzas 
on
	order_details.pizza_id = pizzas.pizza_id), 4)* 100
as revenue
from
	pizza_types p1
join pizzas p2 
on
	p1.pizza_type_id = p2.pizza_type_id
join order_details p3 
on
	p3.pizza_id = p2.pizza_id
group by
	p1.category;


# Analyze the cumulative revenue generated over time.
select date1 , round(sum(rev) over(order by date1),2) as 'cum rev'
from 
(select orders.date1 ,
	sum(order_details.quantity * pizzas.price) as 'rev'
from
	order_details
join pizzas 
on
	order_details.pizza_id = pizzas.pizza_id join orders on orders.order_id = order_details.order_id
group by orders.date1) as sales ;

# Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, category, rev 
from
(select 
name, category, rev, rank() over(partition by category order by rev desc) as alpha
from 
(select
	p3.name ,
	p3.category,
	sum(p1.quantity * p4.price) as rev
from
	pizza_types p3
join pizzas p4 on
	p3.pizza_type_id = p4.pizza_type_id
join order_details p1 on
	p1.pizza_id = p4.pizza_id
group by
	p3.name ,
	p3.category) as abcd) as bcd
where bcd.alpha in (1,2,3);





select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

