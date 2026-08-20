-- TASK 1. Create schema and select it


CREATE SCHEMA IF NOT EXISTS pandemic;

USE pandemic;

-- infectious_cases is imported using MySQL Workbench Import Wizard

SELECT COUNT(*)
FROM infectious_cases;



-- TASK 2. Normalize infectious_cases to 3NF


DROP TABLE IF EXISTS infectious_cases_normalized;
DROP TABLE IF EXISTS entities;

CREATE TABLE entities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(255) NOT NULL,
    code VARCHAR(20),
    UNIQUE KEY unique_entity_code (entity, code)
);

INSERT INTO entities (entity, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;


CREATE TABLE infectious_cases_normalized (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    year INT,

    Number_yaws TEXT,
    polio_cases TEXT,
    cases_guinea_worm TEXT,
    Number_rabies TEXT,
    Number_malaria TEXT,
    Number_hiv TEXT,
    Number_tuberculosis TEXT,
    Number_smallpox TEXT,
    Number_cholera_cases TEXT,

    FOREIGN KEY (entity_id) REFERENCES entities(id)
);


INSERT INTO infectious_cases_normalized (
    entity_id,
    year,
    Number_yaws,
    polio_cases,
    cases_guinea_worm,
    Number_rabies,
    Number_malaria,
    Number_hiv,
    Number_tuberculosis,
    Number_smallpox,
    Number_cholera_cases
)
SELECT
    e.id,
    ic.Year,
    ic.Number_yaws,
    ic.polio_cases,
    ic.cases_guinea_worm,
    ic.Number_rabies,
    ic.Number_malaria,
    ic.Number_hiv,
    ic.Number_tuberculosis,
    ic.Number_smallpox,
    ic.Number_cholera_cases
FROM infectious_cases ic
JOIN entities e
    ON ic.Entity = e.entity
    AND (ic.Code = e.code OR (ic.Code IS NULL AND e.code IS NULL));


-- Check normalized data

SELECT *
FROM entities
LIMIT 20;

SELECT *
FROM infectious_cases_normalized
LIMIT 20;



-- TASK 3. Analyze Number_rabies


SELECT
    e.entity,
    e.code,
    AVG(CAST(icn.Number_rabies AS DECIMAL(20, 5))) AS avg_rabies,
    MIN(CAST(icn.Number_rabies AS DECIMAL(20, 5))) AS min_rabies,
    MAX(CAST(icn.Number_rabies AS DECIMAL(20, 5))) AS max_rabies,
    SUM(CAST(icn.Number_rabies AS DECIMAL(20, 5))) AS sum_rabies
FROM infectious_cases_normalized icn
JOIN entities e
    ON icn.entity_id = e.id
WHERE icn.Number_rabies IS NOT NULL
    AND icn.Number_rabies <> ''
GROUP BY e.id, e.entity, e.code
ORDER BY avg_rabies DESC
LIMIT 10;



-- TASK 4. Difference between Year and current date


SELECT
    id,
    year,

    STR_TO_DATE(
        CONCAT(year, '-01-01'),
        '%Y-%m-%d'
    ) AS year_start_date,

    CURDATE() AS today,

    TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(CONCAT(year, '-01-01'), '%Y-%m-%d'),
        CURDATE()
    ) AS year_difference

FROM infectious_cases_normalized
LIMIT 20;



-- TASK 5. Custom function


DROP FUNCTION IF EXISTS calculate_year_difference;

DELIMITER //

CREATE FUNCTION calculate_year_difference(input_year INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(CONCAT(input_year, '-01-01'), '%Y-%m-%d'),
        CURDATE()
    );
END //

DELIMITER ;


-- Use custom function

SELECT
    id,
    year,
    calculate_year_difference(year) AS year_difference
FROM infectious_cases_normalized
LIMIT 20;