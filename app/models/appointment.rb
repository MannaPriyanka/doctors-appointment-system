class Appointment < ApplicationRecord
  # Associations
  belongs_to :doctor, class_name: 'User'
  belongs_to :patient, class_name: 'User'

  # Validations
  validates :start_time, :end_time, presence: true
  validate :appointment_within_availability

  private

  # Custom validation to ensure the appointment falls within the doctor's availability
  def appointment_within_availability
    availability = doctor.time_slots.where('start_time <= ? AND end_time >= ?', start_time, end_time)
    errors.add(:base, 'Appointment is outside the doctor’s availability') if availability.empty?
  end
end
