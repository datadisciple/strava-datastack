with source as (
    select *
    from {{ source('strava', 'activity_streams') }}
)

, renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['_activities_id', 'type']) }} as activity_stream_id
        , _activities_id as activity_id
        , case type
            when 'temp' then 'temperature'
            when 'grade_smooth' then 'grade'
            when 'moving' then 'is_moving'
            when 'watts' then 'power'
            else type
        end as stream_type
        , type as stream_type_raw
        , data as stream_json
        , from_json(data, '["int"]') as stream_list
        , series_type
        , original_size
        , resolution

        , _dlt_id
        , _dlt_load_id
    
    from source
)

select *
from renamed