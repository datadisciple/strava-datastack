with stream_points as (
    select *
    from {{ ref('int_activity_stream_points') }}
)

, pivoted as (
    select
        activity_id
        , stream_index
        , {{ dbt_utils.pivot(
            'stream_type'
            , dbt_utils.get_column_values(
                table=ref('int_activity_stream_points')
                , column='stream_type'
                , order_by='stream_type'
            )
            , agg='max'
            , then_value='stream_point'
            , else_value='null'
            , quote_identifiers=false
        ) }}

    from stream_points
    group by all
)

, deltas as (
    select
        {{ dbt_utils.generate_surrogate_key(['activity_id', 'stream_index']) }} as activity_data_point_id
        , pivoted.*
        , distance - lag(distance) over (partition by activity_id order by stream_index) as distance_delta
        , time - lag(time) over (partition by activity_id order by stream_index) as time_delta
    
    from pivoted
)

, final as (
    select
        activity_data_point_id
        , activity_id
        , stream_index
        , is_moving::boolean as is_moving
        , time
        , altitude
        , cadence
        , distance
        , grade
        , heartrate
        , power
        , case
            when time = 0 and distance is not null then 0
            else distance_delta / time_delta
        end as velocity
        , velocity_smooth
        , distance_delta
        , time_delta
    
    from deltas
)
select *
from final