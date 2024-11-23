class TimeSlot < ApplicationRecord
	belongs_to :doctor, class_name: "User", foreign_key: :doctor_id
end
