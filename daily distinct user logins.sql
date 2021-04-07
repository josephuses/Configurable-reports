/*
This was adapted to postgresql from
https://docs.moodle.org/310/en/ad-hoc_contributed_reports#Distinct_user_logins_per_month
*/
SELECT
 to_char(to_timestamp(l.timecreated), 'Mon-dd-YYYY') AS DATE,
 COUNT(DISTINCT l.userid) AS "DistinctUserLogins"
FROM prefix_logstore_standard_log l
WHERE l.action = 'loggedin' --AND date_part('year', to_timestamp(l.timecreated)) = '2020'
GROUP BY DATE
