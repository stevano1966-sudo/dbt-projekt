-- models/tasty_bytes/marts/monthly_orders.sql

{{ config(materialized='table') }}

-- ============================================================================
-- Modell: monthly_orders
-- Schicht: Marts (Business Layer / Aggregierte Kennzahlen)
-- Zweck: Erstellt eine monatliche Übersicht des Bestellverhaltens pro Kunde.
-- Datenquellen: stg_orders (Bestellkopfdaten), stg_lineitems (Bestellpositionen)
-- ============================================================================

SELECT
    -- Aggregation auf Monatsbasis über den Zeitstempel (order_ts)
    DATE_TRUNC('month', o.order_ts) AS order_month,
    
    -- Kunden-Identifikator für die Gruppierung
    o.customer_id,
    
    -- Berechnung der Kennzahlen pro Kunde und Monat:
    SUM(o.total_price) AS total_price,       -- Gesamter Umsatz
    SUM(l.quantity) AS total_quantity,       -- Gesamte verkaufte Artikelanzahl
    COUNT(o.order_id) AS total_orders        -- Gesamte Anzahl an Bestellungen
FROM
    {{ ref('stg_orders') }} AS o
JOIN
    {{ ref('stg_lineitems') }} AS l
    ON o.order_id = l.order_id
WHERE
    o.customer_id IS NOT NULL                -- Bereinigt NULL-Werte für die not_null Tests
GROUP BY
    1, 2
