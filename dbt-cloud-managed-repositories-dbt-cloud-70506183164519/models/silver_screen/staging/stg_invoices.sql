-- Dateiname: stg_invoices.sql
-- models/silver_screen/staging/stg_invoices.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- Änderung: 29.09.2026 - Dubletten bereinigt (pro Film, Monat und Standort
--                        genau eine Rechnung)
-- =========================================================================

WITH source AS (
    SELECT * FROM {{ source('raw_silver_screen', 'invoices') }}
),

renamed AS (
    SELECT
        invoice_id,
        movie_id,
        DATE_TRUNC('month', month::DATE) AS month,
        location_id AS location,
        studio,
        release_date,
        weekly_price,
        total_invoice_sum AS rental_cost
    FROM source
),

deduplicated AS (
    SELECT *
    FROM renamed
    -- Dubletten bereinigen: In den Rohdaten gibt es zu einem Film, Monat und
    -- Standort teils mehrere Rechnungen mit unterschiedlicher invoice_id,
    -- gleichen Kosten und einem um einen Tag abweichenden release_date
    -- (z. B. 14.06. und 15.06.2024). Sie würden im Fakt-Modell Zeilen
    -- vervielfachen. Behalten wird pro Film, Monat und Standort die Zeile
    -- mit dem früheren release_date (entspricht dem Filmkatalog); bei
    -- Gleichstand entscheidet die invoice_id.
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY movie_id, month, location
        ORDER BY release_date, invoice_id
    ) = 1
)

SELECT * FROM deduplicated