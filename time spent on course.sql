/*
Determine the amount of time spent (in seconds) on each course by each student.
You can use this to correlate with the performance of students in each subject.
This was adapted to postgresql from
https://docs.moodle.org/310/en/ad-hoc_contributed_reports#User.27s_accumulative_time_spent_in_course
This is quite slow.
*/
select
	initcap(prev.Name) as "Name",
	prev.userid,
	prev.fullname,
	sum(case when prev.timecreated - prev.prev_time < 7200 then delta + (prev.timecreated-prev.prev_time) else 0 end) as sumtime
FROM
(select l.id,
       l.timecreated,
 	   concat(u.lastname, ', ', u.firstname) as Name,
       to_char(to_timestamp(l.timecreated), 'Mon dd yyyy') as dtime,
       lag(l.timecreated) over w as prev_time,
       l.timecreated - lag(l.timecreated) over w as delta,
       l.userid as userid,
 	   c.fullname
FROM prefix_logstore_standard_log AS l
 	left join prefix_course c ON l.courseid = c.id
 	left join prefix_user u ON l.userid = u.id
window w as (partition by l.userid order by l.id)) as prev
where prev.userid > 122 AND NOT prev.userid = 931 AND
-- use unixtime
prev.timecreated >= 1599436800
group by prev.userid, prev.fullname, prev.name
