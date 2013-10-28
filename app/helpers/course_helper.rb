module CourseHelper

  def is_in_schedule? check_course
    if user_signed_in?
      @schedule = Schedule.find_by user_id: current_user.id
      @schedule_courses = ScheduleCourse.where("schedule_id = ?",@schedule.id)
      # return (@schedule_courses.count > 0) ? true : false
      @schedule_courses.each do |schedule_course|
        if schedule_course.course_id == check_course.id
          return true
        end
      end
    end
    return false
  end
end
