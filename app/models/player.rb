class Player < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :team
  validates :name, presence: true

  enum player_role: {
    captain: 0,
    vice_captain: 1,
    player: 2
  }
end
