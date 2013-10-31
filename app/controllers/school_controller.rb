class SchoolController < ApplicationController
  def index
  	@schools = School.all
    respond_to do |format|
      format.html
      format.json {render json: @schools}
    end
  end

  def show
  	@school = School.find_by name: params[:name]
  	@courses = @school.courses
  	respond_to do |format|
  		format.html
  		format.json { render json: @courses }
  	end
  end

end
