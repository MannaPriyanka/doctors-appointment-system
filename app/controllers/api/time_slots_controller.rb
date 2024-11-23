module Api
  class TimeSlotsController < ApplicationController
    before_action :authenticate_user!

    # List all available time slots
    def index
      time_slots = TimeSlot.includes(:doctor).all
      render json: time_slots.as_json(include: { doctor: { only: [:id, :first_name, :last_name] } }), status: :ok
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
