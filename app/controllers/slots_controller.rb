class SlotsController < ApplicationController

  # Fetch available slots based on date and duration
  def available_slots
    day = Date.parse(params[:day])
    duration = params[:duration].to_i

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

    render json: available_slots
  end

  # Create a new slot
  def create
    slot = Slot.new(slot_params)
    if slot.save
      render json: { message: "Slot booked successfully!" }, status: :created
    else
      render json: slot.errors, status: :unprocessable_entity
    end
  end

  private

  def slot_params
    params.require(:slot).permit(:start, :end)
  end

end
