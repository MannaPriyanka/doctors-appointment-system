module Api
  class TimeSlotsController < ApplicationController
    before_action :authenticate_user!

    # List all available time slots
    def index
      time_slots = TimeSlot.includes(:doctor)
                          .all
                          .group_by(&:doctor)

      response = time_slots.map do |doctor, slots|
        next_available_slot = slots.select { |slot| slot.start_time > Time.current }.min_by(&:start_time)

        {
          doctor: {
            id: doctor.id,
            first_name: doctor.first_name,
            last_name: doctor.last_name,
            next_available_slot: next_available_slot ? next_available_slot.start_time : nil
          },
          time_slots: slots.as_json(only: [:start_time, :end_time])
        }
      end

      render json: response, status: :ok
    end

    # Add availability for a doctor
    def create
      return render json: { error: 'Only doctors can add availability' }, status: :forbidden unless current_user.has_role?(:doctor)

      time_slot = current_user.time_slots.new(time_slot_params)

      if time_slot.save
        render json: time_slot, status: :created
      else
        render json: { errors: time_slot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def time_slot_params
      params.require(:time_slot).permit(:start_time, :end_time)
    end
  end
end
