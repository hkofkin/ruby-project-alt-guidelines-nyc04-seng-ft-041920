class Attendee < ActiveRecord::Base
    has_many :tickets
    has_many :concerts, through: :tickets

    def add_ticket_to_attendee(ticket)
        ticket.attendee_id = self.id
    end

end