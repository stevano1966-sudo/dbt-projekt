-- models/lesson_db/marts/fct_leases_monthly.sql

/* 
  Model-Konfiguration:
  Dieses Model wird als physische Tabelle in der Datenbank materialisiert.
*/
{{ config(
    materialized='table'
) }}

/* 
  CTE: sessions
  Lädt die angereicherten Session-Daten aus der Intermediate-Schicht.
*/
with sessions as (

    select *
    from {{ ref('int_session_lease_enriched') }}

),

/* 
  CTE: monthly_channel
  Aggregiert die Session-Daten auf Monats- und Marketing-Kanal-Ebene.
*/
monthly_channel as (

    select

        -- Trunkiert das Datum auf den ersten Tag des Monats (Aggregationsbasis)
        date_trunc('month', session_date) as month,

        -- Marketing-Kanal (z. B. Organic, Paid Search, Social)
        channel_type,

        -- Anzahl eindeutiger Sessions im Monat/Kanal
        count(distinct session_id) as sessions,

        -- Anzahl eindeutiger Nutzer im Monat/Kanal
        count(distinct user_id) as users,

        -- Anzahl erfolgreicher Conversions (abgeschlossene Leasing-Verträge)
        count(distinct leasing_contract_id) as conversions,

        -- Gesamte Marketingkosten (NULL-Werte werden als 0 gewertet)
        sum(coalesce(costs, 0)) as total_costs,

        -- Gesamter Umsatz (Brutto-Verkaufspreis nur bei erfolgreicher Conversion)
        sum(
            case
                when is_conversion = 1
                then coalesce(saleprice_gross, 0)
                else 0
            end
        ) as total_revenue,

        -- Durchschnittliche Dauer (in Tagen) von der Session bis zum Vertragsabschluss
        avg(
            case
                when is_conversion = 1
                then days_to_contract
            end
        ) as avg_days_to_contract

    from sessions

    -- Gruppierung nach Monat und Kanal
    group by
        date_trunc('month', session_date),
        channel_type

)

/* 
  Hauptabfrage:
  Berechnung von abgeleiteten KPIs und Kennzahlen (Conversion Rate, ROAS etc.)
*/
select

    month,
    channel_type,

    -- Basis-Metriken
    sessions,
    users,
    conversions,

    -- Finanz-Metriken
    total_costs,
    total_revenue,

    -- Durchschnittliche Tage bis zum Vertrag (auf 2 Nachkommastellen gerundet)
    round(avg_days_to_contract, 2) as avg_days_to_contract,

    -- Sessions pro Nutzer (inkl. NULLIF zur Vermeidung von Division-by-Zero-Fehlern)
    round(
        sessions / nullif(users, 0),
        2
    ) as avg_sessions_per_user,

    -- Conversion Rate in Prozent (%)
    round(
        (conversions / nullif(sessions, 0)) * 100,
        2
    ) as conversion_rate_pct,

    -- Return on Ad Spend (ROAS): Verhältnis von Umsatz zu Marketingkosten
    round(
        total_revenue / nullif(total_costs, 0),
        2
    ) as roas

from monthly_channel