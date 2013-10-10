class CourseController < ApplicationController
  def index
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
end
