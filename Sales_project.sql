Select * from sales_db;

select count(*) from sales_db;

-- 1. To find distinct Payment Types and how many payments made from each

select 
	payment_method,
	count(payment_method) as number_of_transactions,
	sum(quantity) as number_of_items_sold
from sales_db
group by 
	payment_method;

-- 2. To find total number of stores

select
	distinct branch,
	count(branch) as number_of_branches
from sales_db
group by
	branch;

-- 3. To find maximum profit margin per branch

Select 
	distinct branch,
	profit_margin
from sales_db
order by
	profit_margin desc;

-- 4. Identifying highest rated category in each branch, displaying the branch, category and avg rating

with cte1 as (
select
	branch,
	category,
	avg(rating) as average_rating,
	rank() over(partition by branch order by avg(rating) desc) as rank
from sales_db
group by
	branch, category)
select *
from cte1
where rank = 1;

-- 5. Identify day with highest number of sales for each branch

select * from
(select
	branch,
	to_char(to_date(date,'DD/MM/YYYY'), 'day') as name_day,
	count(*) as number_of_transactions,
	rank() over(partition by branch order by count(*) desc) as day_rank
from sales_db
group by branch, name_day)
where day_rank = 1;

/* 6. To determine the average, minimum and maximum rating of category for each city.
List the city, category, average rating, minimum rating and maximum rating */

select
	city,
	category,
	max(rating) as max_rating,
	min(rating) as min_rating,
	avg(rating) as average_rating
from sales_db
group by
	city, category
order by
	average_rating desc;

-- 7. Calculate total profit for each category. List category and total profit in descending order.

select
	category,
	sum(total_cost * profit_margin) as total_profit
from sales_db
group by 
	category
order by
	total_profit desc;

-- 8. Determine the most common payment method for each branch. Also display branch and preferred pament method.

select * from 
(select
	branch,
	payment_method,
	count(*) as total_transactions,
	rank() over(partition by branch order by count(*) desc) as rank
from sales_db
group by branch, payment_method)
where rank = 1;

-- 9. Categorise the sales into 3 groups morning, afternoon, evening. Find the shift having maximum invoices.

