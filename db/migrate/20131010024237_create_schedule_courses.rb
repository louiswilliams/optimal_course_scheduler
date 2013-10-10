class CreateScheduleCourses < ActiveRecord::Migration
  def change
    create_table :schedule_courses do |t|
      t.references :schedule, index: true
      t.references :course, index: true
      t.references :section, index: true
      t.boolean :scheduled

      t.timestamps
    end
  end
end
