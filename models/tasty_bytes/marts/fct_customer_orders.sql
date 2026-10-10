-- models/tasty_bytes/marts/fct_customer_orders.sql

{{ config(materialized='table') }}

SELECT
    o.order_id,
    o.customer_id,   -- ACHTUNG: Prüfen! Snowflake meldet 'O.CUSTOMER_ID' als ungültig.
                     -- Öffne 'stg_orders.sql' und wähle die Spalte dort aus oder erstelle ein Alias (z. B. customer_id_raw AS customer_id).
    o.total_price,
    l.quantity,
    l.menu_item_id
FROM {{ ref('stg_orders') }} AS o       -- Nutzt ref(), damit dbt die Abhängigkeit erkennt und das richtige Schema wählt
JOIN {{ ref('stg_lineitems') }} AS l    -- Verbindet die Bestellpositionen (Line Items)
    ON o.order_id = l.order_id
