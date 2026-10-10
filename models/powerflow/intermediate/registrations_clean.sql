-- models/powerflow/intermediate/registrations_clean.sql

-- Materialisiert eine physische Tabelle mit vollständig abgeschlossenen Registrierungen und IDs
{{
  config(
    materialized='table'
  )
}}

with staging_data as (
    -- Nutzen der erweiterten Staging-View
    select 
        user_id,
        registration_time,
        device_id
    from {{ ref('stg_registrations') }}
)

select 
    user_id,
    registration_time,
    device_id
from staging_data
-- Zusätzlicher Sicherheitsfilter laut Kursvorgabe
where user_id is not null
