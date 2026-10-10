-- models/lesson_db/staging/stg_sessions.sql

/* 
  Model-Konfiguration:
  Erstellt das Staging-Model als View in der Datenbank.
*/
{{ config(
    materialized='view'
) }}

/* 
  CTE: source
  Holt die unbereinigten Rohdaten der Sessions aus der Quelle 'lesson.raw_sessions'.
*/
with source as (

    select *
    from {{ source('lesson', 'raw_sessions') }}

),

/* 
  CTE: cleaned
  Bereinigt Textfelder, konvertiert Datentypen und wandelt leere Strings bei IDs in echten NULL-Wert um.
*/
cleaned as (

    select
        -- Konvertiert Identifikatoren und Datumsfelder explizit in ihre korrekten Datentypen
        cast(user_id as integer) as user_id,
        cast(session_id as integer) as session_id,
        cast(session_date as date) as session_date,

        -- Entfernt führende und nachstehende Leerzeichen beim Kanalnamen
        trim(channel) as channel,

        -- Konvertierung des Kanal-Codes zur Verknüpfung mit der Lookup-Tabelle
        cast(channel_code as integer) as channel_code,

        -- Konvertiert die Marketingkosten in ein numerisches Format
        cast(costs as numeric) as costs,

        -- Wandelt leere Zeichenketten ('') bei fehlender Leasing-Vertrags-ID sauber in NULL um
        nullif(trim(leasing_contract_id), '') as leasing_contract_id,

        -- Entfernt Leerzeichen beim verwendeten Endgerät (z. B. Mobile, Desktop)
        trim(device) as device

    from source

)

-- Finale Ausgabe der bereinigten Session-Daten
select *
from cleaned
