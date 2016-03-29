class AddCrnToSections < ActiveRecord::Migration
  def change
    add_column :sections, :crn, :string
  end
end
