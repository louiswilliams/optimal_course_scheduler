class AddCourseIdToMeetings < ActiveRecord::Migration
  def change
    add_reference :meetings, :course, index: true
  end
end
