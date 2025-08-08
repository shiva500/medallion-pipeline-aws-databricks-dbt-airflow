{{
  config(
    materialized = 'table',
    tags = ['marts'],
    partition_by = ['customer_since_month']  
  )
}}

WITH customers AS (
  SELECT * FROM {{ ref('stg_customers') }}
),

orders AS (
  SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(*) AS total_orders,
    SUM(amount) AS lifetime_value
  FROM {{ ref('stg_orders') }}
  GROUP BY 1
)

SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  c.customer_since,
  DATE_TRUNC('MONTH', c.customer_since) AS customer_since_month,
  c.last_updated,
  o.first_order_date,
  o.last_order_date,
  o.total_orders,
  o.lifetime_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
