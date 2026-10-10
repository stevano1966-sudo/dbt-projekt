-- Dateiname: int_monthly_sales_by_location.sql
-- models/silver_screen/intermediate/int_monthly_sales_by_location.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 28.09.2026
-- =========================================================================

SELECT 
    month,
    movie_id,
    location_id,
    SUM(tickets_sold) AS tickets_sold,
    SUM(revenue) AS revenue
FROM {{ ref("stg_location_sales") }}
GROUP BY 
    month, 
    movie_id, 
    location_id;