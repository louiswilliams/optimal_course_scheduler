class TimeConstraintController < ApplicationController
  before_action :set_constraint, only: [:show, :edit, :update, :destroy]
  def show
  end

  def new
    @constraint = TimeConstraint.new
  end

  def create
    @constraint = TimeConstraint.new(time_constraint_params)
    @constraint.schedule = Schedule.find(params[:schedule_id])
    @constraint.save
    redirect_to schedule_path(params[:schedule_id])
  end

  def edit
  end

  def update
    @constraint.update(time_constraint_params)
    redirect_to schedule_path(params[:schedule_id])
  end

  def destroy
    @constraint.destroy
    redirect_to schedule_path(params[:schedule_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constraint
      @constraint = TimeConstraint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_constraint_params
      params.require(:time_constraint).permit( :name, :monday, :tuesday, :wednesday,
        :thursday, :friday, :start_time, :end_time)
    end
end
