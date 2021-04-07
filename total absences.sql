/*21
This SQL statement gets the total number of Absences
for each subject for all students in the database.
mod_attendance plugin has to be installed
and additional data for prefix_user_info_data has to be
required from the students (gender, section, grade level)
*/
SELECT
	distinct
	grade.data AS "Grade Level",
	section.data AS "Section",
	c.fullname AS "Subject",
	u.id AS "KHub ID",
	initcap(concat(u.lastname, ', ', u.firstname)) AS "Name",
	sex.data AS "Gender",
  /*
  determine the 'absent' and 'present' records
  for the CRBL, present, late or excused absences are all considered present
  */
	sum(case when attst.acronym = 'A' OR attst.acronym = 'U' then 1 else 0 END) as "Absences"

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
  AND att.sessdate >= 1612108800
  AND att.sessdate < 1614528000
GROUP BY
  "Grade Level"
  , "Section"
  , "Gender"
  , "Name"
  , c.fullname
  , u.id
ORDER BY
  "Grade Level"
  , "Section"
  , "Gender" DESC
  , "Name"
