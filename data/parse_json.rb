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

# Gets the meetings for each section, then adds that to a meetings array
sections.each do |section|
  sectionMeetings = section["meetings"]
  sectionMeetings.each do |meeting|
    # If a day of week is found in meeting "days" array, then set the coulmn
    # value to true, otherwise, false.
    weekdays.each do |key,value|
      meeting["#{value}"] = (meeting["days"].index(key)) ? "true" : "false"
    end
    # Adds the section's id to the array
    meeting["section_id"] = section["id"]
    meeting["course_id"] = section["course_id"]
    meetings << meeting
  end
end

# puts courses
# puts sections
# puts meetings

##
## This section of the code imports the three created hashmaps as tables
##

# devtest.db is just a copy of my dev "db/development.sqlite3".
db = SQLite3::Database.open("/var/www/rails/optimal_course_scheduler/db/development.sqlite3")

# Add courses

puts "Adding courses"
courses.each do |course|
  db.execute("insert into courses (course_id,credits,college,title) values(?,?,?,?)",
    course["id"],course["credit"],course["college"],course["title"])
end

puts "Adding sections"
sections.each do |section|
  db.execute("insert into sections (section_id,course_id) values(?,?)",
    section["id"],db.execute("select id from courses where course_id=\'#{section["course_id"]}\'"))
end

puts "Adding meetings"
meetings.each do |meeting|
  id_course = db.execute("select id from courses where course_id=\'#{meeting["course_id"]}\' limit 1")[0][0]
  id_section = db.execute("select id from sections where course_id=\'#{id_course}\' limit 1")[0][0]
#  puts "#{meeting["course_id"]}: #{meeting["section_id"]}, #{id_course}: #{id_section}"
  db.execute("insert into meetings (section_id,course_id,location,start_time,end_time," +
  "monday,tuesday,wednesday,thursday,friday) values(?,?,?,?,?,?,?,?,?,?)",
    id_section,
    id_course,
    meeting["location"],
    Time.parse(meeting["start_time"]).strftime("%H:%M:%S"),
    Time.parse(meeting["end_time"]).strftime("%H:%M:%S"),
    meeting["monday"],
    meeting["tuesday"],
    meeting["wednesday"],
    meeting["thursday"],
    meeting["friday"])
end
