-- Dateiname: assert_tickets_match_staging.sql
-- tests/assert_tickets_match_staging.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und Abstimm-Test (Reconciliation) dokumentiert
-- =========================================================================

-- dbt Singular Test: Abstimmung der verkauften Tickets (Staging vs. Fact)
-- Ziel: Sicherstellen, dass bei den Transformationen von den Rohdaten im Staging
--       ('stg_location_sales') bis zur finalen Fact-Tabelle ('fct_monthly_movie_performance')
--       keine Ticketverkäufe verloren gehen oder fälschlicherweise dupliziert werden.
-- Regel in dbt: Der Test schlägt fehl, wenn die Gesamtsummen voneinander abweichen.

with stg as (
    -- Summiere alle verkauften Tickets auf Staging-Ebene
    select sum(tickets_sold) as total 
    from {{ ref('stg_location_sales') }}
),

fct as (
    -- Summiere alle verkauften Tickets auf Fact-Ebene
    select sum(tickets_sold) as total 
    from {{ ref('fct_monthly_movie_performance') }}
)

-- Vergleiche beide Gesamtsummen mittels CROSS JOIN
select 
    stg.total as stg_total, 
    fct.total as fct_total
from stg 
cross join fct
-- Gibt eine Zeile zurück (Test schlägt fehl), wenn die Summen nicht übereinstimmen
where stg.total <> fct.total