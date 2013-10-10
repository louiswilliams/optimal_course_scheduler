class LastFixToColumnNames < ActiveRecord::Migration
  def change
    rename_column :courses, :course_name, :name
    rename_column :sections, :section_name, :name
  end
end
