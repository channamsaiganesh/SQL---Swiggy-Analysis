-- Data Validation & Cleaning
-- Null Check
select
	sum(case when state is null then 1 else 0 end) as null_state,
    sum(case when city is null then 1 else 0 end) as null_city,
    sum(case when order_date is null then 1 else 0 end) as null_order_date,
    sum(case when restaurant_name is null then 1 else 0 end) as null_restaurant_name,
    sum(case when location is null then 1 else 0 end) as null_location,
    sum(case when category is null then 1 else 0 end) as null_category,
    sum(case when dish_name is null then 1 else 0 end) as null_dish_name,
    sum(case when price_INR is null then 1 else 0 end) as null_price_INR,
    sum(case when rating is null then 1 else 0 end) as null_rating,
    sum(case when rating_count is null then 1 else 0 end) as null_rating_count
from swiggy_data;

-- Check for Blanks(only works on dimentions)
select * from swiggy_data 
where state ='' or city ='' or restaurant_name ='' or location ='' or category ='' or dish_name ='';

-- Duplicate Detection
select state, city, order_date, restaurant_name, location,
category, dish_name, price_inr, rating, rating_count, count(*) as CNT
from swiggy_data
group by state, city, order_date, restaurant_name, location,
category, dish_name, price_inr, rating, rating_count
having CNT>1;

-- Deleteing the duplicates
with CTE as(
select *, row_number() over(partition by state, city, order_date, restaurant_name, location,
category, dish_name, price_inr, rating, rating_count) as rn
from swiggy_data
)
delete from CTE where rn>1;


-- ***SCHEMA CREATION*******
-- Dimention Tables

-- 1.Date Table
Create table dim_date(
	date_id int auto_increment primary key,
    full_date date,
    year int,
    month int,
    month_name varchar(20),
    Quarter int,
    day int,
    week int
);
select * from dim_date;

-- 2. loaction table
create table dim_location(
	location_id int auto_increment primary key,
    state varchar(100),
    city varchar(100),
    location varchar(200)
);
select * from dim_location;
 
 -- 3. Restaurant Table
 create table dim_restaurant(
	Restaurant_id int auto_increment primary key,
    Restaurant_name varchar(200)
);
select * from dim_restaurant;

 -- 4. Category Table
 create table dim_category(
	Category_id int auto_increment primary key,
    Category varchar(200)
);
select * from dim_category;

-- 5. Dish Table
 create table dim_Dish(
	Dish_id int auto_increment primary key,
    Dish_name varchar(200)
);
select * from dim_dish;

-- Fact Table
create table fact_swiggy_orders(
	order_id int auto_increment primary key,
    
    Date_id int,
    Price_INR decimal(10,2),
    Rating decimal(4,2),
    Rating_count int,
    
    location_id int,
    restaurant_id int,
    category_id int,
    dish_id int,
    
    foreign key(date_id) references dim_date(date_id),
    foreign key(location_id) references dim_location(location_id),
    foreign key(restaurant_id) references dim_restaurant(restaurant_id),
    foreign key(category_id) references dim_category(category_id),
    foreign key(dish_id) references dim_dish(dish_id)
    );
    
    select * from fact_swiggy_orders;
    select count(*) from fact_swiggy_orders;
    
    -- INSERTING DATA INTO THE TABLES
    -- 1. Dimention Date table
    insert into dim_date(full_date,year,month,month_name,quarter,day,week)
    select distinct
		order_date,
        year(order_date),
        month(order_date),
        monthname(order_date),
        quarter(order_date),
        day(order_date),
        week(order_date)
	from swiggy_data
    where order_date is not null;
    
    -- 2. Dimention Location table
    insert into dim_location(state,city,location)
    select distinct
		state,
        city,
        location
	from swiggy_data;
    
    -- 3. Dimention Restaurant table
    insert into dim_restaurant(restaurant_name)
    select distinct
		restaurant_name
	from swiggy_data;
    
    -- 4. Dimention Dish table
    insert into dim_dish(dish_name)
    select distinct
		dish_name
	from swiggy_data;
    
    -- 5. Dimention Category table
    insert into dim_category(category)
    select distinct
		category
	from swiggy_data;
    
    -- FACT table
    insert into fact_swiggy_orders
    (
    date_id,
    price_INR,
    rating,
    rating_count,
    location_id,
    restaurant_id,
    category_id,
    dish_id
    )
    select 
		dd.date_id,
        s.price_INR,
        s.rating,
        s.rating_count,
        dl.location_id,
        dr.restaurant_id,
        dc.category_id,
        dsh.dish_id
	from swiggy_data as s
    
    join dim_date as dd
    on dd.full_date = s.order_date
    
    join dim_location as dl
    on dl.state = s.state
    and dl.city = s.city
    and dl.location = s.location
    
    join dim_restaurant as dr
    on dr.restaurant_name = s.restaurant_name
    
    join dim_category as dc
    on dc.category = s.category
    
    join dim_dish as dsh
    on dsh.dish_name = s.dish_name;
    
    -- To Select all the Dimention data and Fact data Together
    select * from fact_swiggy_orders f
    join dim_date d on f.date_id=d.date_id
    join dim_location l on f.location_id=l.location_id
    join dim_restaurant r on f.restaurant_id=r.restaurant_id
    join dim_category c on f.category_id=c.category_id
    join dim_dish di on f.dish_id=di.dish_id;
    
    
-- KPI's 
-- Total Orders
select count(*) as Total_Orders
from fact_swiggy_orders;

-- Total Revenue
select sum(price_INR) as Total_Revenue
from fact_swiggy_orders;

-- Average Dish Price
select avg(price_INR) as Average_dish_price
from fact_swiggy_orders;

-- Average Rating
select avg(rating) as Average_Rating
from fact_swiggy_orders;

-- Deep Dive Business Analysis
-- Monthly Order Trends
select d.year,d.month,d.month_name,count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id=d.date_id
group by d.year,d.month,d.month_name;

-- Monthly Revenue
select d.year,d.month,d.month_name,sum(price_INR) as Total_Revenue
from fact_swiggy_orders f
join dim_date d
on f.date_id=d.date_id
group by d.year,d.month,d.month_name;

-- Quaterly Trend
select d.year,d.quarter,count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id=d.date_id
group by d.year,d.quarter;

-- Yearly Trend
select d.year,count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id=d.date_id
group by d.year;

-- Orders by Day of Week(Mon-Sun)
select weekday(d.full_date) as day_name,count(*) as total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id=d.date_id
group by day_name;

-- Top 10 cities by order volume
select l.city,count(*) as total_orders
from fact_swiggy_orders f
join dim_location l
on f.location_id = l.location_id
group by l.city
order by count(*) desc
limit 10;

-- Top 10 cities by Revenue
select l.city,sum(f.price_INR) as Total_Revenue
from fact_swiggy_orders f
join dim_location l
on f.location_id = l.location_id
group by l.city
order by count(*) desc
limit 10;

-- Revenue contribution by states
select l.state,sum(f.price_INR) as Total_Revenue
from fact_swiggy_orders f
join dim_location l
on f.location_id = l.location_id
group by l.state
order by count(*) desc;

-- Top 10 Restaurants by orders
select r.restaurant_name,count(*) as Total_orders
from fact_swiggy_orders f
join dim_restaurant r
on f.restaurant_id=r.restaurant_id
group by r.restaurant_name
order by count(*) desc
limit 10;

-- Top 10 Restaurants by Revenue
select r.restaurant_name,sum(f.price_INR) as Total_Revenue
from fact_swiggy_orders f
join dim_restaurant r
on f.restaurant_id=r.restaurant_id
group by r.restaurant_name
order by total_revenue desc
limit 10;

-- Most Ordered Dishes
select d.dish_name,count(*) as Total_orders
from fact_swiggy_orders f
join dim_dish d
on f.dish_id=d.dish_id
group by d.dish_name
order by count(*) desc;

-- Top categories
select c.category,count(*) as Total_orders
from fact_swiggy_orders f
join dim_category c
on f.category_id=c.category_id
group by c.category
order by count(*) desc
LIMIT 10;

-- category performance(orders + avg rating)
select c.category,
count(*) as Total_orders,
avg(f.rating) as avg_rating
from fact_swiggy_orders f
join dim_category c
on f.category_id=c.category_id
group by c.category
order by count(*) desc
LIMIT 10;

-- Total Orders by Price Range
SELECT
    CASE
        WHEN CAST(price_inr AS DECIMAL(10,2)) < 100 THEN 'Under 100'
        WHEN CAST(price_inr AS DECIMAL(10,2)) BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN CAST(price_inr AS DECIMAL(10,2)) BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN CAST(price_inr AS DECIMAL(10,2)) BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END AS price_range,
    COUNT(*) AS total_orders
FROM fact_swiggy_orders
GROUP BY
    CASE
        WHEN CAST(price_inr AS DECIMAL(10,2)) < 100 THEN 'Under 100'
        WHEN CAST(price_inr AS DECIMAL(10,2)) BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN CAST(price_inr AS DECIMAL(10,2)) BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN CAST(price_inr AS DECIMAL(10,2)) BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END
ORDER BY total_orders DESC;

-- Rating Count Distribution(1-5)
select rating,count(*) as rating_count
from fact_swiggy_orders
group by rating
order by count(*) desc;