class FixCoursesCOlumn < ActiveRecord::Migration
  def change
    rename_column :courses, :course_id, :course_name
  end
end
