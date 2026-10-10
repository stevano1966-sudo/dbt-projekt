-- models/lesson_db/intermediate/int_session_lease_enriched.sql

/* 
  Model-Konfiguration:
  Erstellt ein Intermediate-Model als View in der Datenbank.
*/
{{ config(
    materialized='view'
) }}

/* 
  CTE: sessions
  Holt die klassifizierten und angereicherten Session-Daten.
*/
with sessions as (

    select *
    from {{ ref('int_sessions_labeled') }}

),

/* 
  CTE: leases
  Holt die bereinigten Leasing-Vertragsdaten aus der Staging-Schicht.
*/
leases as (

    select *
    from {{ ref('stg_leases_month') }}

),

/* 
  CTE: joined
  Verknüpft die Sessions mit den Leasing-Verträgen und berechnet zusätzliche Kennzahlen.
*/
joined as (

    select

        -- Session- und Nutzer-Attribute
        s.user_id,
        s.session_id,
        s.session_date,
        s.channel,
        s.channel_code,
        s.channel_type,
        s.costs,
        s.device,

        -- Leasing-Vertragsdaten
        l.leasing_contract_id,
        l.saleprice_gross,

        -- Dauer in Tagen zwischen der Session und dem Vertragsbeginn
        datediff(
            day,
            s.session_date,
            l.contract_start_date
        ) as days_to_contract,

        -- Conversion-Flag: 1 = Vertrag vorhanden (Erfolg), 0 = kein Vertrag
        case
            when l.leasing_contract_id is not null
            then 1
            else 0
        end as is_conversion

    from sessions s

    -- Left Join: Alle Sessions bleiben erhalten, Verträge werden angehängt
    left join leases l
        on s.leasing_contract_id = l.leasing_contract_id

)

-- Finale Ausgabe aller verknüpften Spalten
select *
from joined
