--int_session_lease_enriched.sql
{{ config(
    materialized='view'
) }}

with sessions as (

    select *
    from {{ ref('int_sessions_labeled') }}

),

leases as (

    select *
    from {{ ref('stg_leases_month') }}

),

joined as (

    select

        s.user_id,
        s.session_id,
        s.session_date,
        s.channel,
        s.channel_code,
        s.channel_type,
        s.costs,
        s.device,

        l.leasing_contract_id,
        l.saleprice_gross,

        datediff(
            day,
            s.session_date,
            l.contract_start_date
        ) as days_to_contract,

        case
            when l.leasing_contract_id is not null
            then 1
            else 0
        end as is_conversion

    from sessions s

    left join leases l
        on s.leasing_contract_id = l.leasing_contract_id

)

select *
from joined
