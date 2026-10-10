-- Dateiname: assert_tickets_not_negative.sql
-- tests/assert_tickets_not_negative.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und Plausibilitätsprüfung dokumentiert
-- =========================================================================

-- dbt Singular Test: Plausibilitätsprüfung für verkaufte Tickets
-- Ziel: Sicherstellen, dass in der Fact-Tabelle 'fct_monthly_movie_performance'
--       keine ungültigen (negativen) oder fehlenden (NULL) Werte bei den verkauften Tickets vorkommen.
-- Regel in dbt: Der Test schlägt fehl, wenn mindestens ein fehlerhafter Datensatz gefunden wird.

select *
from {{ ref('fct_monthly_movie_performance') }}
-- Filter auf unzulässige Ticketwerte
where tickets_sold < 0
   or tickets_sold is null