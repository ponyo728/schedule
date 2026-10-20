class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: [:show, :edit, :update]
  before_action :own_schedule, only: [:show, :edit, :update]

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

  def show
  end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to schedule_path(@schedule)
    else
      render :edit
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def own_schedule
    if current_user != @schedule.user
      redirect_to root_path
    end
  end

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
