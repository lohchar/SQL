USE blinkitdb;
select * from blinkit_grocery_data;

-- confirm if all rows has been imported
select count(*) from blinkit_grocery_data;

-- DATA CLEANING
-- Replace LF with Low Fat & reg with Regular
UPDATE blinkit_grocery_data
SET `Item Fat Content` =
CASE 
	WHEN `Item Fat Content` IN ('LF', 'low fat') THEN 'Low Fat'
	WHEN `Item Fat Content` = 'reg' THEN 'Regular'
	ELSE `Item Fat Content`
END;

-- check categories in `Item Fat Content` column
select distinct(`Item Fat Content`) from blinkit_grocery_data;

-- calculate total sales -used cast to change to decimal -used concat to add 'M' at end of answer
select concat(cast(sum(`Total Sales`)/1000000 as decimal(10,2)),'M') as Total_sales_millions from blinkit_grocery_data;

-- calculate Average sales
select cast(AVG(`Total Sales`) as decimal(10,2)) as Average_Sales from blinkit_grocery_data;

-- calculate of number of items
select count(*) as No_of_items from blinkit_grocery_data
where `Outlet Establishment Year` = 2022;

-- calculate total sales for low fat
select sum(`Total Sales`) as total_low_sales from blinkit_grocery_data 
where `Item Fat Content` = 'Low Fat';

-- calculate average rating 
select CAST(AVG(Rating) as DECIMAL (10,2)) as Average_Rating from blinkit_grocery_data;

-- total sales by fat content (also for Average sales,number of items,average rating)
select (`Item Fat Content`),
		cast(sum(`Total Sales`) as decimal (10,2)) as Total_sales,
		cast(AVG(`Total Sales`) as decimal(10,2)) as Avg_Sales,
		count(*) as No_of_items,
		CAST(AVG(Rating) as DECIMAL (10,2)) as Avg_Rating
from blinkit_grocery_data
group by `Item Fat Content`
order by Total_sales DESC;

-- calculate total sales by item type(also for Average sales,number of items,average rating)
select `Item Type`,
		cast(sum(`Total Sales`) as decimal (10,2)) as Total_sales,
		cast(AVG(`Total Sales`) as decimal(10,2)) as Avg_Sales,
		count(*) as No_of_items,
		CAST(AVG(Rating) as DECIMAL (10,2)) as Avg_Rating
from blinkit_grocery_data
group by `Item Type`
order by Total_sales desc
limit 5; -- to provide top 5 results

-- calculate fat content by outlet for total sales
select `Outlet Location Type`, `Item Fat Content`,
		cast(sum(`Total Sales`) as decimal (10,2)) as Total_sales,
		cast(AVG(`Total Sales`) as decimal(10,2)) as Avg_Sales,
		count(*) as No_of_items,
		CAST(AVG(Rating) as DECIMAL (10,2)) as Avg_Rating
from blinkit_grocery_data
group by `Outlet Location Type`,`Item Fat Content`
order by `Outlet Location Type`, Total_sales desc;
-- Alternative method 
SELECT 
    `Outlet Location Type`,
    COALESCE(SUM(CASE WHEN `Item Fat Content` = 'Low Fat' THEN `Total Sales` ELSE 0 END), 0) AS Low_Fat,
    COALESCE(SUM(CASE WHEN `Item Fat Content` = 'Regular' THEN `Total Sales` ELSE 0 END), 0) AS Regular
FROM 
    blinkit_grocery_data
GROUP BY 
    `Outlet Location Type`
ORDER BY 
    `Outlet Location Type`;

-- calculate total sales by outlet establishment (also for avg sales, no. of items, avg rating)
select `Outlet Establishment Year`, 
		cast(sum(`Total Sales`) as decimal(10,2))as Total_sales,
		cast(AVG(`Total Sales`) as decimal(10,2)) as Avg_Sales,
		count(*) as No_of_items,
		CAST(AVG(Rating) as DECIMAL (10,2)) as Avg_Rating
from blinkit_grocery_data
group by `Outlet Establishment Year`
order by Total_sales desc;

-- Percentage of sales by outlet size
select `Outlet Size`,
		cast(sum(`Total Sales`) as decimal(10,2)) as Total_sales,
		cast(sum(`Total Sales`)/(select sum(`Total Sales`) from blinkit_grocery_data) * 100 as decimal(10, 2)) as sales_percentage
from blinkit_grocery_data
group by `Outlet Size`
order by total_sales desc;

-- Sales by Outlet Location (Avg sales, no. of items, Avg Rating)
select `Outlet Location Type`,
		cast(sum(`Total Sales`) as decimal(10,2)) as Total_sales,
		cast(AVG(`Total Sales`) as decimal(10,2)) as Avg_Sales,
		count(*) as No_of_items,
		CAST(AVG(Rating) as DECIMAL (10,2)) as Avg_Rating
from blinkit_grocery_data
group by `Outlet Location Type`
order by Total_sales desc;

-- All metrics by Outlet type
select `Outlet Type`,
		cast(sum(`Total Sales`) as decimal(10,2)) as Total_sales,
		cast(sum(`Total Sales`)/(select sum(`Total Sales`) from blinkit_grocery_data) * 100 as decimal(10, 2)) as sales_percentage,
		cast(AVG(`Total Sales`) as decimal(10,2)) as Avg_Sales,
		count(*) as No_of_items,
		CAST(AVG(Rating) as DECIMAL (10,2)) as Avg_Rating
from blinkit_grocery_data
group by `Outlet Type`
order by Total_sales desc;
