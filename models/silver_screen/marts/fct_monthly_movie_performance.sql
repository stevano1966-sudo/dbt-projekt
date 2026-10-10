-- Dateiname: fct_monthly_movie_performance.sql
-- models/silver_screen/marts/fct_monthly_movie_performance.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- Änderung: 29.09.2026 - Spalte has_rental_invoice ergänzt
-- =========================================================================

WITH monthly_sales AS (
    SELECT * FROM {{ ref('int_monthly_sales_by_location') }}
),

movies AS (
    SELECT * FROM {{ ref('stg_movie_catalogue') }}
),

invoices AS (
    SELECT * FROM {{ ref('stg_invoices') }}
),

joined_performance AS (
    SELECT
        -- Dimensionen
        s.month,
        s.location_id AS location,
        s.movie_id,
        m.movie_title,
        m.genre,
        m.studio,

        -- Verkaufs-Kennzahlen
        s.tickets_sold,
        s.revenue AS ticket_revenue,

        -- Finanz-Kennzahlen (Mietkosten & Profit)
        COALESCE(i.rental_cost, 0) AS rental_cost,
        i.invoice_id IS NOT NULL AS has_rental_invoice,
        s.revenue - COALESCE(i.rental_cost, 0) AS net_profit

    FROM monthly_sales s
    LEFT JOIN movies m
        ON s.movie_id = m.movie_id
    LEFT JOIN invoices i
        ON s.movie_id = i.movie_id
       AND s.month = i.month
       AND s.location_id = i.location
)

SELECT * FROM joined_performance