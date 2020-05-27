class Attendee < ActiveRecord::Base
    has_many :tickets
    has_many :concerts, through: :tickets

    def tickets_owned
        my_tickets = Ticket.all.find_by(attendee_id: self.id)
    end
end