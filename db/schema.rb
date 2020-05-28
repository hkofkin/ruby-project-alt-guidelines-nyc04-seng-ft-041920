# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_28_015935) do

  create_table "attendees", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "music_preference"
  end

  create_table "concerts", force: :cascade do |t|
    t.string "band"
    t.string "venue"
    t.string "city"
    t.datetime "date_time"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "attendee_id"
    t.integer "concert_id"
    t.string "ticket_type"
    t.integer "price"
    t.integer "quantity_purchased"
  end

end
