class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.references :doctor, foreign_key: { to_table: :users } # Reference the users table
      t.references :patient, foreign_key: { to_table: :users } # Reference the users table
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
