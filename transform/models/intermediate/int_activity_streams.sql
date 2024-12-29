with activity_streams as (
    select *
    from {{ ref('stg_strava_activity_streams') }}
)

, dlt_loads as (
    select *
    from {{ ref('stg_strava_dlt_loads') }}
)

, joined as (
    select
        activity_streams.*
        , dlt_loads.inserted_at
    
    from activity_streams
        left join dlt_loads using (_dlt_load_id)
)

select *
from joined