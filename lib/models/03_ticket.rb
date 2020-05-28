class Ticket < ActiveRecord::Base
    belongs_to :attendee
    belongs_to :concert

    def ticket_price
        self.price
    end

    def find_concert_id
        self.concert_id
    end

end