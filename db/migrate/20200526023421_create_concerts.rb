class CreateConcerts < ActiveRecord::Migration[5.2]
  def change
    create_table :concerts do |t|
      t.string :band
      t.string :venue
      t.string :city
      t.datetime :date_time
    end
  end
end
