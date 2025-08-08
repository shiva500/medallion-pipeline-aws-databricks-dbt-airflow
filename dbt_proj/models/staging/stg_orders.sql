{{
  config(
    materialized = 'view',
    tags = ['staging']
  )
}}

SELECT
  id AS order_id,
  customer_id,
  order_date,
  status,
  amount
FROM {{ source('ecommerce_raw', 'orders') }}
