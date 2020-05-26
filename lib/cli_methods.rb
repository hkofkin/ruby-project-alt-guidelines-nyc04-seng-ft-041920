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
        puts "Do you have an account?"
        puts "y = yes"
        puts "n = no"
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

    def login
        puts "What is your email?"
        email = gets.chomp
        email_exists?(email)
    end

    def email_exists?(email_input)
        find_attendee = Attendee.find_by(email: email_input)
        if find_attendee == nil
            puts "That email does not exist in our records. Would you like to create a new account?"
            puts "c = create new account"
            puts "e = enter email"
            email_exist_prompt = gets.chomp
            email_not_found(email_exist_prompt)
        else
            home_page
        end
    end

    def email_duplicate?(email)
        if email_exists?(email) == true
            puts "This email already exists. Please enter a new email:"
            create_account
        end
    end

    def create_account
        puts "Please enter your email:"
        attendee_email = gets.chomp
        email_duplicate?(attendee_email)
        puts "Please enter your name:"
        attendee_name = gets.chomp
        puts "Please tell us your music preference:"
        attendee_pref = gets.chomp
        Attendee.create(name: attendee_name, email: attendee_email, music_preference: attendee_pref)
        home_page
    end

    def email_not_found(answer)
        if answer == "c"
            create_account
        elsif answer == "e"
            login
        else
            puts "Please enter either 'c' or 'e'."
            email_input = gets.chomp
            email_exists?(email_input)
        end
    end

    def home_page
        #come back and personalize name in welcome message
        puts "Welcome! What would you like to do?"
        puts "b = buy tickets"
        puts "v = view my tickets"
        puts "e = edit profile"

    end
    
    # def show_concerts(concerts)
    #     concerts.each do |concert|

    #     end
    # end
end