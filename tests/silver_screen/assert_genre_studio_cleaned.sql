-- Dateiname: assert_genre_studio_cleaned.sql
-- tests/assert_genre_studio_cleaned.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und Bereinigungsprüfungen dokumentiert
-- =========================================================================

-- dbt Singular Test: Überprüfung der Bereinigungsregeln für Genre und Studio
-- Ziel: Sicherstellen, dass Transformationen zur Datenqualität in den Modellen
--       'stg_movie_catalogue' und 'fct_monthly_movie_performance' korrekt greifen.
-- Regel in dbt: Der Test schlägt fehl, wenn mindestens eine Zeile zurückgegeben wird (0 Zeilen = bestanden).

-- 1. Prüfe auf fehlendes oder leeres Genre in den Staging-Daten
select 
    movie_id, 
    'stg_movie_catalogue: genre leer' as problem
from {{ ref('stg_movie_catalogue') }}
where genre is null 
   or trim(genre) = ''

union all

-- 2. Prüfe, ob die Vereinheitlichung der Studio-Bezeichnung in Staging funktioniert hat
--    (Bezeichnung 'Walt Disney' sollte zu 'Disney' bereinigt worden sein)
select 
    movie_id, 
    'stg_movie_catalogue: studio Walt Disney nicht zu Disney korrigiert' as problem
from {{ ref('stg_movie_catalogue') }}
where studio = 'Walt Disney'

union all

-- 3. Prüfe auf fehlendes oder leeres Genre in der Fact-Tabelle
select 
    movie_id, 
    'fct: genre leer' as problem
from {{ ref('fct_monthly_movie_performance') }}
where genre is null 
   or trim(genre) = ''

union all

-- 4. Prüfe die Studio-Bereinigung in der Fact-Tabelle
select 
    movie_id, 
    'fct: studio Walt Disney nicht zu Disney korrigiert' as problem
from {{ ref('fct_monthly_movie_performance') }}
where studio = 'Walt Disney'