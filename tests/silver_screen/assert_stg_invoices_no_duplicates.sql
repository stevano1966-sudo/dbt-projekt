-- Dateiname: assert_stg_invoices_no_duplicates.sql
-- tests/assert_stg_invoices_no_duplicates.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und Dubletten-Test dokumentiert
-- =========================================================================

-- dbt Singular Test: Eindeutigkeit der Rechnungen im Staging (No Duplicates)
-- Ziel: Sicherstellen, dass im Staging-Modell 'stg_invoices' pro Kombination 
--       aus Film (movie_id), Monat (month) und Standort (location) 
--       höchstens genau eine Rechnung existiert.
-- Regel in dbt: Ein Test schlägt fehl, wenn dieses Query mindestens eine Zeile zurückgibt.

select 
    movie_id, 
    month, 
    location, 
    count(*) as n
from {{ ref('stg_invoices') }}
-- Gruppierung nach den drei fachlichen Schlüsselfeldern
group by 1, 2, 3
-- Filtert Gruppen mit mehr als einem Datensatz heraus (Dubletten)
having count(*) > 1