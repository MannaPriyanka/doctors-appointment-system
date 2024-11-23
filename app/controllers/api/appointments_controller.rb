module Api
  class AppointmentsController < ApplicationController
    before_action :authenticate_user! # Ensure the user is authenticated
    before_action :find_doctor, only: [:create]

    # List all appointments for the current user (doctor or patient)
    def index
      if current_user.has_role?(:doctor)
        appointments = current_user.doctor_appointments
      elsif current_user.has_role?(:patient)
        appointments = current_user.patient_appointments
      else
        return render json: { error: 'Unauthorized' }, status: :unauthorized
      end
      render json: appointments, status: :ok
    end

    # Create a new appointment
    def create
      appointment = current_user.patient_appointments.new(appointment_params)
      appointment.doctor = @doctor

      if appointment.save
        # Schedule the appointment reminder job 30 minutes before the appointment
        AppointmentReminderJob.set(wait_until: appointment.start_time - 30.minutes).perform_later(appointment.id)
    
        render json: appointment, status: :created
      else
        render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def appointment_params
      params.require(:appointment).permit(:start_time, :end_time)
    end

    def find_doctor
      @doctor = User.find_by(id: params[:doctor_id], role: 'doctor')
      render json: { error: 'Doctor not found' }, status: :not_found unless @doctor
    end
  end
end
