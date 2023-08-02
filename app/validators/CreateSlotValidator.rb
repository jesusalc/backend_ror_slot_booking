class CreateSlotValidator
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def validate
    # Sanitize start and end time
    params[:start] = sanitize_datetime(params[:start])
    params[:end] = sanitize_datetime(params[:end])

    # Validate start time
    unless params[:start].present? && valid_datetime?(params[:start])
      return { success: false, error: 'Start time is required and must be a valid datetime' }
    end

    # Validate end time
    unless params[:end].present? && valid_datetime?(params[:end])
      return { success: false, error: 'End time is required and must be a valid datetime' }
    end

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
