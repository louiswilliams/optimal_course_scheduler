class Course < ActiveRecord::Base
  has_many :sections
  belongs_to :school
end
