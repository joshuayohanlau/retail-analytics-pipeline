-- Create raw schema and load CSVs
-- Run from project root: psql -U postgres -f data/load_to_postgres.sql

DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA raw;

CREATE TABLE raw.customers (
    customer_id     VARCHAR(20),
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    email           VARCHAR(200),
    phone           VARCHAR(50),
    signup_date     VARCHAR(20),
    city            VARCHAR(100),
    region          VARCHAR(100),
    customer_type   VARCHAR(50)
);

CREATE TABLE raw.products (
    product_id      VARCHAR(20),
    product_name    VARCHAR(200),
    category        VARCHAR(100),
    subcategory     VARCHAR(100),
    unit_price      DECIMAL(10,2),
    supplier        VARCHAR(100)
);

CREATE TABLE raw.stores (
    store_id        VARCHAR(20),
    store_name      VARCHAR(200),
    store_type      VARCHAR(50),
    city            VARCHAR(100),
    region          VARCHAR(100),
    opened_date     VARCHAR(20)
);

CREATE TABLE raw.orders (
    order_id        VARCHAR(20),
    customer_id     VARCHAR(20),
    store_id        VARCHAR(20),
    order_date      VARCHAR(20),
    status          VARCHAR(50),
    shipping_method VARCHAR(50)
);

CREATE TABLE raw.order_items (
    order_item_id   VARCHAR(20),
    order_id        VARCHAR(20),
    product_id      VARCHAR(20),
    quantity        INTEGER,
    unit_price      DECIMAL(10,2),
    discount_pct    DECIMAL(5,2)
);

CREATE TABLE raw.payments (
    payment_id      VARCHAR(20),
    order_id        VARCHAR(20),
    payment_method  VARCHAR(50),
    payment_date    VARCHAR(20),
    amount          DECIMAL(12,2),
    payment_status  VARCHAR(50)
);

CREATE TABLE raw.inventory (
    inventory_id    VARCHAR(20),
    product_id      VARCHAR(20),
    store_id        VARCHAR(20),
    quantity_on_hand INTEGER,
    reorder_point   VARCHAR(20),
    last_restocked  VARCHAR(20)
);

CREATE TABLE raw.web_activity (
    session_id      VARCHAR(20),
    customer_id     VARCHAR(20),
    page_url        VARCHAR(200),
    event_type      VARCHAR(50),
    event_timestamp VARCHAR(30),
    device_type     VARCHAR(50),
    browser         VARCHAR(100),
    referrer_source VARCHAR(100)
);

-- Load CSVs from data/ folder
\COPY raw.customers FROM 'data/customers.csv' WITH CSV HEADER;
\COPY raw.products FROM 'data/products.csv' WITH CSV HEADER;
\COPY raw.stores FROM 'data/stores.csv' WITH CSV HEADER;
\COPY raw.orders FROM 'data/orders.csv' WITH CSV HEADER;
\COPY raw.order_items FROM 'data/order_items.csv' WITH CSV HEADER;
\COPY raw.payments FROM 'data/payments.csv' WITH CSV HEADER;
\COPY raw.inventory FROM 'data/inventory.csv' WITH CSV HEADER;
\COPY raw.web_activity FROM 'data/web_activity.csv' WITH CSV HEADER;

-- Quick row count check
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL SELECT 'products', COUNT(*) FROM raw.products
UNION ALL SELECT 'stores', COUNT(*) FROM raw.stores
UNION ALL SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL SELECT 'payments', COUNT(*) FROM raw.payments
UNION ALL SELECT 'inventory', COUNT(*) FROM raw.inventory
UNION ALL SELECT 'web_activity', COUNT(*) FROM raw.web_activity
ORDER BY table_name;
