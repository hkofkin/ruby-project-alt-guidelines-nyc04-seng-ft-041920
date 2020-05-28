class Ticket < ActiveRecord::Base
    belongs_to :attendee
    belongs_to :concert

    max_quantity = 100
    quantity_purchased = 0

    def ticket_price
        self.price
    end

    def find_concert_id
        self.concert_id
    end

    def ticket_quantity
        self.max_quantity - self.quantity_purchased
    end

end