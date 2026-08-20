USE goit_rdb_hw_03;

-- Task 1
SELECT
    id,
    date,
    YEAR(date) AS year,
    MONTH(date) AS month,
    DAY(date) AS day
FROM orders;


-- Task 2
SELECT
    id,
    date,
    DATE_ADD(date, INTERVAL 1 DAY) AS date_plus_one_day
FROM orders;


-- Task 3
SELECT
    id,
    date,
    UNIX_TIMESTAMP(date) AS timestamp_seconds
FROM orders;


-- Task 4
SELECT COUNT(*) AS orders_count
FROM orders
WHERE date BETWEEN '1996-07-10 00:00:00'
               AND '1996-10-08 00:00:00';


-- Task 5
SELECT
    id,
    date,
    JSON_OBJECT(
        'id', id,
        'date', date
    ) AS order_json
FROM orders;