-- models/tasty_bytes/staging/stg_orders.sql

{{ config(materialized='ephemeral') }}

WITH source AS (

    SELECT * 
    FROM TASTY_BYTES_SAMPLE_DATA.RAW_POS.order_header

),

renamed AS (

    SELECT
        -- Basis-IDs
        order_id,
        customer_id,
        order_ts,

        -- NEU FÜR DEINE TESTS:
        DAYOFWEEK(order_ts) AS day_of_week,
        order_total AS total_revenue,
        1 AS total_quantity,

        -- WIEDER HINZUGEFÜGT FÜR DIE MARTS:
        order_total,                  -- Wird von fct_daily_revenue & stg_recent_orders gesucht
        order_total AS total_price,   -- Wird von fct_customer_orders gesucht
        order_tax_amount              -- Wurde vorher mit ausgewählt

    FROM source
    -- Filter für 1995 (Entferne diese Zeile testweise, falls die Marts-Modelle leer bleiben)
    WHERE YEAR(order_ts) = 1995

)

SELECT * FROM renamed
