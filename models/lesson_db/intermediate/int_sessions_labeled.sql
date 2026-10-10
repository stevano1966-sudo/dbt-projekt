-- models/lesson_db/intermediate/int_sessions_labeled.sql

/* 
  Model-Konfiguration:
  Erstellt ein Intermediate-Model als View in der Datenbank.
*/
{{ config(
    materialized='view'
) }}

/* 
  CTE: sessions
  Holt die bereinigten Rohdaten der Nutzer-Sessions aus der Staging-Schicht.
*/
with sessions as (

    select *
    from {{ ref('stg_sessions') }}

),

/* 
  CTE: channels
  Holt das Mapping der Kanal-Codes aus der Staging-Schicht.
*/
channels as (

    select *
    from {{ ref('stg_channel_code') }}

),

/* 
  CTE: joined
  Verknüpft die Sessions mit den Kanal-Stammdaten zur Anreicherung des Kanal-Typs.
*/
joined as (

    select
        -- Identifikatoren und Session-Details
        s.user_id,
        s.session_id,
        s.session_date,
        s.channel,
        s.channel_code,

        -- Angereicherter Kanal-Typ aus der Lookup-Tabelle (z. B. Organic, Paid)
        c.channel_type,

        -- Kosten, Gerätetyp und ggf. verknüpfte Leasing-Vertrags-ID
        s.costs,
        s.device,
        s.leasing_contract_id

    from sessions s

    -- Left Join: Alle Sessions bleiben erhalten, Kanal-Typ wird über den Code ergänzt
    left join channels c
        on s.channel_code = c.channel_code

)

-- Finale Ausgabe aller angereicherten Session-Daten
select *
from joined
