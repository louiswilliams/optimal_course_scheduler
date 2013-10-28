class AddSchoolToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :school, index: true
  end
end
