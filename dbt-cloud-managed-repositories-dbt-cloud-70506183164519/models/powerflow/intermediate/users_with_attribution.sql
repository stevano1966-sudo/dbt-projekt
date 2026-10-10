-- models/powerflow/intermediate/users_with_attribution.sql

-- Verknüpft Registrierungen mit Marketingdaten und kennzeichnet organische Nutzer
{{
  config(
    materialized='view'
  )
}}

select 
    reg.user_id, 
    reg.registration_time,
    reg.device_id,
    m.attribution_time, 
    coalesce(m.channel, 'organic') as channel,
    coalesce(m.campaign_id, 'organic') as campaign_id,
    coalesce(m.attribution_cost, 0) as attribution_cost
from {{ ref('registrations_clean') }} as reg
left join {{ ref('marketing_attribution') }} as m
    on reg.device_id = m.device_id
