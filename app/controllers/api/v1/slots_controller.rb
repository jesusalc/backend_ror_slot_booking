# frozen_string_literal: true

# Controller base to /api/v1 endpoints for /api/v1/slots
module Api
  module V1
    # Controller base to CRUD booked slots
    class SlotsController < ApplicationController
      include ErrorHandling
      rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

      def all_booked_slots
        booked_slots = SlotService.all_booked_slots
        render json: { error: '', data: { slots: booked_slots }, status: :created }
      rescue Date::Error
        render json: { error: 'Invalid all_booked_slots call format', data: '', status: :bad_request }
      rescue StandardError => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
        render json: { error: 'An unexpected error occurred', data: '', status: :internal_server_error }
      end

      def booked_slots
        validation = BookedSlotsValidator.new(request_params).validate

        return render json: { error: validation[:error], data: '', status: :bad_request } unless validation[:success]

        date_param = request_params[:date]
        duration_param = request_params[:duration].to_i

        day = Date.parse(date_param)

        # Assume slots are booked from 08:00 to 20:00
        start_time = day.in_time_zone('UTC').change(hour: 8, min: 0)
        end_time = day.in_time_zone('UTC').change(hour: 20, min: 0)

        slots = Slot.where(start: start_time..end_time)
                    .order(:start)
                    .pluck(:start, :end)

        booked_slots = []

        slots.each_cons(2) do |(end_previous, _), (start_next, _)|
          gap = start_next - end_previous
          booked_slots << { start: end_previous, end: start_next } if gap >= (duration_param * 60) # duration in seconds
        end

        render json: { error: '', data: { slots: booked_slots }, status: :created }
      end

      def create
        validation = CreateSlotValidator.new(slot_params).validate

        return render json: { error: validation[:error], data: '', status: :bad_request } unless validation[:success]

        result = SlotCreator.create(slot_params)
        if result[:success]
          return render json: { error: '', data: { message: result[:message] },
                                status: :created }
        end

        render json: { error: result[:errors], data: '', status: :unprocessable_entity }
      end

      private

      def slot_params
        params.require(:slot).permit(:start, :end)
      end

      def request_params
        params.require(:slot).permit(:date, :duration)
      end

      def end_after_start
        errors.add(:end, 'must be after the start time') if start >= self.end
      end

      def handle_record_invalid(exception)
        render json: { error: exception.message, data: '', status: :unprocessable_entity }
      end
    end
  end
end
