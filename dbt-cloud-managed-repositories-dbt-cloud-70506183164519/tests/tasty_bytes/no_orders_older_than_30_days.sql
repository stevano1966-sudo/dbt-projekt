-- tests/tasty_bytes/no_orders_older_than_30_days.sql
SELECT
    order_day
FROM {{ ref('daily_orders') }}
WHERE order_day < DATEADD(day, -30, CURRENT_DATE())
