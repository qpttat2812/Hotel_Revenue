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

-- append data
with union_hotels as (
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
	select u.*, m.Discount, me.Cost from union_hotels u
    left join market_segment m on m.market_segment = u.market_segment
    left join meal_cost me on me.meal = u.meal
),

-- check the data with condition
-- adults = 0 and children = 0 and babies = 0
-- adults, babies and children cant be zero at same time
-- select * from hotel_tb
-- where adults = 0 and children = 0 and babies = 0;
/*There are 178 rows contains 3 variables equal to 0*/

-- get all valid data and save it into new csv file/table called hotel_revenue
hotel_revenue as (
	select * from hotel_tb
	where (adults <> 0 and children <> 0 and babies <> 0)
	or (adults <> 0 and children = 0 and babies = 0)
	or (adults = 0 and children <> 0 and babies = 0)
	or (adults = 0 and children = 0 and babies <> 0)
	or (adults <> 0 and children <> 0 and babies = 0)
	or (adults <> 0 and children = 0 and babies <> 0)
	or (adults = 0 and children <> 0 and babies <> 0)
),
/*There are 73802 valid rows*/

-- get bookings were canceled and save it in new csv file/table called hotel_canceled_booking
hotel_canceled_booking as (
    select canceled_tb.*, market_segment.Discount, meal_cost.Cost
	from (
		select * from hotel_revenue_2018
		where is_canceled = 1
		union 
		select * from hotel_revenue_2019
		where is_canceled = 1
		union
		select * from hotel_revenue_2020
		where is_canceled = 1) canceled_tb 
	left join meal_cost on canceled_tb.meal = meal_cost.meal
    left join market_segment on canceled_tb.market_segment = market_segment.market_segment
	where (adults <> 0 and children <> 0 and babies <> 0)
	or (adults <> 0 and children = 0 and babies = 0)
	or (adults = 0 and children <> 0 and babies = 0)
	or (adults = 0 and children = 0 and babies <> 0)
	or (adults <> 0 and children <> 0 and babies = 0)
	or (adults <> 0 and children = 0 and babies <> 0)
	or (adults = 0 and children <> 0 and babies <> 0)
)

-- 1. revenue of each year of each type of hotel
select hotel, 
		round(sum(case arrival_date_year when 2018 then adr * (stays_in_weekend_nights + stays_in_week_nights) * (1-Discount) + Cost end), 2) as revenue_2018,
		round(sum(case arrival_date_year when 2019 then adr * (stays_in_weekend_nights + stays_in_week_nights) * (1-Discount) + Cost end), 2) as revenue_2019,
		round(sum(case arrival_date_year when 2020 then adr * (stays_in_weekend_nights + stays_in_week_nights) * (1-Discount) + Cost end), 2) as revenue_2020
from hotel_revenue
group by hotel;
/*For each type of hotel, from 2018 to 2019 the revenue is increased
From 2019 to 2020, the revenue is declined*/

-- 2. percentage customer required parking lot size
select hotel,
		parking_request,
        round(parking_request/(parking_request + not_parking_request) * 100, 2) as parking_percent
from (
	select hotel, 
			count(case when required_car_parking_spaces =  0 then required_car_parking_spaces end) as not_parking_request,
			sum(case when required_car_parking_spaces <>  0 then required_car_parking_spaces end) as parking_request
	from hotel_revenue
	group by hotel) parking_tb;
/* No need to increase parking lot size. Because the percent_required_parking just only account for almost 3%
*/

-- 3. explore seasonality
select  arrival_date_year, arrival_date_month, 
		round(sum(adr*(stays_in_weekend_nights +stays_in_week_nights) * (1 - Discount) + Cost), 2) as revenue
from hotel_revenue
group by arrival_date_year, arrival_date_month
order by arrival_date_year, revenue desc;

/* In 2018, 2019, 2020 August has the highest revenue. July and September have the second highest revenue
Trend season is summer to fall
*/

-- 4. country has the most guests
select country, 
		sum(adults) + sum(children) + sum(babies) as total_guest
from hotel_revenue
group by country
order by total_guest desc;
/* Portugal has the most guests
The second place is UK and the third place is France
*/		

-- 5. the money that guests pay for a room per night
select hotel, assigned_room_type, round(avg(adr * (1 - Discount) * (stays_in_weekend_nights +stays_in_week_nights)), 2) as money_spent
from hotel_revenue
group by hotel, assigned_room_type
order by hotel, money_spent desc;
/* average money spent for Resort Hotel is higher than City Hotel
*/

-- 6. length of days that customer stay hotel
select hotel, stays_in_weekend_nights + stays_in_week_nights as length_time,
		count(stays_in_weekend_nights + stays_in_week_nights) as freq_length
from hotel_revenue
group by hotel, stays_in_weekend_nights + stays_in_week_nights
order by hotel, freq_length desc;
/* 1 - 3 days are the most popular for City Hotel
1, 2 and 7 days are the most popular for Resort Hotel
*/

-- 7. Market Segment do the most bookings come from
select market_segment, country, count(1) as freq_market_segment
from hotel_revenue
group by market_segment, country
order by freq_market_segment desc;
/* Online TA do the most bookings from Portugal
*/

-- 8. number of guests over the years by month and hotel type
select hotel, arrival_date_year, arrival_date_month,
		sum(adults + children + babies) as guest_total
from hotel_revenue
group by hotel, arrival_date_year, arrival_date_month
order by hotel, arrival_date_year asc, guest_total desc;
/* Number of guests concentrate on Summer and Fall
*/

-- 9. number of bookings were cancelled
select hotel, count(*) as canceled_booking
from hotel_canceled_booking
group by hotel
order by canceled_booking desc;
/* number of cancelling booking 'City Hotel', '17447'
								'Resort Hotel', '9304'
*/        

-- 10. room type is most popular
select hotel, assigned_room_type, count(1) as freq_booking_room
from hotel_revenue
group by hotel, assigned_room_type
order by freq_booking_room desc;
/* Both room type A in City Hotel and Resort Hotel are popular
*/

-- 11. the customer type of the bookings
select customer_type, freq_customer_type,
		sum(freq_customer_type) over() as total,
        round(freq_customer_type/sum(freq_customer_type) over() * 100, 2) as percent_cust_segment
from (
	 select customer_type, count(1) as freq_customer_type
	 from hotel_revenue
	 group by customer_type) cust_segment_tb;
/* Transient accounts for 77.25% while group just accounts for only 0.86%
*/