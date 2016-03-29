require 'sqlite3'
require 'htmlentities'
require 'json'

schoolsFile = File.new("schools.json","r")
db = SQLite3::Database.open("/var/www/rails/optimal_course_scheduler/db/development.sqlite3")

rawSchools = ""

while(line = schoolsFile.gets)
  rawSchools << line
end

schools = JSON.parse(rawSchools)

schools.each do |school|
	name = school["name"]
	title = HTMLEntities.new.decode(school["title"])
	puts "#{name}: #{title}"
	db.execute("insert into schools (name,title) Values (?,?)",name,title)
end

# db.execute("select * from courses") do |row|
# 	school_id = db.execute("Select id from schools where name=?",row[2])[0][0]
# 	puts "#{row[0]}: #{school_id}"
# 	db.execute("update courses set school_id=? where id=?",school_id,row[0])
# end
