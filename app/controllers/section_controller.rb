class SectionController < ApplicationController
  def show
  	if params[:id]
      @section = Section.find params[:id]
      @course = @section.course
      @school = @section.school
  	else
  	  @school = School.find_by name: params[:school_name]
  	  @course = Course.find_by name: params[:course_name], school_id: @school.id
      @section = Section.find_by name: params[:name], course_id: @course.id
    end
    @meetings = @section.meetings

    respond_to do |format|
      format.html
      section = @section.as_json
      section["meetings"] = @meetings.as_json
      format.json { render json: section}
    end
  end
end
