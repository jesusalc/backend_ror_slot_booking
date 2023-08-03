# frozen_string_literal: true

# Controller base to /api/v1 endpoints for /api/v1/opens
module Api
  module V1
    # Controller base to CRUD open slots
    class OpensController < ApplicationController
      include ErrorHandling
      rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

      def all_available_opens
        opens = OpenService.all_available_opens
        render json: { error: '', data: { slots: opens }, status: :created }
      end

      # Fetch available opens based on date and duration
      def available_opens
        # debugger
        # puts params.inspect # Log the parameters
        # puts request_params.inspect
        date_param = request_params[:date]
        duration_param = request_params[:duration]

        unless date_param
          return render json: { error: 'date is required', data: '', status: :bad_request }
        end
        unless duration_param
          return render json: { error: 'duration is required', data: '', status: :bad_request }
        end

        day = Date.parse(date_param)
        duration = duration_param.to_i

        # Assume opens are available from 08:00 to 20:00
        start_time = day.in_time_zone('UTC').change(hour: 8, min: 0)
        end_time = day.in_time_zone('UTC').change(hour: 20, min: 0)

        opens = Open.where(start: start_time..end_time).order(:start).pluck(:start, :end)

        available_opens = []

        opens.each_cons(2) do |(end_previous, _), (start_next, _)|
          gap = start_next - end_previous
          # duration in seconds
          available_opens << { start: end_previous, end: start_next } if gap >= (duration * 60)
        end

        render json: { error: '', data: { opens: available_opens }, status: :created }
      rescue Date::Error
        render json: { error: 'Invalid date format', data: '', status: :bad_request }
      end

      # Create a new open
      def create
        validation = CreateSlotValidator.new(slot_params).validate

        unless validation[:success]
          return render json: { error: validation[:error], data: '', status: :bad_request }
        end

        result = SlotCreator.create(slot_params)
        if result[:success]
          render json: { error: '', data: { message: result[:message] }, status: :created }
        else
          render json: { error: result[:errors], data: '', status: :unprocessable_entity }
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
  end
end
