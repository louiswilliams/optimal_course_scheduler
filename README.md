optimal_course_scheduler
========================

Development site: http://course.us.to/
--------------------------------------

A Ruby on Rails application to display all course information, and also create an optimal schedule for a semester of courses (this part is still in development).

API Documentation
-----------------

There is an exposed API to retrieve all course scheduling information.

Hierarchy of models: Schools > Courses > Sections > Meetings

To retrieve JSON data about a school, course, section, or meeting, create a query in one of the following format (Parentheses indicate optional values):

`/school(s).json` All schools
`/school/[SCHOOL_NAME].json` Courses from this school
`/school/[SCHOOL_NAME]/[COURSE_NAME].json` Sections from this course
`/school/[SCHOOL_NAME]/[COURSE_NAME]/[SECTION_NAME].json` Meetings from this section

[SCHOOL_NAME]: The school code (CS,PHYS,APPH, etc.)
[COURSE_NAME]: The course code (1100,1501,4001, etc. )
[SECTION_NAME]: The section code (A,B,A01, etc.)

Other comments
--------------

The "/data" folder contains scripts to add JSON files containing course and sections data to the development database.
This also contains said JSON files.

Louis Williams 2013