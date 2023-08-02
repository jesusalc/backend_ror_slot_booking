# app/services/slot_service.rb
class SlotService
  def self.all_booked_slots
    slots = Slot.all.order(:start)
    slots_by_datetime = slots.group_by { |slot| slot.start.in_time_zone('UTC') }
    slots_by_datetime.map do |datetime, slots_on_datetime|
      { date: datetime, count: slots_on_datetime.count }
    end
  end

  def self.booked_slots(date_param, duration_param)
    day = Date.parse(date_param)
    duration = duration_param.to_i
    start_time = day.in_time_zone('UTC').change(hour: 8, min: 0)
    end_time = day.in_time_zone('UTC').change(hour: 20, min: 0)

    slots = Slot.where(start: start_time..end_time)
                .order(:start)
                .pluck(:start, :end)

    slots.each_cons(2).with_object([]) do |((end_previous, _), (start_next, _)), booked_slots|
      gap = start_next - end_previous
      booked_slots << { start: end_previous, end: start_next } if gap >= (duration * 60)
    end
  end
end
