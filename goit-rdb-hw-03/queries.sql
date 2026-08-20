USE goit_rdb_hw_03;

-- Task 1.1
SELECT *
FROM products;

-- Task 1.2
SELECT name, phone
FROM shippers;

-- Task 2
SELECT
    AVG(price) AS average_price,
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM products;

-- Task 3
SELECT DISTINCT category_id, price
FROM products
ORDER BY price DESC
LIMIT 10;

-- Task 4
SELECT COUNT(*) AS product_count
FROM products
WHERE price BETWEEN 20 AND 100;

-- Task 5
SELECT
    supplier_id,
    COUNT(*) AS product_count,
    AVG(price) AS average_price
FROM products
GROUP BY supplier_id;