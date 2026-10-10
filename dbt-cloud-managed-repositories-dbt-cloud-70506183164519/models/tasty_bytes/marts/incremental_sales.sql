-- models/tasty_bytes/marts/incremental_sales.sql

-- models/incremental_sales.sql
{{ config(materialized='incremental') }}

WITH last_yr_orders AS (
    SELECT
        DATE_TRUNC('day', order_ts) AS order_date,
        SUM(order_total) AS total_revenue,
        COUNT(order_id) AS number_of_order
    FROM TASTY_BYTES_SAMPLE_DATA.RAW_POS.order_header
    GROUP BY 1
)

SELECT
    order_date,
    total_revenue,
    number_of_order
FROM last_yr_orders

-- The incremental filter
{% if is_incremental() %}
  WHERE order_date > (SELECT MAX(order_date) FROM {{ this }})
{% else %}
  -- On the first (full) load, filter to the last 30 days
  WHERE order_date >= DATEADD(day, -30, CURRENT_DATE())
{% endif %}

ORDER BY total_revenue DESC
