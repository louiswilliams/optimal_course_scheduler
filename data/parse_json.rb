require 'rubygems'
require 'htmlentities'
require 'json'
require 'sqlite3'

##
## This section of the code just parses the two JSON files to create
## 3 hashmaps that will be added as tables later in the code
##

# Assuming these are your filenames
courseFile = File.new("courses.json","r")
sectionFile = File.new("sections.json","r")
schoolsFile = File.new("schools.json","r")

rawSchools = ""
rawCourses = ""
rawSections = ""

while(line = schoolsFile.gets)
  rawSchools << line
end

while(line = courseFile.gets)
  rawCourses << line
end

while(line = sectionFile.gets)
  rawSections << line
end

# Our three JSON arrays, one for each table that we're adding to
schools = JSON.parse(rawSchools)
courses = JSON.parse(rawCourses) 
sections = JSON.parse(rawSections)
meetings = []

# Hashmap of days of week. Used to create a boolean column for each day of week
# (Is this efficient?)
weekdays = {"M" => "monday","T" => "tuesday","W" => "wednesday","R" => "thursday","F" => "friday"}

##
## This section of the code imports the three created hashmaps as tables
##

# devtest.db is just a copy of my dev "db/development.sqlite3".
db = SQLite3::Database.open("/var/www/rails/optimal_course_scheduler/db/development.sqlite3")


puts "Adding schools"
schools.each do |school|
  name = school["name"]
  title = HTMLEntities.new.decode(school["title"])
  puts "#{name}: #{title}"
  db.execute("insert into schools (name,title) Values (?,?)",name,title)
end

schools_tmp = db.execute("select id,name from schools")
schoolsMap = Hash.new
schools_tmp.each do |school|
  schoolsMap[school[1]] = school[0]
end

# Add courses

puts "Adding courses"
courses.each do |course|
  db.execute("insert into courses (name,credits,school_id,title) values(?,?,?,?)",
    course["id"],course["credit"],schoolsMap[course["school"]],course["title"])
  puts course
end

puts "Adding sections"
sections.each do |section|
  course_id = db.execute("select id from courses where name=? AND school_id=?",
    section["course_id"],
    schoolsMap[section["school"]])[0][0]
  puts "#{course_id} #{section['crn']}"

  db.execute("insert into sections (name,course_id,crn) values(?,?,?)",section["id"],course_id,section["crn"])
  puts section["school"] + " " + section["course_id"] + " - " + section["id"] + ". COURSE.id: #{course_id}" 

  puts "---Meetings---"
  # Now for the sectiown's meetings
  section["meetings"].each do |meeting|
    # If a day of week is found in meeting "days" array, then set the coulmn
    # value to true, otherwise, false.
    weekdays.each do |key,value|
      meeting["#{value}"] = (meeting["days"].index(key)) ? "true" : "false"
    end

    # Get last inserted row in sections (The section id for meetings to reference)
    section_id = db.execute("Select id from sections Order By id Desc Limit 1")[0]
   
    db.execute("insert into meetings (section_id,course_id,location,start_time,end_time," +
        "monday,tuesday,wednesday,thursday,friday) values(?,?,?,?,?,?,?,?,?,?)",
      section_id,
      course_id,
      meeting["location"],
      Time.parse(meeting["start_time"]).strftime("%H:%M:%S"),
      Time.parse(meeting["end_time"]).strftime("%H:%M:%S"),
      meeting["monday"],
      meeting["tuesday"],
      meeting["wednesday"],
      meeting["thursday"],
      meeting["friday"])
    puts meeting["location"]
  end

end
