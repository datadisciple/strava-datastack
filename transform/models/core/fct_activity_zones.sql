with zone_types as (
    select *
    from {{ ref('stg_strava_activity_zone_types') }}
)

, zones as (
    select *
    from {{ ref('stg_strava_activity_zones') }}
)

, joined as (
    select
        zones.activity_zone_id
        , zone_types.activity_id
        , zone_types.zone_type_id
        , zone_types.zone_type
        , zones.min
        , zones.max
        , zones.zone_seconds
        /* _dlt_list_idx is 0 indexed, but zone_index should be 1 indexed */
        , zones._dlt_list_idx + 1 as zone_index
        , 'Z' || zone_index as zone_name
        , zone_types.is_sensor_based
        , zone_types.has_custom_zone_set

    from zone_types
        /* Very early strava activities (i.e. < 2015) don't seem to have data on individual zones
           so using an inner zone here to remove those rows that would have null activity_zone_ids */
        inner join zones on zone_types.zone_type_id = zones.zone_type_id
)

select *
from joined