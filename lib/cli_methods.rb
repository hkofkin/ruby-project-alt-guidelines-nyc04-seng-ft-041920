class CommandLineInterface

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
        find_attendee = Attendee.find_by(email: email_input)
    end

    def login
        puts "What is your email?"
        email = gets.chomp
        if find_email(email) == nil
            existing_email_not_found
        else
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
        if find_email(attendee_email) == nil
            puts "Email saved. Please enter your name:"
            attendee_name = gets.chomp
            puts "Name saved. Please tell us your music preference:"
            attendee_pref = gets.chomp
            Attendee.create(name: attendee_name, email: attendee_email, music_preference: attendee_pref)
            puts "Thank you for creating your account."
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
        next_page_select = gets.chomp
        home_page_selection(next_page_select)
    end

    def home_page_selection(page)
        if page == "b"
            buy_tickets
        elsif page == "v"
            view_tickets
        elsif page == "e"
            edit_profile
        end
    end

    def buy_tickets
        puts "Here is a list of all upcoming concerts:"
        puts tp Concert.all.order(:date_time)
        puts "Would you like to:"
        puts "b = search by band"
        puts "c = search by city"
        search = gets.chomp
        search_for_concert(search)
    end

    def search_for_concert(search_input)
        if search_input == "b"
            find_concert_by_band
        elsif search_input == "c"
            find_concert_by_city
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
        view_concert_tickets(concert)
    end

    def find_concert_by_city
        puts "What city?"
        city_input = gets.chomp
        concert = Concert.find_by(city: city_input)
        view_concert_tickets(concert)
    end

    def view_concert_tickets(concert_input)
        puts tp tickets = Ticket.all.find_by(concert_id: concert_input.id)
        # Ticket.all.joins("INNER JOIN concerts ON tickets.concert_id = concerts.id")
        # need to join tables to show (ticket) ticket type, price, (concert) band, venue, and city
        puts "Would you like to purchase tickets for this concert?"
        puts "y = yes"
        puts "n = no"
        # based on response need to ask quantity and confirm purchase with total or go back to menu
    end

    def edit_profile
    end
    
    # def show_concerts(concerts)
    #     concerts.each do |concert|

    #     end
    # end
end