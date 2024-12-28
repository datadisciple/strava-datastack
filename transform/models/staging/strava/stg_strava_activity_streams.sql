with source as (
    select *
    from {{ source('strava', 'activity_streams') }}
)

, renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['_activities_id', 'type']) }} as activity_stream_id
        , _activities_id as activity_id
        , type
        , data
        , series_type
        , original_size
        , resolution

        , _dlt_id
        , _dlt_load_id
    
    from source
)

select *
from renamed