class Ticket < ApplicationRecord
  belongs_to :participant

  has_one :attendance, dependent: :destroy

  enum age_group: {
    children: 0,
    adult: 1
  }
end
