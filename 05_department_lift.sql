-- ========================================
-- 05_department_lift.sql
-- Department-level market basket lift
-- ========================================

-- Department-level lift:
-- Support(A)   = P(order contains dept A)
-- Support(A,B) = P(order contains both dept A and dept B)
-- Lift(A,B)    = Support(A,B) / (Support(A) * Support(B))

WITH total_orders AS (
    SELECT COUNT(DISTINCT order_id) AS n_orders
    FROM instacart.order_products_prior
),
order_departments AS (
    -- each order contributes at most one row per department
    SELECT DISTINCT
        op.order_id,
        p.department_id
    FROM instacart.order_products_prior op
    JOIN instacart.products p
        ON op.product_id = p.product_id
),
dept_support AS (
    SELECT
        department_id,
        COUNT(DISTINCT order_id)::numeric / (SELECT n_orders FROM total_orders) AS support
    FROM order_departments
    GROUP BY department_id
),
dept_pairs AS (
    SELECT
        od1.department_id AS dept_a,
        od2.department_id AS dept_b,
        COUNT(DISTINCT od1.order_id)::numeric / (SELECT n_orders FROM total_orders) AS pair_support
    FROM order_departments od1
    JOIN order_departments od2
        ON od1.order_id = od2.order_id
       AND od1.department_id < od2.department_id
    GROUP BY od1.department_id, od2.department_id
)
SELECT
    d1.department AS department_a,
    d2.department AS department_b,
    ROUND(dp.pair_support, 4) AS pair_support,
    ROUND((dp.pair_support / (s1.support * s2.support))::numeric, 2) AS lift
FROM dept_pairs dp
JOIN dept_support s1 ON dp.dept_a = s1.department_id
JOIN dept_support s2 ON dp.dept_b = s2.department_id
JOIN instacart.departments d1 ON dp.dept_a = d1.department_id
JOIN instacart.departments d2 ON dp.dept_b = d2.department_id
WHERE dp.pair_support > 0.02
ORDER BY lift DESC
LIMIT 50;
