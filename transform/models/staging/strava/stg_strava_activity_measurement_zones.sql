with source as (
    select *
    from {{ source('strava', 'activity_zones__distribution_buckets') }}
)

, renamed as (
    select
        /* bigint zones used for heartrate & power; convert to double */
        min::double as min
        , max::double as max
        /* double type zones used for pace */
        , min__v_double as pace_min
        , max__v_double as pace_max
        , time
        , _dlt_parent_id as measurement_id

        , _dlt_root_id
        , _dlt_parent_id
        , _dlt_list_idx
        , _dlt_id
    
    from source
)

/* coalesces null min/max for pace with their double values */
, buckets_coalesced as (
    select
        coalesce(min, pace_min) as min
        , coalesce(max, pace_max) as max
        , time
        , measurement_id
        , _dlt_root_id
        , _dlt_parent_id
        , _dlt_list_idx
        , _dlt_id
    
    from renamed
)

, final as (
    select
        {{ dbt_utils.generate_surrogate_key(['min', 'max', 'measurement_id']) }} as activity_measurement_zone_id
        , *
    
    from buckets_coalesced
)

select *
from final