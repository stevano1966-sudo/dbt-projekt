-- models/tasty_bytes/marts/daily_orders.sql
SELECT
    order_id,
    customer_id,
    {{ format_order_date('order_ts') }} AS order_day,
    total_price
FROM {{ ref('stg_orders') }}
WHERE customer_id IS NOT NULL
