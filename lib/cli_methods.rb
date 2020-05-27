class CommandLineInterface

    CURRENT_ATTENDEE = []

    def run 
        greet
        login_prompt
    end

    def greet
        puts "~ Welcome to Ticket Time ~"
        puts "Does quarantine have you missing concerts? We feel the same."
    end

    def login_prompt
        puts "Do you have an account?\n
        y = yes\n
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
        user = find_email(user)
        if find_email(email) == nil
            existing_email_not_found
        else
            CURRENT_ATTENDEE << user
            home_page(user)
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
            home_page(user)
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

    def home_page(user)
        # come back and personalize name in welcome message
        # add feature to recommend concerts based on location and music preference
        puts "Welcome! What would you like to do?"
        puts "b = buy tickets"
        puts "v = view my tickets"
        puts "e = edit profile"
        puts "l = logout"
        next_page_select = gets.chomp
        home_page_selection(next_page_select, user)
    end

    def home_page_selection(page, user)
        if page == "b"
            buy_tickets
        elsif page == "v"
            view_my_tickets(user)
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
            home_page(user)
        else
            puts "Please enter either 'b' or 'c'."
            search = gets.chomp
            search_for_concert(search)
        end
    end

    def find_concert_by_band
        puts "What band are you looking to see?"
        band_input = gets.chomp
        concert = Concert.find_by(band: band_input)
        view_available_concert_tickets(concert)
    end

    def find_concert_by_city
        puts "What city?"
        city_input = gets.chomp
        concert = Concert.find_by(city: city_input)
        view_available_concert_tickets(concert)
    end

    def tickets_available(tickets)
        tickets != nil
    end

    def view_available_concert_tickets(concert_input)
        tickets = Ticket.all.find_by(concert_id: concert_input.id)
        # Ticket.all.joins("INNER JOIN concerts ON tickets.concert_id = concerts.id")
        # need to join tables to show (ticket) ticket type, price, (concert) band, venue, and city
        if tickets_available(tickets)
            tp tickets
            puts "Would you like to purchase tickets for this concert?"
            puts "y = yes"
            puts "n = no"
            want_to_purchase = gets.chomp
            purchase?(want_to_purchase, tickets)
        else 
            puts "Sorry, no tickets are currently available."
            buy_tickets
        end
    end

    def purchase?(response, ticket_instance)
        if response == "y"
            puts "Great! We are happy to reserve tickets for you. How many would you like to buy?"
            quantity_wanted = gets.chomp
            total_price = quantity_wanted.to_i * ticket_instance.ticket_price
            puts "Your total price for #{quantity_wanted} tickets is $#{total_price}. Confirm purchase?"
            puts "y = yes"
            puts "n = no"
            confirmation = gets.chomp
            confirm_purchase(confirmation)
        elsif response == "n"
            puts "Not interested at this time? No problem."
            buy_tickets
        else 
        end
    end

    def confirm_purchase(input)
        if input == "y"
            puts "Thank you for your purchase! Select 'v' at main menu to view your tickets."
            Ticket.attendee_id = CURRENT_ATTENDEE.first.id
            home_page
        elsif input == "n"
            puts "Not ready to purchase? No problem. Back to home page..."
            home_page
        else
            puts "Please enter either 'y' or 'n'."
            confirmation = gets.chomp
            confirm_purchase(confirmation)
        end
    end

    def edit_profile
    end

    def view_my_tickets(user)
        user = Attendee.find(user.id)
        user.tickets_owned
    end

    def logout
        run
        CURRENT_ATTENDEE.clear
    end
end