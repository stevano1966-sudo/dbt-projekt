-- Dateiname: stg_location_sales.sql
-- models/silver_screen/staging/stg_location_sales.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- Änderung: 29.09.2026 - baut auf stg_nj_001 bis stg_nj_003 auf (ref statt
--                        source), damit die Bereinigung je Standort nur
--                        einmal im Projekt existiert
-- =========================================================================

WITH nj_001 AS (
    SELECT
        movie_id,
        month,
        location AS location_id,
        tickets_sold,
        revenue
    FROM {{ ref('stg_nj_001') }}
),

nj_002 AS (
    SELECT
        movie_id,
        month,
        location AS location_id,
        tickets_sold,
        revenue
    FROM {{ ref('stg_nj_002') }}
),

nj_003 AS (
    SELECT
        movie_id,
        month,
        location AS location_id,
        tickets_sold,
        revenue
    FROM {{ ref('stg_nj_003') }}
),

combined AS (
    SELECT * FROM nj_001
    UNION ALL
    SELECT * FROM nj_002
    UNION ALL
    SELECT * FROM nj_003
)

SELECT * FROM combined
