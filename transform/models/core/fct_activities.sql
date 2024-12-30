with activities as (
    select *
    from {{ ref('stg_strava_activities') }}
)

, final as (
    select
        activity_id
        , activity_name
        , activity_type
        , sport_type
        , started_at
        , started_at_local
        , timezone
        , utc_offset_seconds
        
        /* Activity stats */
        , elapsed_seconds
        , moving_seconds
        , distance
        , distance_metric
        , cadence_avg
        , hr_avg
        , hr_max
        , speed_avg
        , speed_max
        , speed_avg_metric
        , speed_max_metric
        , power_avg
        , power_weighted_avg
        , power_max
        , temperature_avg
        , temperature_avg_metric
        , elevation_min
        , elevation_max
        , elevation_gain
        , elevation_min_metric
        , elevation_max_metric
        , kilojoules
        , calories_burned

        /* Strava stats */
        , achievement_count
        , pr_count
        , suffer_score
        , athlete_count
        , comment_count
        , kudos_count
        , photo_count
        , photo_count_at_upload

        /* Flags */
        , is_commute
        , is_device_watts
        , is_flagged
        , is_friends_activity
        , has_heartrate
        , has_heartrate_hidden
        , has_kudoed
        , is_manual
        , is_private
        , is_trainer

        , athlete_id
        , external_id
        , gear_id
        , map_id
        , upload_id
        , visibility
        , workout_type
        , location_city
        , location_country
        , location_state

    from activities
)

select *
from final