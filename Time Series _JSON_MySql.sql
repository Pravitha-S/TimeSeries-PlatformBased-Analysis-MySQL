SELECT 
    subquery.week_starting_date,
    subquery.trip_days_this_year,
    SUM(subquery.trip_days_this_year) OVER (ORDER BY subquery.week_starting_date) AS cum_trip_days_this_year,
    subquery.trip_days_last_year,
    SUM(subquery.trip_days_last_year) OVER (ORDER BY subquery.week_starting_date) AS cum_trip_days_last_year
FROM
(
    SELECT 
        DATE_FORMAT(DATE_ADD(DATE_FORMAT(createdAt, '%Y-%m-%d'), INTERVAL(2 - DAYOFWEEK(createdAt)) DAY), '%Y-%m-%d') AS week_starting_date,
        SUM(CASE WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) THEN DATEDIFF(bookingEnd, bookingStart) ELSE 0 END) AS trip_days_this_year,
        SUM(CASE WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) - 1 THEN DATEDIFF(bookingEnd, bookingStart) ELSE 0 END) AS trip_days_last_year
    FROM 
        transactions
    WHERE 
        createdAt BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) AND CURRENT_DATE()
    GROUP BY 
        YEAR(createdAt), WEEK(createdAt)
) AS subquery
ORDER BY 
    subquery.week_starting_date;
