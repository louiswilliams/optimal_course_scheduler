require 'rubygems'
require 'json'

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
      meeting["#{value}"] = (meeting["days"].index(key)) ? true : false
    end
    # Adds the section's id to the array
    meeting["section"] = section["id"]
    meetings << meeting
  end
end

# puts courses
# puts sections
# puts meetings

##
## This section of the code imports the three created hashmaps as tables
##

