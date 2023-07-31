module Api
  module V1
  end
 end
 class Api::V1::SlotsController < ApplicationController
  def all_available_slots
    # Here you can fetch all available slots; adjust the query as needed
    slots = Slot.all.order(:start)

    # Transform slots into a more useful structure
    slots_by_date = slots.group_by { |slot| slot.start.to_date }
    available_slots = slots_by_date.map do |date, slots_on_date|
      { date: date, count: slots_on_date.count }
    end

    render json: { error: '', data: {slots: available_slots}, status: :created }
  end

  # Fetch available slots based on date and duration
  def available_slots
    # debugger
    # puts params.inspect # Log the parameters
    # puts request_params.inspect
    date_param = request_params[:date]
    duration_param = request_params[:duration]

    return render json: { error: 'date is required', data: '', status: :bad_request } unless date_param
    return render json: { error: 'duration is required', data: '', status: :bad_request } unless duration_param

    day = Date.parse(date_param)
    duration = duration_param.to_i

    # Assume slots are available from 08:00 to 20:00
    start_time = day.in_time_zone("UTC").change(hour: 8, min: 0)
    end_time = day.in_time_zone("UTC").change(hour: 20, min: 0)

    slots = Slot.where(start: start_time..end_time)
               .order(:start)
               .pluck(:start, :end)

    available_slots = []

    slots.each_cons(2) do |(end_previous, _), (start_next, _)|
      gap = start_next - end_previous
      if gap >= (duration * 60) # duration in seconds
        available_slots << { start: end_previous, end: start_next }
      end
    end

    render json: { error: '', data: {slots: available_slots}, status: :created }
  rescue Date::Error
    return render json: { error: 'Invalid date format', data: '', status: :bad_request }
  end

  # Create a new slot
  def create
    slot = Slot.new(slot_params)
    if slot.save
      render json: { error: '', data: { message: "Slot booked successfully!" }, status: :created }
    else
      render json: { error: slot.errors, data: '', status: :unprocessable_entity }
    end
  end

  private

  def slot_params
    params.require(:slot).permit(:start, :end)
  end

  def request_params
    params.require(:slot).permit(:date, :duration)
  end


end
