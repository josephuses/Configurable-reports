/*
This SQL statement collects all of the attendance records
for all students in the database.
mod_attendance plugin has to be installed
and additional data for prefix_user_info_data has to be
required from the students
*/
SELECT
	distinct
	grade.data AS "Grade Level",
	section.data AS "Section",
	u.id AS "KHub ID",
	initcap(concat(u.lastname, ', ', u.firstname)) AS "Name",
	sex.data AS "Gender",
	c.fullname AS "Subject",
  --list the date
	to_char(to_timestamp(att.sessdate),'Mon-dd-YYYY')AS DATE,
  --determine the week number from the start of the school year
	concat('Week ', trunc(date_part('week',to_timestamp(attlog.timetaken-1599436800)))) as "Week",
  /*
  determine the 'absent' and 'present' records
  for the CRBL, present, late or excused absences are all considered present
  */
	case when attst.acronym = 'P' OR attst.acronym = 'L' OR attst.acronym = 'E' then 1 else 0 END as "Present",
	case when attst.acronym = 'A' OR attst.acronym = 'U' then 1 else 0 END as "Absent"

/*
prefix_attendance_sessions, prefix_attendance_log and
prefix_attendance_statuses are all from the mod_attendance module.
The rest of the tables are determined from https://moodleschema.zoola.io/
which I find more intuitive than the official
https://moodleschema.zoola.io/
*/
FROM prefix_attendance_sessions AS att
	JOIN prefix_attendance_log AS attlog ON att.id = attlog.sessionid
	JOIN prefix_attendance_statuses AS attst ON attlog.statusid = attst.id
	JOIN prefix_attendance AS a ON att.attendanceid = a.id
	JOIN prefix_course AS c ON a.course = c.id
	JOIN prefix_user AS u ON attlog.studentid = u.id
	JOIN prefix_role_assignments ra ON u.id = ra.userid
	JOIN prefix_context AS ctx ON ctx.id = ra.contextid
	JOIN (select sex.userid, sex.fieldid, sex.data from prefix_user_info_data AS sex where sex.fieldid = 2) as sex  ON sex.userid = u.id
	JOIN (select grade.userid, grade.fieldid, grade.data from prefix_user_info_data AS grade where grade.fieldid = 3) as grade  ON grade.userid = u.id
	JOIN (select section.userid, section.fieldid, section.data from prefix_user_info_data AS section where section.fieldid = 4) as section  ON section.userid = u.id

WHERE
	ra.roleid = 5
	AND ctx.instanceid = c.id
	AND ctx.contextlevel = 50
  /*
  use unixtime. You can use https://dqydj.com/date-to-unix-time-converter/
  for reference
  */
	AND att.sessdate >= 1614528001
	AND att.sessdate < 1617206401
ORDER BY
	"Grade Level"
	, "Section"
	, "Gender" DESC
	, "Name"
	, c.fullname
	, "Week" ASC
	, DATE
