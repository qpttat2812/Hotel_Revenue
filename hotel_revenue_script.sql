/*EXPLORATORY DATA ANALYSIS*/
/* 
1. Is our hotel revenue growing by year?
2. Should we increase our parking lot size? 
3. What trends can we see in the data? (Focus on average daily rate and guests to explore seasonality)
4. From where the most guests are coming?
5. How much do guests pay for a room per night?
6. How long do people stay at the hotels?
7. What Market Segment do the most bookings come from?
8. How many number of guests over the years by month and hotel type?
9. How many bookings were cancelled?
10. Which room type is most popular?
11. What is the customer type of the bookings?
*/
-- use hotel_revenue;

-- join data
with join_hotel as (
	(select * from hotel_revenue.hotel_revenue_2018
	where is_canceled = 0)
	union
	(select * from hotel_revenue.hotel_revenue_2019
	where is_canceled = 0)
	union 
	(select * from hotel_revenue.hotel_revenue_2020 
	where is_canceled = 0)
),
hotel_tb as (
	select j.*, m.Discount, me.Cost from join_hotel j
    left join market_segment m on m.market_segment = j.market_segment
    left join meal_cost me on me.meal = j.meal
)

-- select * from hotel_tb;

-- 1. revenue of each year of each type of hotel
-- select hotel, 
-- 		concat('$', format(round(sum(case arrival_date_year when 2018 then adr * (stays_in_weekend_nights + stays_in_week_nights) * (1-Discount) + Cost end), 2), 2)) as revenue_2018,
-- 		concat('$', format(round(sum(case arrival_date_year when 2019 then adr * (stays_in_weekend_nights + stays_in_week_nights) * (1-Discount) + Cost end), 2), 2)) as revenue_2019,
-- 		concat('$', format(round(sum(case arrival_date_year when 2020 then adr * (stays_in_weekend_nights + stays_in_week_nights) * (1-Discount) + Cost end), 2), 2)) as revenue_2020
-- from hotel_tb
-- group by hotel;
/*For each type of hotel, from 2018 to 2019 the revenue is increased
But in 2020, the revenue is declined*/

-- 2. percentage customer required parking lot size
-- select arrival_date_year, sum(required_car_parking_spaces) required_car_parking_space,
-- 	  concat(round(sum(required_car_parking_spaces)/(sum(stays_in_weekend_nights) + sum(stays_in_week_nights)) * 100, 2), '%') as percent_required_parking
-- from hotel_tb
-- group by arrival_date_year;
/* No need to increase parking lot size. Because the percent_required_parking just only account for almost 3%
*/

-- 3. explore seasonality
-- select  arrival_date_year, arrival_date_month, 
-- 		round(sum(adr*(stays_in_weekend_nights +stays_in_week_nights) * (1 - Discount) + Cost), 2) as revenue
-- from hotel_tb 
-- group by arrival_date_year, arrival_date_month
-- order by arrival_date_year, revenue desc;

/* In 2018, 2019, 2020 August has the highest revenue. July and September have the second highest revenue
Trend season is summer to fall
*/

-- 4. country has the most guests
-- select country, 
-- 		sum(adults) + sum(children) + sum(babies) as total_guest
-- from hotel_tb
-- group by country
-- order by total_guest desc;
/* Portugal has the most guests
The second place is UK and the third place is France
*/		

-- 5. the money that guests pay for a room per night
-- select hotel, assigned_room_type, round(avg(adr * (1 - Discount) * (stays_in_weekend_nights +stays_in_week_nights)), 2) as money_spent
-- from hotel_tb
-- group by hotel, assigned_room_type
-- order by hotel, money_spent desc;
/* average money spent for Resort Hotel is higher than City Hotel
And it depends on room type and season
*/

-- 6. length of days that customer stay hotel
-- select hotel, stays_in_weekend_nights + stays_in_week_nights as length_time,
-- 		count(stays_in_weekend_nights + stays_in_week_nights) as freq_length
-- from hotel_tb
-- group by hotel, stays_in_weekend_nights + stays_in_week_nights
-- order by hotel, freq_length desc;
/* 3 days is popular for City Hotel
1 day is popular for Resort Hotel
*/

-- 7. Market Segment do the most bookings come from
-- select market_segment, country, count(1) as freq_market_segment
-- from hotel_tb
-- group by market_segment, country
-- order by freq_market_segment desc;
/* Online TA do the most bookings from Portugal
*/

-- 8. number of guests over the years by month and hotel type
-- select hotel, arrival_date_year, arrival_date_month,
-- 		sum(adults + children + babies) as guest_total
-- from hotel_tb
-- group by hotel, arrival_date_year, arrival_date_month
-- order by hotel, arrival_date_year asc, guest_total desc;
/* Number of guests concentrate on Summer and Fall
*/

-- 9. number of bookings were cancelled
-- select hotel, count(*) as canceled_booking
-- from (
-- 		select * from hotel_revenue_2018
--         where is_canceled = 1
--         union 
--         select * from hotel_revenue_2019
--         where is_canceled = 1
--         union
--         select * from hotel_revenue_2020
--         where is_canceled = 1
--         ) canceled_booking_tb
-- group by hotel
-- order by canceled_booking desc;
/* number of cancelling booking 'City Hotel', '17462'
								'Resort Hotel', '9306'
*/        

-- 10. room type is most popular
-- select hotel, assigned_room_type, count(1) as freq_booking_room
-- from hotel_tb
-- group by hotel, assigned_room_type
-- order by freq_booking_room desc;
/* Both room type A in City Hotel and Resort Hotel are popular
*/

-- 11. the customer type of the bookings
select customer_type, freq_customer_type,
		sum(freq_customer_type) over() as total,
        concat(round(freq_customer_type/sum(freq_customer_type) over() * 100, 2), '%') as percent_cust_segment
from (
	 select customer_type, count(1) as freq_customer_type
	 from hotel_tb
	 group by customer_type) cust_segment_tb
/* Transient accounts for 77.24% while group just accounts for only 0.86%
*/