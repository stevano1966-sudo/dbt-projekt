-- Dateiname: stg_nj_001.sql
-- models/silver_screen/staging/stg_nj_001.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- =========================================================================

WITH source AS (
    SELECT * FROM {{ source('raw_silver_screen', 'nj_001') }}
),

renamed AS (
    SELECT
        transaction_id,
        movie_id,
        DATE_TRUNC('month', timestamp::DATE) AS month,
        'NJ_001' AS location,
        ticket_amount AS tickets_sold,
        price AS ticket_price,
        transaction_total AS revenue,
        is_discounted,
        is_3d
    FROM source
)

SELECT * FROM renamed