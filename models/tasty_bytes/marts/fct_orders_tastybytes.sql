-- models/tasty_bytes/marts/fct_orders_tastybytes.sql

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
  Wählt die zentralen Kennzahlen und Identifikatoren für jede einzelne Bestellung aus (Faktentabelle).
*/
SELECT
    -- Eindeutige Bestell-ID (Primary Key)
    order_id,

    -- Exakter Zeitstempel der Bestellung
    order_ts,

    -- Brutto-Gesamtwert der Bestellung
    order_total,

    -- Enthaltenes Steuer-Volumen der Bestellung
    order_tax_amount

FROM orders
