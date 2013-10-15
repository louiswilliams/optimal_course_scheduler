class UpdateTimeConstraint < ActiveRecord::Migration
  def change
    add_column :time_constraints, :name, :string, :default => "Sleep"
    change_column_default :time_constraints, :start_time, "08:00:00"
    change_column_default :time_constraints, :end_time, "09:00:00"
  end
end
