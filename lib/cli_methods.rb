class CommandLineInterface

    CURRENT_ATTENDEE = []

    def run 
        greet
        login_prompt
    end

    def greet
        puts "~ Welcome to Ticket Time ~"
        puts "Who's ready to jam?"
    end

    def login_prompt
        puts "Do you have an account?\n
        y = yes
        n = no\n"
        account_answer = gets.chomp
        attendee_has_account?(account_answer)
    end

    def attendee_has_account?(answer)
        if answer == "y"
            login
        elsif answer == "n"
            create_account
        else 
            puts "Please enter either 'y' or 'n'."
            login_prompt
        end
    end

    def find_email(email_input)
        #find or create by to take care of both finding or creating new?
        find_attendee = Attendee.find_by(email: email_input)
    end

    def login
        puts "What is your email?"
        email = gets.chomp
        user = find_email(email)
        if find_email(email) == nil
            existing_email_not_found
        else
            CURRENT_ATTENDEE << user
            home_page
        end
    end

    def existing_email_not_found
        puts "That email does not exist in our records. Would you like to create a new account?"
        puts "c = create new account"
        puts "e = enter email"
        email_prompt = gets.chomp
        email_not_found(email_prompt)
    end

    def create_account
        puts "Please enter your email:"
        attendee_email = gets.chomp
        user = find_email(attendee_email)
        if find_email(attendee_email) == nil
            puts "Email saved. Please enter your name:"
            attendee_name = gets.chomp
            puts "Name saved. Please tell us your music preference:"
            attendee_pref = gets.chomp
            Attendee.create(name: attendee_name, email: attendee_email, music_preference: attendee_pref)
            puts "Thank you for creating your account."
            CURRENT_ATTENDEE << user
            home_page
        else
            email_already_exists(attendee_email)
        end
    end

    def email_already_exists(email_input)
        if find_email(email_input) != nil
            puts "This email already exists."
            create_account
        end
    end

    def email_not_found(answer)
        if answer == "c"
            create_account
        elsif answer == "e"
            login
        else
            puts "Please enter either 'c' or 'e'."
            email_input = gets.chomp
            find_email(email_input)
        end
    end

    def home_page
        # come back and personalize name in welcome message
        # add feature to recommend concerts based on location and music preference
        puts "Welcome! What would you like to do?"
        puts "b = buy tickets"
        puts "v = view my tickets"
        puts "e = edit profile"
        puts "l = logout"
        next_page_select = gets.chomp
        home_page_selection(next_page_select)
    end

    def home_page_selection(page)
        if page == "b"
            buy_tickets
        elsif page == "v"
            view_my_tickets
        elsif page == "e"
            edit_profile
        elsif page == "l"
            logout
        else 
            puts "Please enter either 'b', 'v', or 'e'."
            next_page_select = gets.chomp
            home_page_selection(next_page_select)
        end
    end

    def buy_tickets
        puts "Here is a list of all upcoming concerts:"
        puts tp Concert.all.order(:date_time)
        puts "Would you like to:"
        puts "b = search by band"
        puts "c = search by city"
        puts "m = back to main menu"
        search = gets.chomp
        search_for_concert(search)
    end

    def search_for_concert(search_input)
        if search_input == "b"
            find_concert_by_band
        elsif search_input == "c"
            find_concert_by_city
        elsif search_input == "m"
            home_page
        else
            puts "Invalid input. Please enter either 'b' or 'c'."
            search = gets.chomp
            search_for_concert(search)
        end
    end

    def find_concert_by_band
        puts "What band are you looking to see?"
        band_input = gets.chomp
        tp concert = Concert.where(band: band_input)
        if !concert
            puts "That concert does not exist. Please enter existing concert:"
            find_concert_by_band
        elsif concert.count > 1
            # tp concert_reduced = Concert.where(band: band_input) 
            filter_bands_by_city(concert) # delete this if change doesn't work
            # find_concert_by_city
        else
            view_available_concert_tickets(concert[0])
        end
    end

    def filter_bands_by_city(concerts_array)
        puts "What city?"
        city_input = gets.chomp
        concerts_array = Concert.where(city: city_input) 
        view_available_concert_tickets(concerts_array[0])
    end

    def find_concert_by_city
        puts "What city?"
        city_input = gets.chomp
        tp concert = Concert.where(city: city_input)
        if !concert
            puts "There are currently no upcoming concerts in that city. Please enter existing city:"
            find_concert_by_band
        elsif concert.count > 1
            # tp concert_reduced = Concert.where(city: city_input) 
            filter_cities_by_band(concert)
        else
            view_available_concert_tickets(concert[0])
        end
    end

    def filter_cities_by_band(concerts_array)
        puts "What band are you looking to see?"
        band_input = gets.chomp
        concerts_array = Concert.where(band: band_input) 
        view_available_concert_tickets(concerts_array[0])
    end

    def view_available_concert_tickets(concert_instance)
        tickets = concert_instance.tickets_available
        # Ticket.all.joins("INNER JOIN concerts ON tickets.concert_id = concerts.id")
        # need to join tables to show (ticket) ticket type, price, (concert) band, venue, and city
        if tickets.empty?
            puts "Sorry, no tickets are currently available."
            buy_tickets
        else
            tp tickets
            puts "Would you like to purchase tickets for this concert?"
            puts "y = yes"
            puts "n = no"
            want_to_purchase = gets.chomp
            purchase?(want_to_purchase, tickets)
        end
    end

    def ticket_type_select(type, tickets) 
        selected_ticket = tickets.select { |ticket_instance| ticket_instance.ticket_type == type }
        if selected_ticket
            ticket_type_check_quantity(selected_ticket)
        else 
            puts "This ticket type does not exist for this concert. Please enter one of the available options:"
            ticket_type = gets.chomp
            ticket_type_select(type, tickets)
        end
    end

    def ticket_type_check_quantity(instance)
        if instance.count > 1 
            puts "What ticket type are you looking for?" 
            ticket_type = gets.chomp
            ticket_type_select(ticket_type, instance) 
        else 
            puts "How many would you like to buy?" 
            ticket = instance[0]
            quantity = gets.chomp.to_i
            total_price = quantity * ticket.price
            puts "Your total price for #{quantity} tickets is $#{total_price}. Confirm purchase?"
            puts "y = yes"
            puts "n = no"
            confirmation = gets.chomp
            confirm_purchase(confirmation, ticket, quantity)
        end
    end

    def purchase?(response, ticket_instance)
        if response == "y"
            puts "Great! We are happy to reserve tickets for you."
            ticket_type_check_quantity(ticket_instance)
        elsif response == "n"
            puts "Not interested at this time? No problem."
            buy_tickets
        else 
            puts "Please enter either 'y' or 'n'."
            want_to_purchase = gets.chomp
            purchase?(want_to_purchase, tickets)
        end
    end

    def confirm_purchase(input, ticket_instance, quantity)
        if input == "y"
            ticket_instance.quantity_purchased = quantity
            puts "Thank you for your purchase! Select 'v' at main menu to view your tickets."
            CURRENT_ATTENDEE[0].tickets << ticket_instance 
            home_page
        elsif input == "n"
            puts "Not ready to purchase? No problem. Back to home page..."
            home_page
        else
            puts "Please enter either 'y' or 'n'."
            confirmation = gets.chomp
            confirm_purchase(confirmation, ticket_instance)
        end
    end

    def view_my_tickets
        tickets_owned = CURRENT_ATTENDEE[0].view_my_tickets
        if tickets_owned.empty?
            puts "You have not purchased any tickets."
            home_page
        else
            tp tickets_owned
            puts "What would you like to do?"
            puts "1 = cancel purchase"
            puts "2 = go back to main menu"
            page = gets.chomp
            view_tickets_menu_action(page)
        end
    end

    def view_tickets_menu_action(input)
        if input == "1"
            if CURRENT_ATTENDEE[0].tickets.count > 1
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
            CURRENT_ATTENDEE[0].tickets.clear
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
        puts "What would you like to edit?"
        puts "1 = name"
        puts "2 = email"
        puts "3 = music preference"
        edit = gets.chomp
        go_to_edit(edit)
    end

    def go_to_edit(input)
        if input == "1"
            puts "Please enter your new name:"
            name = gets.chomp
            CURRENT_ATTENDEE[0].update(name: name)
            puts "Your profile has been updated."
            tp CURRENT_ATTENDEE[0]
            home_page
        elsif input == "2"
            puts "Please enter your new email:"
            email = gets.chomp
            CURRENT_ATTENDEE[0].update(email: email)
            puts "Your profile has been updated."
            tp CURRENT_ATTENDEE[0]
            home_page
        elsif input == "3"
            tp CURRENT_ATTENDEE[0]
            puts "Please enter your new music preference:"
            music_preference = gets.chomp
            CURRENT_ATTENDEE[0].update(music_preference: music_preference)
            puts "Your profile has been updated."
            tp CURRENT_ATTENDEE[0]
            home_page
        else
            puts "Please enter either '1', '2', or '3'."
            edit = gets.chomp
            go_to_edit(edit)
        end
    end

    def logout
        CURRENT_ATTENDEE.clear
        run
    end
end