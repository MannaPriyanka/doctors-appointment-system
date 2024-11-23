class AppointmentMailer < ApplicationMailer
  def reminder_email(appointment)
    @appointment = appointment
    mail(to: @appointment.patient.email, subject: 'Appointment Reminder')
  end
end
