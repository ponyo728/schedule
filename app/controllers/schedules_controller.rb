class SchedulesController < ApplicationController
  def index
  end

  def new
    @schedule = Schedule.new(date: params[:date])
  end
end
