/*
This was adapted into postgresql from
https://docs.moodle.org/310/en/ad-hoc_contributed_reports#Distinct_user_logins_per_month
and calculates the weekly distinct user logins 
*/
SELECT
--  to_char(to_timestamp("timecreated"),'MM') AS MONTH,
  to_char(to_timestamp("timecreated"),'WW') AS WEEK,
  COUNT(DISTINCT userid) AS distinct_users
  --, round(COUNT(DISTINCT userid)/COUNT(*) over()::numeric,2) AS percent_distinct_user

FROM prefix_logstore_standard_log l
WHERE l.origin='ws'
GROUP BY
--to_char(to_timestamp("timecreated"),'MM'),
to_char(to_timestamp("timecreated"),'WW')
ORDER BY
--to_char(to_timestamp("timecreated"),'MM'),
to_char(to_timestamp("timecreated"),'WW')
