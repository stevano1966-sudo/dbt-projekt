   -- Dateiname: assert_fct_totals_match_intermediate.sql
   -- tests/assert_fct_totals_match_intermediate.sql
   -- =========================================================================
   -- dbt & Snowflake Analytics Engineering
   -- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
   -- Snowflake · dbt Cloud
   -- Ersteller: Milomir Stevanovic
   -- Datum: 29.09.2026
   -- =========================================================================
   -- Singular-Test: Liefert nur Zeilen zurück, wenn die Summen im Fakt-Modell
   -- von denen des Intermediate-Modells abweichen (z. B. durch Zeilen-
   -- vervielfachung im Join). Keine Zeilen = Test bestanden.

   SELECT
       f.tickets_fct, i.tickets_int,
       f.revenue_fct, i.revenue_int
   FROM (
       SELECT SUM(tickets_sold) AS tickets_fct, SUM(ticket_revenue) AS revenue_fct
       FROM {{ ref('fct_monthly_movie_performance') }}
   ) f
   CROSS JOIN (
       SELECT SUM(tickets_sold) AS tickets_int, SUM(revenue) AS revenue_int
       FROM {{ ref('int_monthly_sales_by_location') }}
   ) i
   WHERE f.tickets_fct <> i.tickets_int
      OR f.revenue_fct <> i.revenue_int