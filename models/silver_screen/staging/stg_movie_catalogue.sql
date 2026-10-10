-- Dateiname: stg_movie_catalogue.sql
-- models/silver_screen/staging/stg_movie_catalogue.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- Änderung: 29.09.2026 - Studio "Walt Disney" zu "Disney" vereinheitlicht
-- =========================================================================

WITH source AS (
    SELECT * FROM {{ source('raw_silver_screen', 'movie_catalogue') }}
),

renamed AS (
    SELECT
        movie_id,
        movie_title,
        release_date,
        COALESCE(genre, 'Unknown') AS genre,
        country,
        CASE 
            WHEN TRIM(studio) = 'Walt Disney' THEN 'Disney' 
            ELSE TRIM(studio) 
        END AS studio,
        budget,
        director,
        rating,
        minutes
    FROM source
)

SELECT * FROM renamed