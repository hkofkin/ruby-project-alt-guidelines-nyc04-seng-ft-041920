class Concert < ActiveRecord::Base
    has_many :tickets
    has_many :attendees, through: :tickets

    def tickets_available
        tickets = Ticket.where(concert_id: self.id)
        if !tickets
            return false
        else
            tickets = Ticket.where(concert_id: self.id)
            ticket_table = TTY::Table.new header: ['Artist', 'Venue', 'City', 'Date Time', 'Ticket Type', 'Price']
            tickets.map do |ticket|
                ticket_table << [self.band, self.venue, self.city, self.date_time, ticket.ticket_type, ticket.price]
            end
            puts ticket_table.render(:unicode)
            return tickets
            sleep 1
        end

    end

    def self.all_concerts
        system "clear"
        puts "\nHere is a list of all upcoming concerts:"
        all_concerts = self.all
        concert_table = TTY::Table.new header: ['Artist', 'Venue', 'City', 'Date Time']
        all_concerts.map do |concert|
            concert_table << [concert.band, concert.venue, concert.city, concert.date_time]
        end
        puts concert_table.render(:unicode)
    end

    def self.list_concerts_by_band
        prompt = TTY::Prompt.new
        all_concerts = self.all.map do |concert|
            {concert.band => concert}
        end
        selected_concert = prompt.select("\nWhat artist are you looking to see?", all_concerts)
    end

    def self.list_concerts_by_city
        prompt = TTY::Prompt.new
        all_concerts = self.all.map do |concert|
            {concert.city => concert}
        end
        selected_concert = prompt.select("\nWhat city?", all_concerts)
    end

end