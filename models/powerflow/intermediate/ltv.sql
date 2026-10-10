-- models/powerflow/intermediate/ltv.sql

-- Berechnet den kumulierten täglichen Umsatz (LTV) pro Nutzer über dessen Lebensdauer
{{
  config(
    materialized='view'
  )
}}

with reg as (
    -- Ermitteln des ersten Registrierungsdatums pro Nutzer
    select 
        user_id, 
        date(min(registration_time)) as reg_date
    from {{ ref('registrations_clean') }}
    group by user_id
),

daily_purch as (
    -- Aufsummieren des täglichen Umsatzes pro Nutzer aus den Transaktionsdaten
    select 
        user_id, 
        date(transaction_time) as transaction_date,
        sum(total_value) as daily_rev
    from {{ source('powerflow', 'transactions') }}
    group by user_id, transaction_date
)

select 
    p.user_id, 
    p.transaction_date, 
    r.reg_date,
    datediff(day, r.reg_date, p.transaction_date) as lifetime,
    p.daily_rev,
    -- Fensterfunktion zur kumulierten Umsatzberechnung über die Zeit
    sum(p.daily_rev) over (
        partition by p.user_id 
        order by p.transaction_date
    ) as cumulative_daily_rev
from daily_purch as p
left join reg as r 
    on p.user_id = r.user_id
order by p.user_id, p.transaction_date
