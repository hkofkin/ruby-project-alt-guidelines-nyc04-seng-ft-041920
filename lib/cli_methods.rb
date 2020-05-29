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
        puts "

MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MXMMMMMMMMMMMMMMMMMMMNMMMMMWKMMMMMMMONMMXMMMMMMMMMMMMMXMXMMMMMMMMMMM00MMMMMMMMMMMMMMNMMMMMWMMMMMMMMMMMMMMNMMMMKMNO0MMMMMMMMMMMMMMMXOXMKMMMMMMMMMMMKMMM
MN              NN   XMMMNY          YNNN    KMWO    dNMO           NN              XMMMMMN              XN   kMN  kWMMMMMMMMMMMWK  0Mk           kMMM
MXnnnnn    nnnnnkN   XMWO    nnNNnn   lX0    KNx    kWMMO    nnnnnnn0Knnnnn    nnnnnNMMMMMWnnnnn    nnnnnXN   kMN   lXMMMMMMMMMNx   0Mk    nnnnnnnKMMM
MMMMMWM    WMMMMkN   XWk   nl0WMMMWXOONM0    kl    0WMMMO    KWWWWWMMMMMMXO    kMMMMMMMMMMMMMMMM    KMMMMXN   kMN     OWMMMMMMKc    0Mk    KWWWWWMMMMM
MMMMMWM    WMMMMkN   XX:   nWMMMMMMMMMMM0    :  .lXMMMMMO    KWWWWW0MMMMMNO    kMMMMMMMMMMMMMMMM    KMMMMXN   kMN      oXMMMNx      0Mk    KWWWWWKMMMM
MMMMMWM    WMMMMkN   XK,   nMMMMMMMMMMMM0       'OWMMMMMO          MMMMMMNO    kMMMMMMMMMMMMMMMM    KMMMMXN   kMN        OWK        0Mk          kMMMM
MMMMMWM    WMMMMkN   XXc   nNMMMMMMMMMMM0    ;.  'kWMMMMO    dkkkkOXMMMMMNO    kMMMMMMMMMMMMMMMM    KMMMMXN   kMN    ,    V    ,    0Mk    dkkkkONMMMM
MMMMMWM    WMMMMkN   XM0,   nkXNWWNOodXM0    0k    lXMMMO    0WWWWWWWMMMMNO    kMMMMMMMMMMMMMMMM    KMMMMXN   kMN    x0       kO    0Mk    KWWWWWWWMMM
MMMMMWO    WMMMMkN   XMWKc    YNNNY   cX0    KMK:    0WMO    0WWWWW:OMMMMNO    kMMMMMMMMMMMMMMMM    KMMMMXN   kMN    kMXo   oKW0    0Mk    0WWWWW:0MMM
MMMMMWO    WMMMMON   XMMMW0o         ,OW0    KMMNd    kW0           MMMMMNO    kMMMMMMMMMMMMMMMM    XMMMMXN   kMN    kMMWO dNMMK    KMO           kMMM
MMMMMWX000NMMMMMNK00XWMMMMMMWX0OkkOKNMMMWK00KWMMMWX000XWWK000000000KNMMMMWX000KNMMMMMMMMMMMMMMMWK00XWMMMMWX00KNMWX00KNMMMMWMMMMWK00KWMNK000000000KNMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
".colorize(:color => :white, :background => :blue) 

        puts "*******************************************"
        puts "\nWelcome to Ticket Time! Hear it. See it. Live it. "
    end

    def login_prompt
        prompt.select("\nDo you have an account?") do |menu|
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
        prompt.select("\n\nWelcome! What would you like to do?") do |menu|
            menu.choice "Buy tickets", -> { buy_tickets }
            menu.choice "View my tickets", -> { view_my_tickets }
            menu.choice "Edit profile", -> { edit_profile }
            menu.choice "Logout", -> { logout }
        end
    end

    def buy_tickets
        Concert.all_concerts
        prompt.select("Would you like to:") do |menu|
            menu.choice "Search by artist", -> { self.find_concert_by_band }
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
            ticket_array = []
            ticket_instances = tickets.map do |ticket|
                {ticket.ticket_type => ticket}
            end
            ticket = prompt.select("\nWhat ticket type are you looking for?", ticket_instances)
            ticket_array << ticket
            ticket_type_check_quantity(ticket_array)
        elsif tickets.count == 1
            ticket_type_check_quantity(tickets)
        elsif tickets.count < 1
            puts "Sorry, no tickets are currently available."
            buy_tickets
        end
    end

    def ticket_type_check_quantity(instance)
        puts "\nGreat! We are happy to reserve tickets for you."
        quantity = instance.first.select_ticket_quantity
        total_price = quantity * instance.first.price
        prompt.select("Your total price for #{quantity} tickets is $#{total_price}. Confirm purchase?") do |menu|
            menu.choice "Yes", -> { confirm_purchase(instance, quantity) }
            menu.choice "No", -> { home_page }
        end
    end

    def confirm_purchase(ticket_instance, quantity)
        ticket_instance.first.quantity_purchased = quantity
        system "clear"
        puts "\nThank you for your purchase!".colorize(:color => :black, :background => :green)
        @attendee.tickets << ticket_instance 
        home_page
    end

    def view_my_tickets
        tickets_owned = @attendee.tickets
        if tickets_owned.empty?
            puts "\nYou have no upcoming concerts.😢"
            home_page
        else
            @attendee.view_my_tickets
            prompt.select("What would you like to do?") do |menu|
                menu.choice "Cancel purchase", -> { cancel_tickets(tickets_owned) }
                menu.choice "Go back to main menu", -> { home_page }
            end
        end
    end

    def cancel_tickets(input)
        ticket_array = []
        if input.count > 1
            ticket_instances = input.map do |ticket|
                {ticket.concert.band => ticket}
            end
            ticket_to_cancel = prompt.select("\nWhich ticket purchase would you like to cancel?", ticket_instances)
            ticket_array << ticket_to_cancel
            cancel_tickets?(ticket_array)
        else
            cancel_tickets?(input)
        end
    end

    def cancel_tickets?(ticket_to_cancel)
        ticket = prompt.select("Are you sure you want to cancel your ticket purchase?") do |menu|
            menu.choice "Yes", -> { delete_ticket(ticket_to_cancel) }
            menu.choice "No", -> { view_my_tickets }
        end
    end

    def delete_ticket(ticket_to_cancel)
        ticket = @attendee.tickets.find_by(id: ticket_to_cancel.first.id)
        @attendee.tickets.delete(ticket)
        puts "\nCancellation successful.".colorize(:color => :black, :background => :green)
        view_my_tickets
    end

    def edit_profile
        prompt.select("\nWhat would you like to edit?") do |menu|
            menu.choice "Name", -> { change_name }
            menu.choice "Email", -> { change_email }
            menu.choice "Music Preference", -> { change_music_preference }
            menu.choice "Back to main menu", -> { home_page }
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
        system "clear"
        run
    end
end