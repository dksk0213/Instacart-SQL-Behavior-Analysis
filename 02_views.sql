-- ========================================
-- 02_views.sql
-- Reusable analytics views
-- ========================================

-- Unified order-item view for PRIOR orders
CREATE OR REPLACE VIEW instacart.v_order_items AS
SELECT
    o.order_id,
    o.user_id,
    o.order_number,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order,
    op.product_id,
    op.add_to_cart_order,
    op.reordered,
    p.product_name,
    p.aisle_id,
    a.aisle,
    p.department_id,
    d.department
FROM instacart.orders o
JOIN instacart.order_products_prior op
    ON o.order_id = op.order_id
JOIN instacart.products p
    ON op.product_id = p.product_id
JOIN instacart.aisles a
    ON p.aisle_id = a.aisle_id
JOIN instacart.departments d
    ON p.department_id = d.department_id
WHERE o.eval_set = 'prior';
