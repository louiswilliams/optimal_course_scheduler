class CreateTimeConstraints < ActiveRecord::Migration
  def change
    create_table :time_constraints do |t|
      t.references :schedule, index: true
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
