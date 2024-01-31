create database my;
use my;

create table sheet1
 (restaurantid int,
 restaurantname varchar(255),
 country_code varchar(10),
 city varchar(255),
Cuisines varchar(255) ,
Currency varchar(255) ,
Has_Table_booking varchar(255) ,
Has_Online_delivery varchar(255) ,
Price_range varchar(255),
 Votes varchar(255) ,
 Average_Cost_for_two varchar(255) ,
 Rating varchar(255) ,
 Datekey_Opening varchar(255));
 
 select * from sheet1;
 select * from rate ;
 select * from country;
 alter table sheet1  modify column datekey_opening date ;
 select count(*) from sheet1;
 
 -- kpi 2 Build a Calendar Table using the Columns Datekey_Opening 
   -- A.Year B.Monthno C.Monthfullname D.Quarter(Q1,Q2,Q3,Q4) E. YearMonth ( YYYY-MMM) F. Weekdayno
   -- G.Weekdayname H.FinancialMOnth ( April = FM1, May= FM2  …. March = FM12)
   -- I. Financial Quarter ( Quarters based on Financial Month FQ-1 . FQ-2..)
   select date(datekey_opening) as dates,
   year(datekey_opening) as years ,
   month(datekey_opening) as monthno,
   monthname(datekey_opening) as monthnames, 
   concat('Q',quarter(datekey_opening))as quarters ,
   date_format(datekey_opening,'%Y-%b')as yearmonth,
   dayofweek(datekey_opening) as weekdayno,
   dayname(datekey_opening) as day,
   CASE 
when month(Datekey_Opening) = 4 then "FM1"
when month(Datekey_Opening) = 5 then "FM2"
when month(Datekey_Opening) = 6 then "FM3"
when month(Datekey_Opening) = 7 then "FM4"
when month(Datekey_Opening) = 8 then "FM5"
when month(Datekey_Opening) = 9 then "FM6"
when month(Datekey_Opening) = 10 then "FM7"
when month(Datekey_Opening) = 11 then "FM8"
when month(Datekey_Opening) = 12 then "FM9"
when month(Datekey_Opening) = 1 then "FM10"
when month(Datekey_Opening) = 2 then "FM11"
else "FM12"
END as Financial_Month, 

CASE 
when month(Datekey_Opening) between 1 and 3 then "FQ4"
when month(Datekey_Opening) between 4 and 6 then "FQ1"
when month(Datekey_Opening) between 7 and 9 then "FQ2"
else "FQ3"
END AS Financial_Quarter
   from sheet1
   order by date(datekey_opening);
 
 -- kpi 3 Convert the Average cost for 2 column into USD dollars 
select sheet1.restaurantid, sheet1.city ,sheet1.currency,rate.usd,sheet1.average_cost_for_two, 
sheet1.average_cost_for_two * rate.usd as converted 
from sheet1 inner join  rate
on sheet1.currency = rate.currency; 

ALTER TABLE sheet1
ADD average_cost_usd DECIMAL(10,2); 

SET SQL_SAFE_UPDATES = 0;
UPDATE sheet1
JOIN rate ON sheet1.currency = rate.currency
set sheet1.average_cost_usd = sheet1.average_cost_for_two * rate.USD;

 -- kpi 4 Find the Numbers of Resturants based on City and Country.
 select country.countryname ,sheet1.city , count(restaurantid) as no_of_restaurants 
 from sheet1 inner join country 
 on sheet1.country_code = country.countryid 
 group by countryname , city ;
  
  -- kpi 5 Numbers of Resturants opening based on Year , Quarter , Month
  select year(datekey_opening) as years  ,count(*)  as openings from sheet1
  group by year(datekey_opening)
  order by year(datekey_opening);
  
  select year(datekey_opening) as years, quarter(datekey_opening) as quarters ,count(*)  as openings from sheet1
  group by year(datekey_opening),quarter(datekey_opening)
  order by year(datekey_opening);
  
  select year(datekey_opening) as years, quarter(datekey_opening) as quarters,
  monthname(datekey_opening) as months,
  count(*)  as openings from sheet1
  group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening)
  order by year(datekey_opening);
  
  -- kpi 6 Count of Resturants based on Average Ratings
  SELECT AVG(Rating), COUNT(*) AS Num_Restaurants
FROM sheet1 
GROUP BY Rating
order by rating ;

Select count(RestaurantID),avg(Rating) from sheet1;

-- kpi 7 Create buckets based on Average Price of reasonable size and 
-- find out how many resturants falls in each buckets
SELECT 
case  
  WHEN Average_Cost_USD <= 10 THEN '0-$10'
  WHEN Average_Cost_USD <= 20 THEN '$10 - $20'
  WHEN Average_Cost_USD <= 30 THEN '$20 - $30'
  ELSE '>$30'
END AS PriceBucket,
count(*) as number_of_restaurants
FROM sheet1
group by pricebucket
order by number_of_restaurants desc ;


  
  -- kpi 8  percentage of restuarant based on has table booking
  select has_table_booking ,concat(round(count(has_table_booking)/100),"%") as percentage 
  from sheet1 
  group by has_table_booking;
   
   
   SELECT 
    CONCAT(round(COUNT(CASE
                WHEN Has_Table_Booking = 'Yes' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS has_table_booking, 
            CONCAT(round(COUNT(CASE
                WHEN Has_Table_Booking = 'no' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS no_table_booking
            FROM sheet1;
    
    
  -- kpi 9 Percentage of Resturants based on "Has_Online_delivery"
  select has_online_delivery ,concat(round(count(has_table_booking)/100),"%") as percentage 
  from sheet1 
  group by has_online_delivery;
  
  SELECT 
    CONCAT(round(COUNT(CASE
                WHEN Has_online_delivery= 'Yes' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS has_online_delivery, 
            CONCAT(round(COUNT(CASE
                WHEN has_online_delivery = 'no' THEN 1 ELSE NULL END) * 100 / COUNT(*)),'%') AS has_online_delivery
            FROM
    sheet1;
 
 
  
 