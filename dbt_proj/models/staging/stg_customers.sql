{{
  config(
    materialized = 'view',
    tags = ['staging']
  )
}}

SELECT
  id AS customer_id,
  first_name,
  last_name,
  email,
  created_at AS customer_since,
  updated_at AS last_updated
FROM {{ source('ecommerce_raw', 'customers') }}
