Attendee.destroy_all
Concert.destroy_all
Ticket.destroy_all

kind_of_ticket = ["general admission", "floor", "lower level", "upper level"]

# 5.times do
#     Attendee.create(name: Faker::Name.name, email: Faker::Internet.email, music_preference: Faker::Music.genre)
#     Concert.create(band: Faker::Music.band, venue: Faker::Address.street_name, city: Faker::Address.city, date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
#     Ticket.create(concert_id: Concert.all.sample.id, ticket_type: kind_of_ticket.sample, price: rand(30..100))
# end

hannah = Attendee.create(name: "Hannah", email: "hk", music_preference: "pop")
coldplay = Concert.create(band: "Coldplay", venue: "United Center", city: "Chicago", date_time: Faker::Time.forward(days: 365,  period: :evening, format: :long))
t1 = Ticket.create(concert_id: coldplay.id, ticket_type: "upper level", price: rand(30..50))
t1 = Ticket.create(concert_id: coldplay.id, ticket_type: "lower level", price: rand(50..80))
t1 = Ticket.create(concert_id: coldplay.id, ticket_type: "floor", price: rand(80..100))