-- ========================================
-- 00_setup.sql
-- Instacart schema + tables (PostgreSQL)
-- ========================================
-- Create schema
CREATE SCHEMA IF NOT EXISTS instacart;

-- ----- Dimension tables -----
CREATE TABLE IF NOT EXISTS instacart.aisles (
    aisle_id   INT PRIMARY KEY,
    aisle      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS instacart.departments (
    department_id INT PRIMARY KEY,
    department    TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS instacart.products (
    product_id     INT PRIMARY KEY,
    product_name   TEXT NOT NULL,
    aisle_id       INT NOT NULL,
    department_id  INT NOT NULL,
    CONSTRAINT fk_products_aisle
        FOREIGN KEY (aisle_id) REFERENCES instacart.aisles(aisle_id),
    CONSTRAINT fk_products_department
        FOREIGN KEY (department_id) REFERENCES instacart.departments(department_id)
);

-- ----- Fact tables -----
CREATE TABLE IF NOT EXISTS instacart.orders (
    order_id                  INT PRIMARY KEY,
    user_id                   INT NOT NULL,
    eval_set                  TEXT NOT NULL,   -- 'prior', 'train', 'test'
    order_number              INT NOT NULL,
    order_dow                 INT,
    order_hour_of_day         INT,
    days_since_prior_order    FLOAT
);

CREATE TABLE IF NOT EXISTS instacart.order_products_prior (
    order_id         INT NOT NULL,
    product_id       INT NOT NULL,
    add_to_cart_order INT,
    reordered        INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_op_prior_order
        FOREIGN KEY (order_id) REFERENCES instacart.orders(order_id),
    CONSTRAINT fk_op_prior_product
        FOREIGN KEY (product_id) REFERENCES instacart.products(product_id)
);

CREATE TABLE IF NOT EXISTS instacart.order_products_train (
    order_id         INT NOT NULL,
    product_id       INT NOT NULL,
    add_to_cart_order INT,
    reordered        INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_op_train_order
        FOREIGN KEY (order_id) REFERENCES instacart.orders(order_id),
    CONSTRAINT fk_op_train_product
        FOREIGN KEY (product_id) REFERENCES instacart.products(product_id)
);

-- Helpful indexes for analytics (not required)
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON instacart.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON instacart.orders(order_number);

CREATE INDEX IF NOT EXISTS idx_op_prior_product_id ON instacart.order_products_prior(product_id);
CREATE INDEX IF NOT EXISTS idx_op_prior_order_id   ON instacart.order_products_prior(order_id);

CREATE INDEX IF NOT EXISTS idx_products_dept ON instacart.products(department_id);
CREATE INDEX IF NOT EXISTS idx_products_aisle ON instacart.products(aisle_id);
