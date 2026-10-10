-- models/lesson_db/staging/stg_recent_orders.sql

/* 
  CTE: last_yr_orders
  Filtert Bestellungen aus dem Jahr 1995, simuliert ein aktuelles Datum durch Hinzufügen von 30 Jahren 
  und aggregiert Tagesumsätze sowie die Anzahl der Bestellungen.
*/
WITH last_yr_orders AS (
    SELECT
        -- Verschiebt das Bestelldatum um +30 Jahre in die Zukunft und trunkiert es auf den Tag
        DATE_TRUNC('day', DATEADD(year, 30, order_ts)) AS calculated_order_date,
        
        -- Gesamter Tagesumsatz
        SUM(order_total) AS total_revenue,
        
        -- Gesamtzahl der Bestellungen pro Tag
        COUNT(order_id) AS number_of_orders

    FROM {{ ref('stg_orders') }}

    -- Filtert ausschließlich auf Daten aus dem Jahr 1995
    WHERE YEAR(order_ts) = 1995

    -- Gruppierung nach dem berechneten Tagesdatum (1. Spalte in SELECT)
    GROUP BY 1
)

/* 
  Hauptabfrage:
  Filtert die aggregierten Werte auf die letzten 30 Tage ab dem aktuellen Datum 
  und sortiert nach dem höchsten Tagesumsatz.
*/
SELECT 
    calculated_order_date,
    total_revenue,
    number_of_orders
FROM last_yr_orders

-- Berücksichtigt nur Tage innerhalb des Zeitfensters der letzten 30 Tage ab heute
WHERE calculated_order_date >= DATEADD('day', -30, CURRENT_DATE())

-- Sortiert das Ergebnis absteigend nach dem Umsatz (höchster Umsatz zuerst)
ORDER BY total_revenue DESC
