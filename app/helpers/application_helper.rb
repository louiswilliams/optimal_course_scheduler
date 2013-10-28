module ApplicationHelper
  def add_course_path
    path = root_path
    if user_signed_in?
      @schedule = Schedule.find_by user_id: current_user.id
      path = schedule_schedule_course_index_path(@schedule.id)
    end
    return path
  end
end
