-- ========================================
-- 01_load.sql
-- Load CSVs into PostgreSQL with COPY
-- ========================================
-- IMPORTANT:
-- 1) Replace /absolute/path/... with your local paths.
-- 2) COPY must run on the server side. If using pgAdmin Query Tool,
--    you can still use COPY if the server can access the file path.
--    If not, use pgAdmin Import/Export or psql \copy.

COPY instacart.aisles(aisle_id, aisle)
FROM '/absolute/path/to/aisles.csv'
WITH (FORMAT csv, HEADER true);

COPY instacart.departments(department_id, department)
FROM '/absolute/path/to/departments.csv'
WITH (FORMAT csv, HEADER true);

COPY instacart.products(product_id, product_name, aisle_id, department_id)
FROM '/absolute/path/to/products.csv'
WITH (FORMAT csv, HEADER true);

COPY instacart.orders(order_id, user_id, eval_set, order_number, order_dow, order_hour_of_day, days_since_prior_order)
FROM '/absolute/path/to/orders.csv'
WITH (FORMAT csv, HEADER true);

COPY instacart.order_products_prior(order_id, product_id, add_to_cart_order, reordered)
FROM '/absolute/path/to/order_products__prior.csv'
WITH (FORMAT csv, HEADER true);

COPY instacart.order_products_train(order_id, product_id, add_to_cart_order, reordered)
FROM '/absolute/path/to/order_products__train.csv'
WITH (FORMAT csv, HEADER true);
