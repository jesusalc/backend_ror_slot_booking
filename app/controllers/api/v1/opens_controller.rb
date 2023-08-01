module Api
  module V1
  end
 end
 class Api::V1::OpensController < ApplicationController
  def all_available_opens
    # Here you can fetch all available opens; adjust the query as needed
    opens = Open.all.order(:start)

    # Transform opens into a more useful structure
    opens_by_date = opens.group_by { |open| open.start.to_date }
    available_opens = opens_by_date.map do |date, opens_on_date|
      { date: date, count: opens_on_date.count }
    end

    render json: { error: '', data: {opens: available_opens}, status: :created }
  end

  # Fetch available opens based on date and duration
  def available_opens
    # debugger
    # puts params.inspect # Log the parameters
    # puts request_params.inspect
    date_param = request_params[:date]
    duration_param = request_params[:duration]

    return render json: { error: 'date is required', data: '', status: :bad_request } unless date_param
    return render json: { error: 'duration is required', data: '', status: :bad_request } unless duration_param

    day = Date.parse(date_param)
    duration = duration_param.to_i

    # Assume opens are available from 08:00 to 20:00
    start_time = day.in_time_zone("UTC").change(hour: 8, min: 0)
    end_time = day.in_time_zone("UTC").change(hour: 20, min: 0)

    opens = Open.where(start: start_time..end_time)
               .order(:start)
               .pluck(:start, :end)

    available_opens = []

    opens.each_cons(2) do |(end_previous, _), (start_next, _)|
      gap = start_next - end_previous
      if gap >= (duration * 60) # duration in seconds
        available_opens << { start: end_previous, end: start_next }
      end
    end

    render json: { error: '', data: {opens: available_opens}, status: :created }
  rescue Date::Error
    return render json: { error: 'Invalid date format', data: '', status: :bad_request }
  end

  # Create a new open
  def create
    open = Open.new(open_params)
    if open.save
      render json: { error: '', data: { message: "Open available successfully!" }, status: :created }
    else
      render json: { error: open.errors, data: '', status: :unprocessable_entity }
    end
  end

  private

  def open_params
    params.require(:open).permit(:start, :end)
  end

  def request_params
    params.require(:open).permit(:date, :duration)
  end


end
