
--Query to Profile Tables

-- Row count and column overview
SELECT COUNT(*) FROM raw.customers;
SELECT * FROM raw.customers LIMIT 10;

-- Null / empty value check
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN email = '' OR email IS NULL THEN 1 ELSE 0 END) AS null_emails,
    SUM(CASE WHEN phone = '' OR phone IS NULL THEN 1 ELSE 0 END) AS null_phones
FROM raw.customers;

-- Duplicate primary key check
SELECT customer_id, COUNT(*)
FROM raw.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Distinct values for categorical columns
SELECT customer_type, COUNT(*)
FROM raw.customers
GROUP BY customer_type;

-- Date range check
SELECT MIN(signup_date), MAX(signup_date)
FROM raw.customers;

-- Numeric range check (on products)
SELECT MIN(unit_price), MAX(unit_price),
       SUM(CASE WHEN unit_price < 0 THEN 1 ELSE 0 END) AS negative_prices
FROM raw.products;

-- Referential integrity check
SELECT o.order_id, o.customer_id
FROM raw.orders o
LEFT JOIN raw.customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
