class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    @schedules = current_user.schedules
  end

  def list
    @date = params[:date]
    @schedules = current_user.schedules.where(date: @date)
  end

  def new
    @schedule = Schedule.new(date: params[:date])
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)

    if @schedule.save
      redirect_to root_path
    else
      render :new
    end
  end



  private
  def schedule_params
    params.require(:schedule).permit(
      :date,
      :title,
      :start_time,
      :end_time,
      :detail
    )
  end
end
