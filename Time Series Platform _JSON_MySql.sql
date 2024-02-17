SELECT 
    subquery.week_starting_date,
    subquery.platform,
    SUM(subquery.trip_days_this_year) AS cum_trip_days_this_year,
    SUM(subquery.trip_days_last_year) AS cum_trip_days_last_year
FROM (
    SELECT 
        DATE_FORMAT(DATE_ADD(DATE_FORMAT(createdAt, '%Y-%m-%d'), INTERVAL(2-DAYOFWEEK(createdAt)) DAY), '%Y-%m-%d') AS week_starting_date,
        CASE
            WHEN JSON_CONTAINS(protectedData, '{"isMobile": true}') THEN 'iOS'
            WHEN JSON_CONTAINS(protectedData, '{"isAndroid": true}') THEN 'Android'
            ELSE 'Web'
        END AS platform,
        SUM(
            CASE 
                WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) AND JSON_CONTAINS(protectedData, '{"isMobile": true}') THEN DATEDIFF(bookingEnd, bookingStart)
                WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) AND JSON_CONTAINS(protectedData, '{"isAndroid": true}') THEN DATEDIFF(bookingEnd, bookingStart)
                WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) AND NOT JSON_CONTAINS(protectedData, '{"isMobile": true}') AND NOT JSON_CONTAINS(protectedData, '{"isAndroid": true}') THEN DATEDIFF(bookingEnd, bookingStart)
                ELSE 0
            END
        ) AS trip_days_this_year,
        SUM(
            CASE 
                WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) - 1 AND JSON_CONTAINS(protectedData, '{"isMobile": true}') THEN DATEDIFF(bookingEnd, bookingStart)
                WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) - 1 AND JSON_CONTAINS(protectedData, '{"isAndroid": true}') THEN DATEDIFF(bookingEnd, bookingStart)
                WHEN YEAR(createdAt) = YEAR(CURRENT_DATE()) - 1 AND NOT JSON_CONTAINS(protectedData, '{"isMobile": true}') AND NOT JSON_CONTAINS(protectedData, '{"isAndroid": true}') THEN DATEDIFF(bookingEnd, bookingStart)
                ELSE 0
            END
        ) AS trip_days_last_year
    FROM 
        transactions
    WHERE 
        createdAt BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) AND CURRENT_DATE()
    GROUP BY 
        YEAR(createdAt), WEEK(createdAt)
    ORDER BY 
        week_starting_date
) AS subquery
GROUP BY 
    subquery.week_starting_date
ORDER BY 
    subquery.week_starting_date;
