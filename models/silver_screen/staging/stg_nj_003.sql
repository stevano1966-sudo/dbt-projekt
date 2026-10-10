-- Dateiname: stg_nj_003.sql
-- models/silver_screen/staging/stg_nj_003.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- =========================================================================

WITH source AS (
    SELECT * FROM {{ source('raw_silver_screen', 'nj_003') }}
),

filtered_and_renamed AS (
    SELECT
        transaction_id,
        details AS movie_id,
        DATE_TRUNC('month', timestamp::DATE) AS month,
        'NJ_003' AS location,
        amount AS tickets_sold,
        price AS ticket_price,
        total_value AS revenue
    FROM source
    WHERE LOWER(product_type) = 'ticket'
)

SELECT * FROM filtered_and_renamed