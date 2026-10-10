-- Dateiname: stg_nj_002.sql
-- models/silver_screen/staging/stg_nj_002.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- =========================================================================

WITH source AS (
    SELECT * FROM {{ source('raw_silver_screen', 'nj_002') }}
),

renamed AS (
    SELECT
        movie_id,
        DATE_TRUNC('month', date::DATE) AS month,
        'NJ_002' AS location,
        ticket_amount AS tickets_sold,
        ticket_price,
        total_earned AS revenue
    FROM source
)

SELECT * FROM renamed