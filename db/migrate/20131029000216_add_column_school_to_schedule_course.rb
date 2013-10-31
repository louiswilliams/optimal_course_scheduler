class AddColumnSchoolToScheduleCourse < ActiveRecord::Migration
  def change
    add_reference :schedule_courses, :school
  end
end
