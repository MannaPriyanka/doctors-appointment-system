class AppointmentMailer < ApplicationMailer
  def reminder_email(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient

    mail(to: @appointment.patient.email, subject: 'Appointment Reminder')
  end
end
