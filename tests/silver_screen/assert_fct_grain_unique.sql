-- Dateiname: assert_fct_grain_unique.sql
-- tests/assert_fct_grain_unique.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und SQL-Singular-Test ausführlich kommentiert
-- =========================================================================

-- dbt Singular Test: Eindeutigkeit der Körnungsebene (Grain Uniqueness)
-- Ziel: Sicherstellen, dass die Fact-Tabelle 'fct_monthly_movie_performance'
--       pro Kombination aus Film (movie_id), Monat (month) und Standort (location)
--       genau einen Datensatz enthält.
-- Regel in dbt: Ein Test schlägt fehl, wenn dieses Query mindestens eine Zeile zurückgibt.

select 
    movie_id, 
    month, 
    location, 
    count(*) as n
from {{ ref('fct_monthly_movie_performance') }}
-- Gruppierung nach den drei Fachschlüsseln (Positionen 1, 2 und 3 im SELECT)
group by 1, 2, 3
-- Filter auf Gruppen mit mehr als einem Eintrag (Dubletten-Erkennung)
having count(*) > 1