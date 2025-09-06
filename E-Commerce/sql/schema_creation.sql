DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    country VARCHAR(50)
);

CREATE TABLE products (
    stock_code VARCHAR(20) PRIMARY KEY,
    description TEXT
);

CREATE TABLE orders (
    invoice_no VARCHAR(20) PRIMARY KEY,
    customer_id INTEGER,
    invoice_date TIMESTAMP
);

CREATE TABLE order_items (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(20),
    quantity INTEGER,
    unit_price DECIMAL(10,2)
);

-- Data insertion from raw transactions table
INSERT INTO customers 
SELECT customer_id, MIN(country) as country
FROM transactions 
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

INSERT INTO products 
SELECT stock_code, MIN(description) as description
FROM transactions
WHERE stock_code IS NOT NULL
GROUP BY stock_code;

INSERT INTO orders 
SELECT invoice_no, MIN(customer_id) as customer_id, MIN(invoice_date::TIMESTAMP) as invoice_date
FROM transactions
WHERE invoice_no IS NOT NULL
GROUP BY invoice_no;

INSERT INTO order_items 
SELECT DISTINCT invoice_no, stock_code, quantity, unit_price 
FROM transactions;