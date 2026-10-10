-- models/tasty_bytes/marts/fct_daily_revenue.sql

/* 
  CTE: orders
  Lädt die bereinigten Bestelldaten aus dem Staging-Model für Tasty Bytes.
*/
WITH orders AS (

    SELECT * 
    FROM {{ ref('stg_orders') }}

)

/* 
  Hauptabfrage:
  Aggregiert die Bestellungen auf Tagesebene zur Berechnung von Tagesumsatz, Steuer und Bestellanzahl.
*/
SELECT
    -- Trunkiert den Zeitstempel der Bestellung auf das reine Datum (YYYY-MM-DD)
    DATE(order_ts)           AS order_date,

    -- Gesamtanzahl der getätigten Bestellungen pro Tag
    COUNT(order_id)           AS num_orders,

    -- Gesamter Brutto-Umsatz pro Tag
    SUM(order_total)          AS total_revenue,

    -- Gesamte anfallende Steuer pro Tag
    SUM(order_tax_amount)      AS total_tax

FROM orders

-- Gruppierung nach dem Bestelldatum
GROUP BY DATE(order_ts)
