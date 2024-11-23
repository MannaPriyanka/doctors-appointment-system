# Doctors Appointment System API

This is a RESTful API for a Doctors Appointment System that allows doctors to manage their availability and patients to book appointments. The system includes features for managing time slots, booking appointments, sending reminders, and handling doctor-patient interactions.

## Features

- **Doctor Availability Management**: Doctors can add, update, and delete their availability time slots.
- **Patient Appointment Booking**: Patients can book appointments with doctors based on available time slots.
- **Email Reminders**: Patients receive a reminder email 30 minutes before their appointment.
- **Doctor Time Slot Search**: Patients can search for doctor availability by name.
- **Next Available Slot**: Each doctor’s profile shows the next available time slot.
- **Appointment Validation**: Ensure appointments are booked within available time slots.
- **Prevent Overlapping Time Slots**: Doctors cannot add overlapping availability time slots.

## API Endpoints

### `GET /api/time_slots`

**Description**: List all available time slots.

- **Query Parameters**:
  - `doctor_name`: Optional search parameter to filter time slots by doctor’s name.

---

### `POST /api/time_slots`

**Description**: Add availability for the logged-in doctor.

---

### `GET /api/appointments`

**Description**: List all appointments for the logged-in user (doctor or patient).

---

### `POST /api/appointments`

**Description**: Book an appointment with a doctor.

---

### `DELETE /api/time_slots/:id`

**Description**: Delete a time slot for a doctor.

---

## Features Covered

1. **Doctor Availability**: Doctors can add, update, and delete their time slots. Duplicate or overlapping time slots are prevented.
2. **Appointment Booking**: Patients can book an appointment with available doctors, with validation to ensure the appointment falls within available time.
3. **Next Available Slot**: Each doctor’s profile includes the next available time slot.
4. **Search Functionality**: Time slots can be filtered based on the doctor's name.
5. **Appointment Reminder**: Patients receive an email 30 minutes before the appointment starts.
6. **Error Handling**: Proper error messages for invalid operations, such as booking outside of availability or overlapping time slots.

## Email Reminder

- **Job**: An `AppointmentReminderJob` sends an email reminder 30 minutes before the appointment.
- **Mailer**: `PatientMailer.appointment_reminder` is used to send the reminder email with details about the appointment.

## Setup and Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/MannaPriyanka/doctors-appointment-system.git
   cd doctor-appointment-system
   bundle install
   rails db:create
   rails db:migrate
   rails server
   ```
