class ScheduleCourseController < ApplicationController
  def show
    @schedule_course = ScheduleCourse.find(params[:id])
  end

  def new
    @schedule_course = ScheduleCourse.new
    @courses = Course.all
  end

  def create
    @schedule_course = ScheduleCourse.new
    @schedule_course.schedule = Schedule.find(params[:schedule_id])
    @schedule_course.course = Course.find(params[ :id])

    @schedule_course.save
    redirect_to schedule_path(params[:schedule_id])
  end

  def edit
  end

  def update
  end

  def destroy
    ScheduleCourse.find(params[:id]).destroy
    redirect_to schedule_path(params[:schedule_id])
  end
end
