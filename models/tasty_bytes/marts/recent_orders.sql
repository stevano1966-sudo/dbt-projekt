-- models/tasty_bytes/marts/recent_orders.sql
{{ config(materialized='incremental') }}

WITH recent_orders AS (
 SELECT
    -- Anpassung auf Snowflake: DATEADD statt INTERVAL
    DATE_TRUNC('day', DATEADD(year, 31, o.order_month)) AS order_date,
    SUM(o.total_price) AS total_revenue,
    SUM(o.total_orders) AS total_orders
 -- Verweis auf deine existierende Tabelle:
 FROM {{ ref('monthly_orders') }} AS o
 WHERE o.order_month <= DATEADD(day, -30, CURRENT_DATE())
 GROUP BY 1
)

SELECT
 order_date,
 total_revenue,
 total_orders
FROM recent_orders
{% if is_incremental() %}
 WHERE order_date > (SELECT MAX(order_date) FROM {{ this }})
{% endif %}
ORDER BY order_date
