class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :schedule_courses
  has_many :time_constraints
end
