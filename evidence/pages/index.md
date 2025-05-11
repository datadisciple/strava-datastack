---
title: Strava Overview
queries:
  - activity_years: activity_years.sql
---

<Dropdown data={activity_years} name=year value=year>
    <DropdownOption value="%" valueLabel="All Years"/>
</Dropdown>

```sql activity_time_by_type
select
  date_trunc('month', started_at_local::date) as month
  , activity_type
  , round(sum(moving_seconds/3600), 1) as activity_hours
from strava_datastack.fct_activities
where started_at_local::date >= '2016-01-01'
    and date_part('year', started_at_local::date) like '${inputs.year.value}'
group by 1, 2
```

<BarChart
    data={activity_time_by_type}
    title="Hours per activity type by month"
    x=month
    y=activity_hours
    series=activity_type
/>