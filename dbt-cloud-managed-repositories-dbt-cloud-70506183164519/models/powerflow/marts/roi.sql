-- models/powerflow/marts/roi.sql

-- Das finale ROI-Modell zur Verknüpfung von LTV-Umsätzen und Marketing-Attributionskosten
{{
  config(
    materialized='table'
  )
}}

select 
    l.user_id, 
    l.lifetime, 
    l.cumulative_daily_rev, 
    a.channel, 
    a.campaign_id,
    a.attribution_cost, 
    -- Sichere Division durch Null für organische Kanäle via DIV0()
    div0(l.cumulative_daily_rev, a.attribution_cost) as roi
from {{ ref('ltv') }} as l
inner join {{ ref('users_with_attribution') }} as a
    on l.user_id = a.user_id
