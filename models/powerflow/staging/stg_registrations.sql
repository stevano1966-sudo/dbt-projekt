-- models/powerflow/staging/stg_registrations.sql

-- Staging-Modell für die Registrierungen inklusive der benötigten Geräte-ID
{{
  config(
    materialized='view'
  )
}}

with raw_data as (
    -- Laden der Rohdaten und Zuordnung der Spalten C1, C2 und C3
    select 
        C1 as user_id,
        C2 as registration_time,
        C3 as device_id
    from {{ source('powerflow', 'registrations_raw') }}
)

select 
    user_id,
    registration_time,
    device_id
from raw_data
-- Filtert unvollständige Profile heraus, bei denen die user_id fehlt
where user_id is not null
