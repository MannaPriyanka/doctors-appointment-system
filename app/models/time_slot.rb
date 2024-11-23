class TimeSlot < ApplicationRecord
	# Associations
	belongs_to :doctor, class_name: "User", foreign_key: :doctor_id
	
	# Validations
  validates :start_time, :end_time, presence: true
  validate :no_overlap

  private

  # Ensure no overlapping time slots for a doctor
  def no_overlap
    overlaps = TimeSlot.where(doctor_id: doctor_id)
                       .where.not(id: id)
                       .where('start_time < ? AND end_time > ?', end_time, start_time)
    errors.add(:base, 'Time slot overlaps with an existing time slot') if overlaps.exists?
  end
end
