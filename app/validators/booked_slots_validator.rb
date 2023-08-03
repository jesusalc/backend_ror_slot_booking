# frozen_string_literal: true

# app/validators/booked_slots_validator.rb
class BookedSlotsValidator
  attr_reader :date, :duration

  def initialize(params)
    @date = params[:date]
    @duration = params[:duration]
  end

  def validate
    return { success: false, error: 'date is required' } unless date
    return { success: false, error: 'duration is required' } unless duration

    begin
      Date.parse(date)
      Integer(duration)
    rescue StandardError
      return { success: false, error: 'Invalid date or duration format' }
    end

    { success: true }
  end
end
