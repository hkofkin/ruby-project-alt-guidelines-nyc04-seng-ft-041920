class Attendee < ActiveRecord::Base
    has_many :tickets
    has_many :concerts, through: :tickets
end