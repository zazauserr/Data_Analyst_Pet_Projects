-- Product Performance Views
CREATE VIEW top_products_quantity AS
SELECT p.description,
       SUM(oi.quantity) as total_quantity,
       COUNT(DISTINCT oi.invoice_no) as orders_count
FROM products p
LEFT JOIN order_items oi ON p.stock_code = oi.stock_code
WHERE oi.quantity > 0
GROUP BY p.description
ORDER BY total_quantity DESC;

CREATE VIEW top_products_revenue AS
SELECT p.description,
       SUM(oi.quantity * oi.unit_price) as total_revenue,
       AVG(oi.unit_price) as avg_price,
       SUM(oi.quantity) as total_quantity
FROM products p
LEFT JOIN order_items oi ON p.stock_code = oi.stock_code
WHERE oi.quantity > 0
GROUP BY p.description
ORDER BY total_revenue DESC;

-- Returns Analysis Views
CREATE VIEW returns_analysis AS
SELECT p.description,
       ABS(SUM(oi.quantity)) as total_returns,
       AVG(oi.unit_price) as avg_price,
       COUNT(DISTINCT oi.invoice_no) as return_orders_count,
       COUNT(DISTINCT o.customer_id) as customers_with_returns
FROM products p
LEFT JOIN order_items oi ON p.stock_code = oi.stock_code
LEFT JOIN orders o ON oi.invoice_no = o.invoice_no
WHERE oi.quantity < 0
  AND p.description NOT LIKE '%damaged%'
  AND p.description NOT LIKE '%manual%'
  AND p.description NOT LIKE '%?%'
  AND p.description != 'Unknown'
GROUP BY p.description
ORDER BY total_returns DESC;

-- Customer Performance Views
CREATE VIEW customer_performance AS
SELECT c.customer_id,
       c.country,
       SUM(oi.quantity) as total_items_bought,
       SUM(oi.quantity * oi.unit_price) as total_spent,
       COUNT(DISTINCT o.invoice_no) as total_orders,
       AVG(oi.quantity * oi.unit_price) as avg_order_value,
       MIN(o.invoice_date) as first_purchase,
       MAX(o.invoice_date) as last_purchase
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.invoice_no = oi.invoice_no
WHERE oi.quantity > 0
GROUP BY c.customer_id, c.country
ORDER BY total_spent DESC;

-- Time Series Analysis
CREATE VIEW monthly_sales_trends AS
SELECT TO_CHAR(o.invoice_date, 'YYYY-MM') as sales_month,
       SUM(oi.quantity * oi.unit_price) as monthly_revenue,
       SUM(oi.quantity) as monthly_quantity,
       COUNT(DISTINCT o.invoice_no) as monthly_orders,
       COUNT(DISTINCT o.customer_id) as monthly_customers
FROM orders o
LEFT JOIN order_items oi ON o.invoice_no = oi.invoice_no  
WHERE oi.quantity > 0
GROUP BY TO_CHAR(o.invoice_date, 'YYYY-MM')
ORDER BY sales_month;