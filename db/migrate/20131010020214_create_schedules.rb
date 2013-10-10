class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.references :user, index: true
      t.integer :year
      t.integer :semester

      t.timestamps
    end
  end
end
