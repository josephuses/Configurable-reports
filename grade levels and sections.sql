/*
This requires grade levels as input for prefix_course_categories
This creates a record of grades and sections in KHub (moodle)
*/

SELECT distinct
	c.shortname as "Section"
	, sex.data AS "Gender"
	, initcap(concat(u.lastname, ', ', u.firstname)) AS "Name"
	, u.username as "Email"
	, u.phone1 as "Phone"
	/*, NULLIF(regexp_replace(cats.name, '\D','','g'), '')::numeric as "Grade"*/
FROM prefix_course AS c
JOIN prefix_groups AS g ON g.courseid = c.id
JOIN prefix_groups_members AS m ON g.id = m.groupid
JOIN prefix_user AS u ON m.userid = u.id
JOIN prefix_role_assignments ra ON u.id = ra.userid
JOIN prefix_context AS ctx ON ctx.id = ra.contextid
JOIN prefix_course_categories AS cats ON c.category = cats.id
JOIN prefix_user_info_data AS sex ON sex.userid = u.id
WHERE  ra.roleid = 5 AND ctx.instanceid = c.id AND ctx.contextlevel = 50
/*
filter user id to include only students
modify to suit your use case
*/
		AND u.id > 122 AND NOT u.id = 931
		AND cats.name IN
		('Grade10'
		 ,'Grade11'
		 ,'Grade12'
		 ,'Grade7'
		 ,'Grade8'
		 ,'Grade9')
ORDER BY c.shortname, "Gender" desc, "Name"
