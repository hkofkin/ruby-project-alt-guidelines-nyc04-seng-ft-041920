class AddColumnToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :quantity_purchased, :integer
    # add_column :tickets, :max_quantity, :integer
  end
end
