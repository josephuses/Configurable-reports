/*
Calculate the amount of storage used for the Day
and the cumulative amount of storage used over days
*/
with data as (
  select
    date_part('day', to_timestamp(timemodified)) as day,
     date_part('month', to_timestamp(timemodified)) as month,
  	date_part('year', to_timestamp(timemodified)) as year,
  	to_char(to_timestamp(timemodified), 'Mon dd YYYY') as date,
    sum(filesize)/(1024*1024*1024) as sumfilesize
  from prefix_files
  group by day, month, year, date
)

select
  date,
  round(sumfilesize,2) as "Storage Used for the Day (in GB)",
  round(sum(sumfilesize) over
      (order by year asc, month asc, day asc rows between unbounded preceding and current row), 2)
      as "Cumulative Storage Used (in GB)"
from data
