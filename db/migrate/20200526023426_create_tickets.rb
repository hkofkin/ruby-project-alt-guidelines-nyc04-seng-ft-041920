class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :attendee_id
      t.integer :concert_id
      t.string :ticket_type
      t.integer :price
    end
  end
end
