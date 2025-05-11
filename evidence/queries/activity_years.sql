select distinct date_part('year', started_at_local::date) as year
from strava_datastack.fct_activities
where year >= 2016