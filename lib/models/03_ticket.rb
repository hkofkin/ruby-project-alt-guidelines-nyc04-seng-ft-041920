class Ticket < ActiveRecord::Base
    belongs_to :attendee
    belongs_to :concert

    attr_accessor :quantity_purchased

    def ticket_price
        self.price
    end

    def find_concert_id
        self.concert_id
    end

    def ticket_quantity
        self.max_quantity - self.quantity_purchased
    end

    # def select_ticket_type
    #     prompt = TTY::Prompt.new
    #     ticket_types = self.all.map do |ticket|
    #         {ticket.ticket_type => ticket}
    #     end
    #     ticket_type = prompt.select("What ticket type are you looking for?", ticket_types)
    # end

    def self.select_ticket_quantity
        prompt = TTY::Prompt.new
        quantity = prompt.ask("How many would you like to buy?")
        quantity = quantity.to_i
        if quantity <= 0
            puts "Please enter valid quantity.".colorize(:color => :black, :background => :red)
            self.select_ticket_quantity
        end
        quantity
    end

end