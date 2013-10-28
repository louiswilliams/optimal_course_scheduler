class SectionController < ApplicationController
  def show
  	if params[:id]
      @section = Section.find params[:id]
      @course = Course.find @section.course_id
      @school = School.find @course.school_id
  	else
  	  @school = School.find_by name: params[:school_name]
  	  @course = Course.find_by name: params[:course_name], school_id: @school.id
      @section = Section.find_by name: params[:name], course_id: @course.id
    end
    @meetings = Meeting.where("section_id = ? AND course_id = ?",@section.id,@course.id)

    respond_to do |format|
      format.html
      section = @section.as_json
      section["meetings"] = @meetings.as_json
      format.json { render json: section}
    end
  end
end
