-- models/tasty_bytes/marts/ephemeral_customer_segment.sql

{{ config(materialized='ephemeral') }}

WITH ephemeral_last_yr_orders AS (
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
FROM ephemeral_last_yr_orders
WHERE order_date >= DATEADD(day, -30, CURRENT_DATE())
ORDER BY total_revenue DESC
