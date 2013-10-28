class CourseController < ApplicationController
  include ApplicationHelper
  before_filter :add_course_path

  def index
    @colleges = Course.colleges
  end

  def show
    if params[:id]
      @course = Course.find(params[:id])
      @school = School.find(@course.school_id)
    else
      @school = School.find_by name: params[:school_name]
      @course = Course.find_by name: params[:name], school_id: @school.id
    end
    @sections = Section.where("course_id = ?",@course.id)
    @course.sections = @sections

    respond_to do |format|
      format.html
      course = @course.as_json
      course["sections"] = @sections.as_json
      format.json { render json: course}
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
