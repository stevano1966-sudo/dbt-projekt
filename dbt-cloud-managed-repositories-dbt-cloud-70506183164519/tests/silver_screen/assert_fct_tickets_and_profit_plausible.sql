-- Dateiname: assert_fct_tickets_and_profit_plausible.sql
-- tests/assert_fct_tickets_and_profit_plausible.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und Plausibilitätsprüfungen dokumentiert
-- =========================================================================

-- dbt Singular Test: Fachliche Plausibilitätsprüfung der Kennzahlen
-- Ziel: Identifikation von unlogischen oder fehlerhaften Werten in der Fact-Tabelle
--       'fct_monthly_movie_performance' (Ticketzahlen, Rechnungslogik & Gewinnberechnung).
-- Regel in dbt: Der Test schlägt fehl, wenn eine der Teilabfragen Zeilen zurückgibt.

-- 1. Prüfe auf ungültige Ticketzahlen (NULL oder negativ)
select 
    month, 
    location, 
    movie_id, 
    'tickets negativ oder leer' as problem
from {{ ref('fct_monthly_movie_performance') }}
where tickets_sold is null 
   or tickets_sold < 0

union all

-- 2. Prüfe die korrekte Berechnung des Nettogewinns (net_profit = ticket_revenue - rental_cost)
-- Hinweis: abs(...) > 0.01 fängt gerundete Fließkomma-Abweichungen ab
select 
    month, 
    location, 
    movie_id, 
    'net_profit stimmt nicht' as problem
from {{ ref('fct_monthly_movie_performance') }}
where abs(net_profit - (ticket_revenue - rental_cost)) > 0.01

union all

-- 3. Prüfe die Konsistenz zwischen Rechnungs-Flag und Verleihkosten
-- (Wenn kein Mietvertrag/Rechnung vorliegt, dürfen keine Verleihkosten anfallen)
select 
    month, 
    location, 
    movie_id, 
    'has_rental_invoice passt nicht zu rental_cost' as problem
from {{ ref('fct_monthly_movie_performance') }}
where has_rental_invoice = false
  and rental_cost <> 0