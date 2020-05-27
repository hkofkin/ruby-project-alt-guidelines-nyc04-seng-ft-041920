class Ticket < ActiveRecord::Base
    belongs_to :attendee
    belongs_to :concert

    def ticket_price
        self.price
    end

    def add_ticket_to_attendee(attendee)
        self.attendee_id = attendee.id
    end

end