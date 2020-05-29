class Attendee < ActiveRecord::Base
    has_many :tickets
    has_many :concerts, through: :tickets

    def self.login
        prompt = TTY::Prompt.new
        attendee_email = prompt.ask("What is your email?")
        found_user = Attendee.find_by(email: attendee_email)
        if found_user
            puts "\n>> Login successful <<".colorize(:color => :black, :background => :green)
            return found_user
        else
            prompt.select("That email does not exist in our records. Would you like to create a new account?") do |menu|
                menu.choice "Create new account", -> { self.create_new_account }
                menu.choice "Re-enter email", -> { self.login }
            end
        end
    end

    def self.create_new_account
        prompt = TTY::Prompt.new
        attendee_email = prompt.ask("Please enter your email:")
        if Attendee.find_by(email: attendee_email)
            puts "\nThis email already exists.".colorize(:color => :black, :background => :red)
            self.create_new_account
        else
            attendee_name = prompt.ask("Please enter your name:")
            attendee_music_preference = prompt.ask("Please enter your music preference:")
            puts "\n>> Account created successfully <<".colorize(:color => :black, :background => :green)
            return Attendee.create(name: attendee_name, email: attendee_email, music_preference: attendee_music_preference)
        end
    end

    # def add_ticket_to_attendee(ticket)
    #     ticket.attendee_id = self.id
    # end

    def view_my_tickets
        tickets = self.tickets
        tickets_owned_table = TTY::Table.new header: ['Band', 'Venue', 'City', 'Date Time', 'Ticket Type', 'Price', 'Quantity Purchased']
        tickets.map do |ticket|
            tickets_owned_table << [ticket.concert.band, ticket.concert.venue, ticket.concert.city, ticket.concert.date_time, ticket.ticket_type, ticket.price, ticket.quantity_purchased]
        end
        puts tickets_owned_table.render(:unicode)
        return tickets
        sleep 1
    end

    def profile_table
        profile_table = TTY::Table.new header: ['Name', 'Email', 'Music Preference'], rows: [[name, email, music_preference]]
        puts profile_table.render(:unicode)
    end

    def change_name
        profile_table
        prompt = TTY::Prompt.new
        new_name = prompt.ask("Please enter your new name:")
        self.update(name: new_name)
        puts "\nYour profile has been updated.".colorize(:color => :black, :background => :green)
        profile_table
    end

    def change_email
        profile_table
        prompt = TTY::Prompt.new
        new_email = prompt.ask("Please enter your new email:")
        self.update(email: new_email)
        puts "Your profile has been updated."
        profile_table
    end

    def change_music_preference
        profile_table
        prompt = TTY::Prompt.new
        new_music_pref = prompt.ask("Please enter your new music preference:")
        self.update(music_preference: new_music_pref)
        puts "Your profile has been updated."
        profile_table
    end

end