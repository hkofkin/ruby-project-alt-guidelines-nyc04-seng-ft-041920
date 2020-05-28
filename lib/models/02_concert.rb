class Concert < ActiveRecord::Base
    has_many :tickets
    has_many :attendees, through: :tickets

    def tickets_available
        Ticket.where(concert_id: self.id)
        # Ticket.all.left_joins("INNER JOIN concerts ON tickets.concert_id = concerts.id")
        # need to join tables to show (ticket) ticket type, price, (concert) band, venue, and city
    end
end