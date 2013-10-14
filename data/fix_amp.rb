require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.open("/var/www/rails/optimal_course_scheduler/db/development.sqlite3")

courses = db.execute("Select * from courses");
courses.each do |course|
  title = course[4]
  if /&amp;/.match(title)
    replace = title.gsub("\&amp;","&")
    db.execute("Update courses set title=? Where id=?",replace,course[0])
    print replace + "\n"
#  else 
#    print name
  end
end
