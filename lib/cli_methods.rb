class CommandLineInterface
    attr_accessor :prompt, :attendee

    def initialize
        @prompt = TTY::Prompt.new
    end

    def run 
        greet
        login_prompt
    end

    def greet
        puts "~ Welcome to Ticket Time ~\nWho's ready to jam?"
    end

    def login_prompt
        prompt.select("Do you have an account?") do |menu|
            menu.choice "Yes", -> { login }
            menu.choice "No", -> { create_account }
        end
    end

    def login
        @attendee = Attendee.login
        home_page
    end

    def create_account
        @attendee = Attendee.create_new_account
        home_page
    end

    def home_page
        # add feature to recommend concerts based on location and music preference
        prompt.select("Welcome! What would you like to do?") do |menu|
            menu.choice "Buy tickets", -> { buy_tickets }
            menu.choice "View my tickets", -> { view_my_tickets }
            menu.choice "Edit profile", -> { edit_profile }
            menu.choice "Logout", -> { logout }
        end
    end

    def buy_tickets
        Concert.all_concerts
        prompt.select("Would you like to:") do |menu|
            menu.choice "Search by band", -> { self.find_concert_by_band }
            menu.choice "Search by city", -> { self.find_concert_by_city }
            menu.choice "Go back to main menu", -> { self.home_page }
        end
    end

    def find_concert_by_band
        found_concert = Concert.list_concerts_by_band
        view_available_concert_tickets(found_concert)
    end

    def find_concert_by_city
        found_concert = Concert.list_concerts_by_city
        view_available_concert_tickets(found_concert)
    end

    def view_available_concert_tickets(concert_instance)
        tickets = concert_instance.tickets_available
        
        if tickets.count > 1
            ticket_instances = tickets.map do |ticket|
                {ticket.ticket_type => ticket}
            end
            ticket = prompt.select("What ticket type are you looking for?", ticket_instances)
            ticket_type_check_quantity(ticket)
        elsif
            ticket_type_check_quantity(tickets)
        elsif tickets.count < 1
            puts "Sorry, no tickets are currently available."
            buy_tickets
        end
    end

    def ticket_type_check_quantity(instance)
        puts "Great! We are happy to reserve tickets for you."
        quantity = Ticket.select_ticket_quantity
        total_price = quantity * instance.price
        prompt.select("Your total price for #{quantity} tickets is $#{total_price}. Confirm purchase?") do |menu|
            menu.choice "Yes", -> { confirm_purchase(instance, quantity) }
            menu.choice "No", -> { home_page }
        end
    end

    def confirm_purchase(ticket_instance, quantity)
        ticket_instance.quantity_purchased = quantity
        puts "Thank you for your purchase! Select 'View my tickets' at main menu to view your tickets."
        @attendee.tickets << ticket_instance 
        home_page
    end

    def view_my_tickets
        tickets_owned = @attendee.tickets
        if tickets_owned.empty?
            puts "You have not purchased any tickets."
            home_page
        else
            @attendee.view_my_tickets
            puts "What would you like to do?"
            puts "1 = cancel purchase"
            puts "2 = go back to main menu"
            page = gets.chomp
            view_tickets_menu_action(page)
        end
    end

    def view_tickets_menu_action(input)
        if input == "1"
            if @attendee.tickets.count > 1
                puts "Which ticket purchase would you like to cancel?"
                # need to add a way to select which concert to remove
            else
                puts "Are you sure you want to cancel your ticket purchase?"
                puts "y = yes"
                puts "n = no"
                answer = gets.chomp
                cancel_tickets?(answer)
            end
        elsif input == "2"
            home_page
        else
            puts "Invalid input. Please enter either '1' or '2'."
            page = gets.chomp
            view_tickets_menu_action(page)
        end
    end

    def cancel_tickets?(input)
        if input == "y"
            @attendee.tickets.clear
            view_my_tickets
        elsif input == "n"
            puts "Ok, your tickets have not been cancelled."
            view_my_tickets
        else
            puts "Invalid input. Please enter either 'y' or 'n'."
            answer = gets.chomp
            cancel_tickets?(answer)
        end
    end

    def edit_profile
        @attendee.profile_table
        prompt.select("What would you like to edit?") do |menu|
            menu.choice "Name", -> { change_name }
            menu.choice "Email", -> { change_email }
            menu.choice "Music Preference", -> { change_music_preference }
        end
    end

    def change_name
        @attendee.change_name
        home_page
    end

    def change_email
        @attendee.change_email
        home_page
    end

    def change_music_preference
        @attendee.change_music_preference
        home_page
    end

    def logout
        run
    end
end