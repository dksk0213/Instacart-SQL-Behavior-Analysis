-- ========================================
-- 04_habit_formation.sql
-- Habit formation: reorder behavior
-- ========================================

-- 1) Overall reorder rate across all prior order items
SELECT AVG(reordered::float) AS overall_reorder_rate
FROM instacart.v_order_items;

-- 2) Reorder rate by customer activity level (based on total orders)
WITH temp AS (
    SELECT
        user_id,
        overall_reorder_rate,
        CASE
            WHEN total_orders < 10 THEN 'Low'
            WHEN total_orders < 30 THEN 'Medium'
            ELSE 'High'
        END AS order_group
    FROM instacart.user_features
)
SELECT
    order_group,
    AVG(overall_reorder_rate) AS avg_reorder_rate,
    COUNT(*) AS users
FROM temp
GROUP BY order_group
ORDER BY
    CASE
        WHEN order_group = 'Low' THEN 1
        WHEN order_group = 'Medium' THEN 2
        ELSE 3
    END;

-- 3) Reorder rate vs order progression (order_number)
SELECT
    order_number,
    AVG(reordered::float) AS reorder_rate,
    COUNT(*) AS n_items
FROM instacart.v_order_items
GROUP BY order_number
HAVING COUNT(*) > 50000
ORDER BY order_number
LIMIT 50;
