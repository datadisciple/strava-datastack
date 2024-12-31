with source as (
    select *
    from {{ source('strava', '_dlt_loads') }}
)

, renamed as (
    select
        load_id as _dlt_load_id
        , schema_name
        , status
        , inserted_at
        , schema_version_hash
    
    from source
)

select *
from renamed