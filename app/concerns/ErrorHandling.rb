module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from Date::Error, with: :handle_date_error
  end

  def handle_standard_error(e)
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: 'An unexpected error occurred', data: '', status: :internal_server_error }
  end

  def handle_date_error(_e)
    render json: { error: 'Invalid date format', data: '', status: :bad_request }
  end
end
