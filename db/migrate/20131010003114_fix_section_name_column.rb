class FixSectionNameColumn < ActiveRecord::Migration
  def change
    rename_column :sections, :section_id, :section_name
  end
end
