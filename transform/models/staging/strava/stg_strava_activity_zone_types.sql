with source as (
    select *
    from {{ source('strava', 'activity_zones') }}
)

, renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['_activities_id', 'type']) }} as activity_zone_type_id
        , _activities_id as activity_id
        , _dlt_id as zone_type_id
        , type as zone_type
        , score
        , sensor_based as is_sensor_based
        , coalesce(custom_zones, false) as has_custom_zone_set        
        , _dlt_id
        , _dlt_load_id
    
    from source
)

select *
from renamed