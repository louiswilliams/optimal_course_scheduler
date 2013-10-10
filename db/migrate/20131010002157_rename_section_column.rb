class RenameSectionColumn < ActiveRecord::Migration
  def change
    rename_column :sections, :course_id, :course_name
    rename_column :meetings, :course_id, :course_name
    rename_column :meetings, :section_id, :section_name
  end
end
