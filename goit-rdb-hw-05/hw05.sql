USE goit_rdb_hw_03;

-- Task 1
SELECT
    od.*,
    (
        SELECT o.customer_id
        FROM orders AS o
        WHERE o.id = od.order_id
    ) AS customer_id
FROM order_details AS od;


-- Task 2
SELECT *
FROM order_details
WHERE order_id IN (
    SELECT id
    FROM orders
    WHERE shipper_id = 3
);


-- Task 3
SELECT
    temp.order_id,
    AVG(temp.quantity) AS average_quantity
FROM (
    SELECT *
    FROM order_details
    WHERE quantity > 10
) AS temp
GROUP BY temp.order_id;


-- Task 4
WITH temp AS (
    SELECT *
    FROM order_details
    WHERE quantity > 10
)
SELECT
    temp.order_id,
    AVG(temp.quantity) AS average_quantity
FROM temp
GROUP BY temp.order_id;


-- Task 5
DROP FUNCTION IF EXISTS divide_numbers;

DELIMITER //

CREATE FUNCTION divide_numbers(
    first_number FLOAT,
    second_number FLOAT
)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN
    RETURN first_number / second_number;
END //

DELIMITER ;

SELECT
    id,
    order_id,
    product_id,
    quantity,
    divide_numbers(quantity, 2) AS divided_quantity
FROM order_details;