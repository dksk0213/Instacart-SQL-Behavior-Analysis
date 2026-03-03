-- ========================================
-- 99_sanity_checks.sql
-- Quick checks after loading
-- ========================================

-- Row counts
SELECT 'aisles' AS table_name, COUNT(*) FROM instacart.aisles
UNION ALL SELECT 'departments', COUNT(*) FROM instacart.departments
UNION ALL SELECT 'products', COUNT(*) FROM instacart.products
UNION ALL SELECT 'orders', COUNT(*) FROM instacart.orders
UNION ALL SELECT 'order_products_prior', COUNT(*) FROM instacart.order_products_prior
UNION ALL SELECT 'order_products_train', COUNT(*) FROM instacart.order_products_train;

-- Check missing foreign keys (should return 0 rows)
SELECT op.product_id
FROM instacart.order_products_prior op
LEFT JOIN instacart.products p ON op.product_id = p.product_id
WHERE p.product_id IS NULL
LIMIT 10;

-- Ensure view works
SELECT *
FROM instacart.v_order_items
LIMIT 5;

-- Top products by purchase count (sanity check)
SELECT product_name, COUNT(*) AS times_purchased
FROM instacart.v_order_items
GROUP BY product_name
ORDER BY times_purchased DESC
LIMIT 10;
