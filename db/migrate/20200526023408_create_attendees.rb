class CreateAttendees < ActiveRecord::Migration[5.2]
  def change
    create_table :attendees do |t|
      t.string :name
      t.string :email
      t.string :music_preference
    end
  end
end
