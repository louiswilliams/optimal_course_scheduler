require 'rubygems'
require 'json'
require 'sqlite3'

##
## This section of the code just parses the two JSON files to create
## 3 hashmaps that will be added as tables later in the code
##

# Assuming these are your filenames
courseFile = File.new("courses.json","r")
sectionFile = File.new("sections.json","r")

rawCourses = ""
rawSections = ""

while(line = courseFile.gets)
  rawCourses << line
end

while(line = sectionFile.gets)
  rawSections << line
end

# Our three JSON arrays, one for each table that we're adding to
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

# Add courses
puts "Adding courses"
courses.each do |course|
  db.execute("insert into courses (name,credits,college,title) values(?,?,?,?)",
    course["id"],course["credit"],course["college"],course["title"])
  puts course
end

puts "Adding sections"
sections.each do |section|
  course_id = db.execute("select id from courses where name=? AND college=?",
    section["course_id"],
    section["college"])[0][0]
  db.execute("insert into sections (name,course_id) values(?,?)",section["id"],course_id)
  puts section["college"] + " " + section["course_id"] + " - " + section["id"] + ". COURSE.id: #{course_id}" 

  puts "---Meetings---"
  # Now for the section's meetings
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
