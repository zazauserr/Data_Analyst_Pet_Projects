-- RFM Analysis View
CREATE VIEW rfm_analysis AS
WITH rfm_metrics AS (
    SELECT customers.customer_id, 
           CURRENT_DATE - MAX(orders.invoice_date::date) as recency, 
           COUNT(DISTINCT orders.invoice_no) as frequency, 
           SUM(order_items.quantity * order_items.unit_price) as monetary 
    FROM customers
    LEFT JOIN orders ON orders.customer_id = customers.customer_id
    LEFT JOIN order_items ON order_items.invoice_no = orders.invoice_no
    GROUP BY customers.customer_id
),
rfm_scores AS (
    SELECT customer_id, recency, frequency, monetary, 
           CASE 
               WHEN recency <= 5050 THEN 5 
               WHEN recency <= 5100 THEN 4 
               WHEN recency <= 5150 THEN 3 
               WHEN recency <= 5200 THEN 2 
               ELSE 1
           END as r_score, 
           CASE 
               WHEN frequency >= 6 THEN 5 
               WHEN frequency >= 4 THEN 4 
               WHEN frequency >= 3 THEN 3 
               WHEN frequency >= 2 THEN 2 
               ELSE 1 
           END as f_score, 
           CASE 
               WHEN monetary >= 5000 THEN 5 
               WHEN monetary >= 2000 THEN 4 
               WHEN monetary >= 1000 THEN 3 
               WHEN monetary >= 500 THEN 2 
               ELSE 1 
           END as m_score 
    FROM rfm_metrics
)
SELECT customer_id, recency, frequency, monetary, r_score, f_score, m_score,
       CASE
           WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
           WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'  
           WHEN r_score >= 3 AND f_score <= 2 AND m_score >= 3 THEN 'Big Spenders'
           WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'At Risk'
           WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'Lost Customers'
           WHEN r_score >= 4 AND f_score <= 2 AND m_score <= 3 THEN 'New Customers'
           ELSE 'Default'
       END as segment
FROM rfm_scores;

-- Cohort Analysis View
CREATE VIEW cohort_analysis AS
WITH first_purchases AS (
    SELECT customer_id, MIN(TO_CHAR(invoice_date, 'YYYY-MM')) as first_purchase_month
    FROM orders 
    GROUP BY customer_id
),
purchase_months AS( 
    SELECT first_purchases.customer_id, first_purchases.first_purchase_month, TO_CHAR(orders.invoice_date, 'YYYY-MM') as purchase_month
    FROM first_purchases
    LEFT JOIN orders ON orders.customer_id = first_purchases.customer_id
)
SELECT first_purchase_month, 
       EXTRACT(YEAR FROM AGE((purchase_months.purchase_month || '-01')::date, (first_purchase_month || '-01')::date)) * 12 + 
       EXTRACT(MONTH FROM AGE((purchase_months.purchase_month || '-01')::date, (first_purchase_month || '-01')::date)) as months_since_first,
       COUNT(DISTINCT customer_id) as unique_customers
FROM purchase_months
GROUP BY first_purchase_month, purchase_month
ORDER BY first_purchase_month;

-- Geographic Analysis View
CREATE VIEW geographic_analysis AS
SELECT c.country, 
       COUNT(DISTINCT(c.customer_id)) as customers, 
       SUM(oi.quantity * oi.unit_price) as revenue 
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.invoice_no = oi.invoice_no
GROUP BY c.country
ORDER BY revenue DESC;

-- ABC Analysis View
CREATE VIEW abc_analysis AS
WITH cumulative_percentage AS (
    SELECT p.description, 
           SUM(oi.quantity * oi.unit_price) as revenue,
           SUM(SUM(oi.quantity * oi.unit_price)) OVER() as all_revenue,
           SUM(SUM(oi.quantity * oi.unit_price)) OVER(ORDER BY SUM(oi.quantity * oi.unit_price) DESC) as running_total
    FROM products p
    LEFT JOIN order_items oi ON p.stock_code = oi.stock_code
    GROUP BY p.description
),
cumulative_percent AS(
    SELECT description, revenue,
           ROUND((CAST(running_total AS DECIMAL) / all_revenue) * 100, 2) AS cumulative_percent
    FROM cumulative_percentage
)
SELECT description, 
       revenue, 
       cumulative_percent, 
       CASE
           WHEN cumulative_percent <= 80 THEN 'A tier'
           WHEN cumulative_percent <= 95 THEN 'B tier'
           ELSE 'C tier' 
       END AS tier
FROM cumulative_percent
ORDER BY revenue DESC;