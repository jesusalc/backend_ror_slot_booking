# frozen_string_literal: true

# Module helper to be included as Error handler
module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from Date::Error, with: :handle_date_error
  end

  def handle_standard_error(error)
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")
    render json: { error: 'An unexpected error occurred', data: '', status: :internal_server_error }
  end

  def handle_date_error(error)
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")
    render json: { error: 'Invalid date format', data: '', status: :bad_request }
  end
end
