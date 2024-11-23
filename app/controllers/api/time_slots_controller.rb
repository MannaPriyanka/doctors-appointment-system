module Api
  class TimeSlotsController < ApplicationController
    before_action :authenticate_user!

    # List all available time slots
    def index
      # Check if the search query is provided
      if params[:doctor_name].present?
        time_slots = TimeSlot.joins(:doctor)
                             .where('doctors.first_name LIKE ? OR doctors.last_name LIKE ?', "%#{params[:doctor_name]}%", "%#{params[:doctor_name]}%")
      else
        # If no search query, get all time slots
        time_slots = TimeSlot.includes(:doctor).all
      end
    
      # Group the time slots by doctor
      time_slots = time_slots.group_by(&:doctor)
    
      # Prepare the response with doctor's details and their available time slots
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

    # Update availability for a doctor
    def update
      time_slot = TimeSlot.find_by(id: params[:id], doctor_id: current_user.id)
      return render json: { error: 'Time slot not found or unauthorized' }, status: :not_found unless time_slot

      if time_slot.update(time_slot_params)
        render json: time_slot, status: :ok
      else
        render json: { errors: time_slot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Delete a time slot
    def destroy
      time_slot = TimeSlot.find_by(id: params[:id], doctor_id: current_user.id)
      return render json: { error: 'Time slot not found or unauthorized' }, status: :not_found unless time_slot

      time_slot.destroy
      head :no_content
    end

    private

    def time_slot_params
      params.require(:time_slot).permit(:start_time, :end_time)
    end
  end
end
