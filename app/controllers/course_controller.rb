class CourseController < ApplicationController
  def index
    @add_course_path = "/"
    if user_signed_in?
      @add_course_path = schedule_schedule_course_index_path(Schedule.where("user_id = ?",current_user.id).first.id)
    end
    @courses = Course.all
    respond_to do |format|
      format.html
      format.json { render json: @courses}
    end
  end
  def show
    @course = Course.find(params[:id])
    @sections = Section.where("course_id = ?",@course.id)
    @course.sections = @sections
    respond_to do |format|
      format.html
      format.json { render json: @course}
    end
  end
  def create
    query = ""
    if params[:college]
      query = "college = #{params[:college]}"
    end
    @courses = Course.where(query)
  end
end
