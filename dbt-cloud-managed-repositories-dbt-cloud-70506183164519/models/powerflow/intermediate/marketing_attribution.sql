-- models/powerflow/intermediate/marketing_attribution.sql

-- Wird laut Projektplanung als echte physische Tabelle gespeichert
{{
  config(
    materialized='table'
  )
}}

-- Alle Spalten von Google Ads abrufen
select 
    device_id,
    attribution_time,
    channel,
    campaign_id,
    attribution_cost
from {{ ref('stg_google_ads') }}

union all

-- Alle Spalten von AppsFlyer abrufen
select 
    device_id,
    attribution_time,
    channel,
    campaign_id,
    attribution_cost
from {{ ref('stg_appsflyer') }}
