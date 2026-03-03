-- ========================================
-- 03_features.sql
-- Feature tables (materialized aggregates)
-- ========================================

-- User-level features (computed from prior orders)
CREATE TABLE instacart.user_features AS
SELECT
    user_id,
    COUNT(DISTINCT order_id)                      AS total_orders,
    COUNT(*)                                      AS total_items,
    AVG(reordered::float)                         AS overall_reorder_rate,
    COUNT(*)::float / COUNT(DISTINCT order_id)    AS avg_items_per_order
FROM instacart.v_order_items
GROUP BY user_id;

CREATE INDEX IF NOT EXISTS idx_user_features_user_id ON instacart.user_features(user_id);

-- Product-level features
DROP TABLE IF EXISTS instacart.product_features;
CREATE TABLE instacart.product_features AS
SELECT
    product_id,
    product_name,
    department,
    aisle,
    COUNT(*)                  AS times_purchased,
    COUNT(DISTINCT order_id)  AS orders_with_product,
    AVG(reordered::float)     AS reorder_rate
FROM instacart.v_order_items
GROUP BY product_id, product_name, department, aisle;

CREATE INDEX IF NOT EXISTS idx_product_features_product_id ON instacart.product_features(product_id);

-- Department-level features
DROP TABLE IF EXISTS instacart.department_features;
CREATE TABLE instacart.department_features AS
SELECT
    department_id,
    department,
    COUNT(*)                  AS items_purchased,
    COUNT(DISTINCT order_id)  AS orders_with_department,
    AVG(reordered::float)     AS reorder_rate
FROM instacart.v_order_items
GROUP BY department_id, department;

CREATE INDEX IF NOT EXISTS idx_department_features_department_id ON instacart.department_features(department_id);
