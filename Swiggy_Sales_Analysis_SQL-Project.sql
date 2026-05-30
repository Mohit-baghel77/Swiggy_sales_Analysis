SELECT * FROM swiggy_data;

--null check
select
 sum(case when state is null then 1 else 0 end) as null_state,
 sum(case when city is null then 1 else 0 end) as null_city,
 sum(case when order_date is null then 1 else 0 end) as null_date,
 sum(case when restaurant_name is null then 1 else 0 end) as null_restaurant,
 sum(case when location is null then 1 else 0 end) as null_location,
 sum(case when category is null then 1 else 0 end) as null_category,
 sum(case when dish_name is null then 1 else 0 end) as null_dish,
 sum(case when price_inr is null then 1 else 0 end) as null_price,
 sum(case when rating is null then 1 else 0 end) as null_rating,
 sum(case when rating_count is null then 1 else 0 end) as null_rating_count
 
 from swiggy_data;

 SELECT

COUNT(*) FILTER (WHERE state IS NULL) AS null_state,

COUNT(*) FILTER (WHERE city IS NULL) AS null_city,

COUNT(*) FILTER (WHERE order_date IS NULL) AS null_date,

COUNT(*) FILTER (WHERE restaurant_name IS NULL) AS null_restaurant,

COUNT(*) FILTER (WHERE location IS NULL) AS null_location,

COUNT(*) FILTER (WHERE category IS NULL) AS null_category,

COUNT(*) FILTER (WHERE dish_name IS NULL) AS null_dish,

COUNT(*) FILTER (WHERE price_inr IS NULL) AS null_price,

COUNT(*) FILTER (WHERE rating IS NULL) AS null_rating,

COUNT(*) FILTER (WHERE rating_count IS NULL) AS null_rating_count

FROM swiggy_data;


---delete null values
DELETE FROM swiggy_data
WHERE state IS NULL
OR city IS NULL
OR order_date IS NULL
OR restaurant_name IS NULL
OR location IS NULL
OR category IS NULL
OR dish_name IS NULL
OR price_inr IS NULL
OR rating IS NULL
OR rating_count IS NULL;

--blank and empty
select * from swiggy_data
 where state ='' OR city='' OR restaurant_name='' OR location=''
 OR category='' OR dish_name='';

 ---Remove Duplicates 
 with cte as(
 select *, row_number() 
 over(partition by state,city, order_date, restaurant_name, location, category,
 dish_name, price_inr, rating, rating_count order by order_date ) as rn
 from swiggy_data
 )
 delete from swiggy_data
 where order_date in(
 select order_date from cte
 where rn>1);


 --Create shecma
 --Create Diminsion table
 --Create Fact table

--date diminsion table
 create table d_date(
   date_id serial primary key,
   full_date date,
   year int,
   month int,
   month_name varchar(20),
   quarter int,
   week int,
   day int
   );

 select * from d_date;

insert into d_date(full_date,year,month,month_name,quarter,week,day)
select distinct
   order_date,
   extract(year from order_date),
   extract(month from order_date),
   to_char(order_date,'FMMonth'),
   extract(quarter from order_date),
   extract( week from order_date),
   extract(day from order_date)
   from swiggy_data
   where order_date is not null;



   
 --location diminsion table

SELECT * FROM swiggy_data;

 create table d_location(
   location_id serial primary key,
    state varchar(100),
	city varchar(100),
	location varchar(200)
    );

INSERT INTO d_location(state, city, location)

SELECT DISTINCT
state,
city,
location

FROM swiggy_data;

select * from d_location;
--Dim restaurant

Create table d_restaurant(
  restaurant_id serial primary key,
 restaurant_name varchar(200)
  
);

INSERT INTO d_restaurant(restaurant_name)

SELECT DISTINCT
restaurant_name

FROM swiggy_data;
select * from d_restaurant;

--Dim Category
drop table if exists d_category ;
Create  table d_category(
Category_id serial primary key,
category_name varchar(200)
);
INSERT INTO d_category(category_name)

SELECT DISTINCT
category

FROM swiggy_data;

select * from d_category;

--Dim Dish
Create Table Dim_Dish(
Dish_id serial primary key,
Dish_Name varchar(200)
);
INSERT INTO dim_dish(dish_name)

SELECT DISTINCT
dish_name

FROM swiggy_data;

select * from Dim_Dish;
select * from swiggy_data;

--Fact table
create table fact_table_swiggy(
  order_id serial primary key,
  date_id int,
  price_inr decimal(10,2),
  rating decimal(4,2),
  rating_count decimal(5,2),

  location_id int,
  restaurant_id int,
  Category_id int,
  Dish_id int,

  foreign key(date_id) references d_date(date_id),
  foreign key (location_id) references d_location(location_id),
  foreign key(restaurant_id) references d_restaurant(restaurant_id),
  foreign key(Category_id) references d_category(Category_id),
  foreign key(Dish_id) references Dim_Dish(Dish_id)
  
);
select * from fact_table_swiggy;	 

--insert values in fact table

insert into fact_table_swiggy(
  date_id,
  price_inr,
  rating,
  rating_count,

  location_id,
  restaurant_id,
  Category_id,
  Dish_id
  )
  select
  dd.date_id,
  s.price_inr,
  s.rating,
  s.rating_count,

  dl.location_id,
  dr.restaurant_id,
  dc.Category_id,
  di.Dish_id
from swiggy_data s

join d_date dd on dd.full_date = s.order_date
join d_location dl on dl.state=s.state and dl.city=s.city and dl.location=s.location
join d_restaurant dr on dr.restaurant_name=s.restaurant_name
join d_category dc on dc.category_name = s.category
join Dim_Dish di on di.Dish_Name=s.Dish_Name


 select *from fact_table_swiggy f
join d_date d on f.date_id = d.date_id
join d_location l on f.location_id=l.location_id
join d_restaurant r on f.restaurant_id=r.restaurant_id
join d_category c on f.Category_id= c.Category_id
join Dim_Dish i on f.Dish_id=i.Dish_id


SELECT *
FROM fact_table_swiggy f

LEFT JOIN d_date d
ON f.date_id = d.date_id

LEFT JOIN d_location l
ON f.location_id = l.location_id

LEFT JOIN d_restaurant r
ON f.restaurant_id = r.restaurant_id

LEFT JOIN d_category c
ON f.category_id = c.category_id

LEFT JOIN dim_dish i
ON f.dish_id = i.dish_id;

SELECT * FROM swiggy_data;

---KPIs
--Total Orders
select count(distinct order_id) as total_Orders
from fact_table_swiggy;

--Revenue IN MILLION
select 
floor(sum(f.price_inr)/1000000)|| ' MILLION_INR' as Revenue_Million from fact_table_swiggy f;


--Average Dish Price
select floor(avg(price_inr)) ||' INR' as Average_Dish_Price from fact_table_swiggy;

--Average rating
select floor(avg(rating)) ||' INR' as Average_Rating from fact_table_swiggy;

--Monthly Orders Trends
select d.Year,d.Month,d.Month_Name,count(*) as "Monthly Orders"
from fact_table_swiggy f
join d_date d ON f.date_id=d.date_id
group by d.Year,d.Month,d.Month_Name;

--Monthly Orders Revenue
select d.Year,d.Month,d.Month_Name,round(sum(Price_INR)/1000000,2)|| ' INR Milliom' as "Monthly Revenue"
from fact_table_swiggy f
join d_date d ON f.date_id=d.date_id
group by d.Year,d.Month,d.Month_Name;

