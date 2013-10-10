class UnFixWhatIJustFixed < ActiveRecord::Migration
  def change
    rename_column :sections, :course_name, :course_id
    rename_column :meetings, :course_name, :course_id
    rename_column :meetings, :section_name, :section_id
  end
end
