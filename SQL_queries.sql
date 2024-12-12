
---------creating Database-----------------------------------
CREATE DATABASE if not exists walmartsales;
use walmartsales;

--------------------creating Table--------------------------

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


--------------------------------------------------------------------------------------------
------------------------------- Feature Enginering -----------------------------------------------

-- time_of_day------
SELECT time,
       CASE 
           WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
           WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sales;

Alter table sales add column time_of_day varchar(20);

UPDATE sales
SET time_of_day = (
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-------------- day_name------------

select
	date,dayname(date)
		from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name=dayname(date);


----- month_name---
select 
	date,monthname(date)
    from sales;
    
alter table sales add column month_name varchar(10);

update sales 
set month_name=monthname(date);

---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------- Generic ----------------------------------------------------------------------------------

-- How many unique cities does the data have?

select distinct city
from sales;

select distinct branch
from sales;

-- In which city is each branch?

select distinct city, branch
from sales;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------Product----------------------------------------------------------------------------
-- How many unique product lines does the data have?
select 
 count( distinct(product_line)) as Distinct_product
from sales;

-- What is the most common payment method?
select 
payment,count(payment) as count
from sales
group by payment
order by count desc;


-- What is the most selling product line?

 select 
product_line,count(product_line) as count
from sales
group by product_line
order by count desc;

-- What is the total revenue by month?
select 
	month_name as month,sum(total) as Total_revenue
    from sales
    group by month_name 
    order by total_revenue desc;
    
-- What month had the largest COGS?
select month_name as month ,sum(cogs) as cogs
from sales
group by month_name 
order by cogs desc;

-- What product line had the largest revenue?
select product_line,sum(total) as total_revenue
from sales 
group by product_line 
order by total_revenue desc;

-- What is the city with the largest revenue?
select city,sum(total) as Revenue
from sales 
group by city 
order by Revenue desc;

-- What product line had the largest VAT?
select product_line,avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold? 
select branch,sum(quantity) as qty
from sales
group by branch 
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
 select gender,product_line,count(gender) as gnder_cnt
 from sales
 group by gender,product_line 
 order by gnder_cnt;
 
 -- What is the average rating of each product line?
 select product_line,round(avg(rating) ,2) as avg_rating 
 from sales 
 group by product_line
 order by avg_rating desc;
 -- ------------------------------------------------------------------------------------------------------------------------------------
 
 -- Number of sales made in each time of the day per weekday
 select time_of_day ,count(*) as total_sales
 from sales
 where day_name="sunday"
 group by time_of_day;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,avg(tax_pct) as Vat
from sales 
group by city 
order by Vat desc;

-- Which customer type pays the most in VAT?
select customer_type,sum(tax_pct) as Vat
from sales 
group by customer_type
order by Vat;
-- ---------------------------------------------------------------------------------------------------------------------------------------

-- How many unique customer types does the data have?
-- --------------------------------------------------customer----------------------------------------------------------------------------

select distinct(customer_type) 
from sales;

-- How many unique payment methods does the data have?
 
select distinct(payment) 
from sales;

-- What is the most common customer type?
select customer_type,count(customer_type) as cnt_customer 
from sales 
group by customer_type 
order by cnt_customer desc; 

-- Which customer type buys the most?
select  customer_type , count(*) as cst_cnt
from sales
group by customer_type
order by cst_cnt;

-- What is the gender of most of the customers?

select  gender,count(gender) as gender_cnt
from sales
group by gender
order by gender_cnt;

-- What is the gender distribution per branch?
select gender,count(*) as gender_cnt 
from sales 
where branch='c'
group by gender 
order by  gender_cnt ;

select 
    branch,
    gender,
    COUNT(*) AS Count
FROM 
    sales
GROUP BY 
    branch, gender
ORDER BY 
    branch, gender ;
    
-- Which time of the day do customers give most ratings?
select time_of_day,avg(rating) as avg_rating 
from sales
group by time_of_day 
order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch?
select time_of_day,avg(rating) as avg_rating 
from sales
where branch='c'
group by time_of_day 
order by avg_rating desc;

-- Which day fo the week has the best avg ratings? 
select day_name,avg(rating) as avg_rating 
from sales 
group by day_name 
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?
select day_name,avg(rating) as avg_rating 
from sales 
where branch='a'
group by day_name 
order by avg_rating desc;
