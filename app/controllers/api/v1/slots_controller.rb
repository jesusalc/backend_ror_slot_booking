module Api
  module V1
  end
 end
 class Api::V1::SlotsController < ApplicationController
  def all_booked_slots
    # Here you can fetch all booked slots; adjust the query as needed
    slots = Slot.all.order(:start)

    # Transform slots into a more useful structure
    slots_by_datetime = slots.group_by { |slot| slot.start.in_time_zone("UTC") }
    booked_slots = slots_by_datetime.map do |datetime, slots_on_datetime|
      { date: datetime, count: slots_on_datetime.count }
    end

    render json: { error: '', data: {slots: booked_slots}, status: :created }

  rescue Date::Error
    return render json: { error: 'Invalid all_booked_slots call format', data: '', status: :bad_request }
  end



  # Fetch booked slots based on date and duration
  def booked_slots
    # debugger
    # puts params.inspect # Log the parameters
    # puts request_params.inspect
    date_param = request_params[:date]
    duration_param = request_params[:duration]

    return render json: { error: 'date is required', data: '', status: :bad_request } unless date_param
    return render json: { error: 'duration is required', data: '', status: :bad_request } unless duration_param

    day = Date.parse(date_param)
    duration = duration_param.to_i

    # Assume slots are booked from 08:00 to 20:00
    start_time = day.in_time_zone("UTC").change(hour: 8, min: 0)
    end_time = day.in_time_zone("UTC").change(hour: 20, min: 0)

    slots = Slot.where(start: start_time..end_time)
               .order(:start)
               .pluck(:start, :end)

    booked_slots = []

    slots.each_cons(2) do |(end_previous, _), (start_next, _)|
      gap = start_next - end_previous
      if gap >= (duration * 60) # duration in seconds
        booked_slots << { start: end_previous, end: start_next }
      end
    end

    render json: { error: '', data: {slots: booked_slots}, status: :created }
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
