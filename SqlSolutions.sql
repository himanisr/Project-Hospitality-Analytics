Create Database HospitalityAnalytics;

use HospitalityAnalytics;

Select * from dim_date limit 10;
Select * from dim_hotels limit 10;
Select * from dim_rooms limit 10;
Select * from fact_aggregated_bookings limit 10;
Select * from fact_bookings limit 10;

-- Total Revenue --
Select SUM(revenue_realized) as `Total Revenue` from fact_bookings;

-- Total Bookings --
SELECT COUNT(booking_id) AS Total_Bookings
FROM fact_bookings;

-- Total Capacity --
SELECT SUM(capacity) AS Total_Capacity
FROM fact_aggregated_bookings;

-- Total Successful Bookings --
SELECT SUM(successful_bookings) AS total_successful_bookings
FROM fact_aggregated_bookings;

-- Occupancy --
SELECT 
    ROUND(
        CASE 
            WHEN SUM(capacity) = 0 THEN 0
            ELSE SUM(successful_bookings) * 100.0 / SUM(capacity)
        END, 0
    ) AS occupancy_percentage
FROM fact_aggregated_bookings;

-- Cancellation Percentage --
SELECT 
    ROUND(
        CASE 
            WHEN COUNT(*) = 0 THEN 0
            ELSE COUNT(CASE WHEN booking_status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*)
        END, 2
    ) AS cancellation_percentage
FROM fact_bookings;


-- utilized capacity --
-- DURN (Daily Utilized Room Nights) --
/*SELECT 
    ROUND(
        COUNT(*) / (DATEDIFF((SELECT MAX(date) FROM dim_date), (SELECT MIN(date) FROM dim_date)) + 1),
        2
    ) AS DURN
FROM fact_bookings
WHERE booking_status = 'Checked Out';*/

-- Weekday  & Weekend  Revenue and Booking --
-- Weekday vs Weekend Revenue and Booking Count
/*SELECT 
  d.day_type,
  COUNT(*) AS total_bookings,
  SUM(f.revenue_realized) AS total_revenue
FROM fact_bookings f
JOIN dim_date d ON f.booking_date = d.date
GROUP BY d.day_type;*/

-- Revenue by city and hotels --
SELECT 
    dh.city,
    dh.property_name as `hotels`,
    SUM(fb.revenue_realized) AS total_revenue
FROM fact_bookings fb
JOIN dim_hotels dh ON fb.property_id = dh.property_id
GROUP BY dh.city, dh.property_name
ORDER BY dh.city, total_revenue DESC;

-- Room Classwise Revenue--
Select dr.room_class as `Class`, fb.revenue_realized as `Total Revenue` from fact_bookings fb JOIN dim_rooms dr ON dr.room_id = fb.room_category;

-- Booking status --
select booking_status, count(booking_status) as `Total Bookings` from fact_bookings
group by booking_status;

-- Trend Analysis 
select dim_hotels.city,sum(fact_bookings.revenue_generated) as  RevenueGenerated ,sum(fact_bookings.revenue_realized) as RevenueRealized
from dim_hotels join fact_bookings
on dim_hotels.property_id=fact_bookings.property_id
group by dim_hotels.city;