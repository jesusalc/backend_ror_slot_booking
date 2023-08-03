# frozen_string_literal: true

# Validation for creating new booked slots
class CreateSlotValidator
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def sanitize_input
    # Sanitize the date fields
    @params[:start] = sanitize_datetime(@params[:start])
    @params[:end] = sanitize_datetime(@params[:end])
  end

  def validate_start_time_must_be_datetime
    return if params[:start].present? && valid_datetime?(params[:start])

    { success: false, error: 'Start time is required and must be a valid datetime' }
  end

  def validate_end_time_must_be_datetime
    return if params[:end].present? && valid_datetime?(params[:end])

    { success: false, error: 'End time is required and must be a valid datetime' }
  end

  def validate_date_format
    # Check that dates are in the correct format
    %i[start end].each do |field|
      @errors << "Invalid #{field} format" unless valid_datetime?(@params[field])
    end
  end

  def validate
    sanitize_input
    validate_presence_of_required_fields
    validate_start_time_must_be_datetime
    validate_end_time_must_be_datetime
    validate_date_format

    # Validate that end time is after start time
    if DateTime.parse(params[:start]) >= DateTime.parse(params[:end])
      return { success: false, error: 'End time must be after start time' }
    end

    # Return success if all validations pass
    { success: true }
  end

  private

  def valid_datetime?(datetime_str)
    DateTime.parse(datetime_str)
    true
  rescue ArgumentError
    false
  end

  def sanitize_datetime(datetime_str)
    # Remove anything that isn't a letter, number, colon, comma, dot, or dash
    datetime_str.gsub(/[^a-zA-Z0-9:\-,. ]/, '')
  end
end
