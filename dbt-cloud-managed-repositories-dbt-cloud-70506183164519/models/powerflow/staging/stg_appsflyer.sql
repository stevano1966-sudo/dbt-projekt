-- models/powerflow/staging/stg_appsflyer.sql

-- Staging-Modell für die AppsFlyer-Marketingdaten zur Standardisierung der Spalten
{{
  config(
    materialized='view'
  )
}}

with raw_data as (
    -- Laden der sauberen Rohdaten aus der AppsFlyer-Quelle
    select 
        device_id,
        attribution_time,
        channel,
        campaign_id,
        attribution_cost
    from {{ source('powerflow', 'appsflyer_raw') }}
)

select 
    device_id,
    attribution_time,
    channel,
    campaign_id,
    attribution_cost
from raw_data
