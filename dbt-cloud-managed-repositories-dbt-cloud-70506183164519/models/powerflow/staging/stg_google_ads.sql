-- models/powerflow/staging/stg_google_ads.sql

-- Bereitet die Google Ads Daten vor und fügt den Kanal sowie die fixen Kosten aus dem Seed hinzu
{{
  config(
    materialized='view'
  )
}}

select
    ga.device_id,
    ga.attribution_time,
    'Google_ads' as channel,              -- Neuer einheitlicher Kanalname
    ga.campaign as campaign_id,           -- Spaltenname an AppsFlyer anpassen
    c.cost as attribution_cost            -- Kosten aus dem Seed hinzujoinen
from {{ source('powerflow', 'google_ads') }} as ga
left join {{ ref('campaign_cost') }} as c 
    on ga.campaign = c.campaign_id
