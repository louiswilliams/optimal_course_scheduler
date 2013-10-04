class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.references :section, index: true
      t.references :course
      t.string :location
      t.time :start_time
      t.time :end_time
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday

      t.timestamps
    end
  end
end
