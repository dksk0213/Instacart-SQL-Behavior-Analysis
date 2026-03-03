-- ========================================
-- 06_retention.sql
-- Order continuation among repeat customers
-- ========================================

-- 1) Distribution: how many orders does each user have?
WITH user_orders AS (
    SELECT
        user_id,
        COUNT(*) AS total_orders
    FROM instacart.orders
    GROUP BY user_id
)
SELECT
    total_orders,
    COUNT(*) AS users
FROM user_orders
GROUP BY total_orders
ORDER BY total_orders;

-- 2) Continuation curve (survival by order count)
-- Retention at tenure t = % of users with at least (t+1) orders
WITH user_max AS (
    SELECT
        user_id,
        MAX(order_number) AS max_order_number
    FROM instacart.orders
    GROUP BY user_id
),
tenures AS (
    SELECT generate_series(0, 50) AS tenure
)
SELECT
    t.tenure,
    COUNT(*) FILTER (WHERE u.max_order_number >= t.tenure + 1) AS active_users,
    ROUND(
        COUNT(*) FILTER (WHERE u.max_order_number >= t.tenure + 1)::numeric
        / COUNT(*)::numeric,
        4
    ) AS retention_rate
FROM tenures t
CROSS JOIN user_max u
GROUP BY t.tenure
ORDER BY t.tenure;
