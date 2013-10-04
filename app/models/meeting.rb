class Meeting < ActiveRecord::Base
  belongs_to :section

  def days_to_str(words = false)
    days = ""
    if words
      days << ((self.monday) ? "Monday " : "")
      days << ((self.tuesday) ? "Tuesday " : "" )
      days << ((self.wednesday) ? "Wednesday " : "" )
      days << ((self.thursday) ? "Thursday " : "" )
      days << ((self.friday) ? "Friday " : "" )

    else
      days << ((self.monday) ? "M" : "")
      days << ((self.tuesday) ? "T" : "")
      days << ((self.wednesday) ? "W" : "")
      days << ((self.thursday) ? "R" : "")
      days << ((self.friday) ? "F" : "")
    end
    return days
  end
end
