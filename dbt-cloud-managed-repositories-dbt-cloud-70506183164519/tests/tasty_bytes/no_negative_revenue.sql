-- tests/tasty_bytes/no_negative_revenue.sql
SELECT
    order_month,
    total_price -- Nutze die Spalte total_price, da total_revenue in monthly_orders nicht existiert
FROM {{ ref('monthly_orders') }}
WHERE total_price < 0
