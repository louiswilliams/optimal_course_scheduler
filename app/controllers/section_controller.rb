class SectionController < ApplicationController
  def show
    @section = Section.find params[:id]
    @course = Course.find @section.course_id
    @meetings = Meeting.where("section_id = ? AND course_id = ?",@section.id,@course.id)
  end
end
