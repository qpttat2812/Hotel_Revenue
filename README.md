# Hotel_Revenue
Analyze project with MySQL and PowerBI, Exploratory Data Analysis

### Data Analysis Pipeline:
1. Define questions 
2. Create a DB
3. Exploratory Data Analysis with MySQL query and clean data
4. Export results to CSV file and connect to Power BI
5. Visualize

### Questions:
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

### Columns info:
1. <b>hotel</b>: Hotel (Resort Hotel or City Hotel)
2. <b>is_canceled</b>: Value indicating if the booking was canceled (1) or not (0)
3. <b>lead_time</b>: Number of days that elapsed between the entering date of the booking into the PMS and the arrival date
4. <b>arrival_date_year</b>: Year of arrival date
5. <b>arrival_date_month</b>: Month of arrival date
6. <b>arrival_date_week_number</b>: Week number of year for arrival date
7. <b>arrival_date_day_of_month</b>: Day of arrival date
8. <b>stays_in_weekend_nights</b>: Number of weekend nights (Saturday or Sunday) the guest stayed or booked to stay at the hotel
9. <b>stays_in_week_nights</b>: Number of week nights (Monday to Friday) the guest stayed or booked to stay at the hotel
10. <b>adults</b>: Number of adults
11. <b>children</b>: Number of children
12. <b>babies</b>: Number of babies
13. <b>meal</b>: Type of meal booked. Categories are presented in standard hospitality meal packages: Undefined/SC – no meal
14. <b>country</b>: Country of origin. Categories are represented in the ISO 3155–3:2013 format
15. <b>market_segment</b>: Market segment designation. In categories, the term “TA” means “Travel Agents” and “TO” means “Tour Operators”
16. <b>distribution_channel</b>: Booking distribution channel. The term “TA” means “Travel Agents” and “TO” means “Tour Operators”
