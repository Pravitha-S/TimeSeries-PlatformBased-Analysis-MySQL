# TimeSeries-PlatformBased-Analysis-MySQL
MySQL query on JSON data (semi-structured data) using DBeaver database tool.

# Project 

As a data analyst I am given a task to add two charts on the weekly KPI tracker dashboard.
Requirment is to create two MySQL querys for the below tasks

* TASK 1:

1) Create a timeseries chart which compares successful trips days booked in last 3 months as compared to the same period previous year grouped weekly.
  i.e. If the chart is opened today, it must show the data for the last three months ( eg.,24 Oct '23 to 24 Jan'24) and compare it to (eg., 24 Oct '22 to 24 Jan'23).
2) Each week in the weekly grouping has to start with Monday.

@ Input Table : 
transaction
@ Input Fields :
BookingStart and BookingEnd has the duration to get Trip days from.
createdAt is the timestamp to be used for trip creation.

@Expected Output :
Week starting date

Trip days this year (cumulative for the week)

Trip days last year (cumulative for the week)

* TASK 2:
  
In the chart above apply filters based on platform.
1) Fields on transaction level for platform
2) In transaction table > protectedData
3) If booking is created from iOS: isMobile = true
   
   If booking is created from Android: isAndroid = true
   
   If both of these fields are not present/null then its created from Web.

