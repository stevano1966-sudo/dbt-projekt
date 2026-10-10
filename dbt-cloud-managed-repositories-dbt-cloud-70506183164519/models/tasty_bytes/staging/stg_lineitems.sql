-- models/tasty_bytes/staging/stg_lineitems.sql

{{ config(materialized='table') }}

WITH max_date_cte AS (
    -- Ermittelt das aktuellste Bestelldatum aus den Rohdaten für den Datumsfilter
    SELECT MAX(ORDER_TS) AS max_date
    FROM TASTY_BYTES_SAMPLE_DATA.RAW_POS.ORDER_HEADER
)

SELECT
    d.ORDER_DETAIL_ID AS order_detail_id,
    d.ORDER_ID AS order_id,             -- Verknüpfungsschlüssel für fct_customer_orders
    d.MENU_ITEM_ID AS menu_item_id,
    d.QUANTITY AS quantity,
    d.UNIT_PRICE AS unit_price,
    d.PRICE AS line_price,
    d.ORDER_ITEM_DISCOUNT_AMOUNT AS discount_amount,
    h.ORDER_TS AS order_ts
FROM TASTY_BYTES_SAMPLE_DATA.RAW_POS.ORDER_DETAIL d
JOIN TASTY_BYTES_SAMPLE_DATA.RAW_POS.ORDER_HEADER h
    ON d.ORDER_ID = h.ORDER_ID
JOIN max_date_cte m
    -- Filtert nur die Positionen der letzten 30 Tage basierend auf dem maximalen Datum
    ON h.ORDER_TS >= DATEADD('day', -30, m.max_date)
