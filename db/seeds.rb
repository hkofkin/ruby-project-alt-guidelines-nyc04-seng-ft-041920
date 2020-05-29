Attendee.destroy_all
Concert.destroy_all
Ticket.destroy_all

kind_of_ticket = ["general admission", "floor", "lower level", "upper level"]

# 5.times do
#     Attendee.create(name: Faker::Name.name, email: Faker::Internet.email, music_preference: Faker::Music.genre)
#     Concert.create(band: Faker::Music.band, venue: Faker::Address.street_name, city: Faker::Address.city, date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
#     Ticket.create(concert_id: Concert.all.sample.id, ticket_type: kind_of_ticket.sample, price: rand(30..100), quantity_purchased: 0, max_quantity: 100)
# end

hannah = Attendee.create(name: "Hannah Kofkin", email: "hkofkin@gmail.com", music_preference: "pop")
ariana = Concert.create(band: "Ariana Grande", venue: "United Center", city: "Chicago", date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
billy = Concert.create(band: "Billy Joel", venue: "Madison Square Garden", city: "New York", date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
john = Concert.create(band: "John Mayer", venue: "Staples Center", city: "Los Angeles", date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
kacey = Concert.create(band: "Kacey Musgraves", venue: "Bridgestone Arena", city: "Nashville", date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
rob = Concert.create(band: "Matchbox Twenty", venue: "Riverside Theater", city: "Milwaukee", date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
t1 = Ticket.create(concert_id: ariana.id, ticket_type: "upper level", price: rand(30..50), quantity_purchased: 0)
t2 = Ticket.create(concert_id: ariana.id, ticket_type: "lower level", price: rand(50..80), quantity_purchased: 0)
t3 = Ticket.create(concert_id: billy.id, ticket_type: "floor", price: rand(80..100), quantity_purchased: 0)
t4 = Ticket.create(concert_id: billy.id, ticket_type: "upper level", price: rand(30..50), quantity_purchased: 0)
t5 = Ticket.create(concert_id: billy.id, ticket_type: "lower level", price: rand(50..80), quantity_purchased: 0)
t6 = Ticket.create(concert_id: john.id, ticket_type: "floor", price: rand(80..100), quantity_purchased: 0)
t7 = Ticket.create(concert_id: john.id, ticket_type: "lower level", price: rand(80..100), quantity_purchased: 0)
t8 = Ticket.create(concert_id: kacey.id, ticket_type: "upper level", price: rand(30..50), quantity_purchased: 0)
t9 = Ticket.create(concert_id: kacey.id, ticket_type: "lower level", price: rand(50..80), quantity_purchased: 0)
t10 = Ticket.create(concert_id: rob.id, ticket_type: "floor", price: rand(80..100), quantity_purchased: 0)

puts "Seeding complete."