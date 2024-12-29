with source as (
    select *
    from {{ source('strava', 'activities') }}
)

, renamed as (
    select
        id as activity_id
        , name
        , start_date as started_at
        , start_date_local as started_at_local
        , achievement_count
        , pr_count
        , athlete__resource_state as athlete_resource_state
        , athlete_count
        , average_cadence as cadence_avg
        , average_heartrate as hr_avg
        , max_heartrate as hr_max
        /* Convert m/s to mph */
        , average_speed * (1/1609.344) * 3600 as speed_avg
        , max_speed * (1/1609.344) * 3600 as speed_max
        /* Convert m/s to kph */
        , average_speed * (1/1000) * 3600 as speed_avg_metric
        , max_speed * (1/1000) * 3600 as speed_max_metric
        , average_watts as watts_avg
        , weighted_average_watts as watts_weighted_avg
        , max_watts as watts_max
        /* Conver C to F */
        , average_temp * (9/5) + 32 as temperature_avg
        , average_temp as temperature_avg_metric
        , comment_count
        /* Convert m to mi */
        , distance * (1/1609.344) * 3600 as distance
        /* Convert m to km */
        , distance * (1/1000) as distance_metric
        , elapsed_time as elapsed_seconds
        , moving_time as moving_seconds
        /* Convert m to ft */
        , elev_low * 3.280839895 as elevation_min
        , elev_high * 3.280839895 as elevation_max
        /* Convert m to ft */
        , total_elevation_gain * 3.280839895 as elevation_gain
        , elev_low as elevation_min_metric
        , elev_high as elevation_max_metric
        , kilojoules
        /* Convert kJ to kcal */
        , kilojoules * (1/4.184) as calories_burned
        , kudos_count
        , location_city
        , location_country
        , location_state
        , map__resource_state as map_resource_state
        , map__summary_polyline as map_summary_polyline
        , photo_count as photo_count_at_upload
        , total_photo_count as photo_count
        , resource_state
        , type
        , sport_type
        , suffer_score
        , timezone
        , utc_offset as utc_offset_seconds
        , upload_id_str
        , visibility
        , weighted_average_watts
        , case
            when workout_type in (1, 11) then 'Race'
            when workout_type = 2 then 'Long Run'
            when workout_type in (3, 12) then 'Workout'
            when workout_type in (0, 10) or workout_type is null then 'None'
            else 'Unknown'
        end as workout_type
        , workout_type as workout_type_raw

        , commute as is_commute
        , device_watts as is_device_watts
        , flagged as is_flagged
        , from_accepted_tag as is_friends_activity
        , has_heartrate as has_heartrate
        , display_hide_heartrate_option as has_display_hide_heartrate_option
        , heartrate_opt_out as has_heartrate_hidden
        , has_kudoed
        , manual as is_manual
        , private as is_private
        , trainer as is_trainer

        , athlete__id
        , external_id
        , gear_id
        , map__id as map_id
        , upload_id

        , _dlt_id
        , _dlt_load_id

    from source
)

select *
from renamed