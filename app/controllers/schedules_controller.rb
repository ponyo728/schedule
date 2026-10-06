class SchedulesController < ApplicationController
  def index
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
