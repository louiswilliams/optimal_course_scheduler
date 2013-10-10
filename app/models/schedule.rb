class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :schedule_course
end
