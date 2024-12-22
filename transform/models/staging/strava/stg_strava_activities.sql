with source as (
    select *
    from {{ source('strava', 'activities') }}
)

select *
from source