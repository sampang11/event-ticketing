class Team < ApplicationRecord
  include ImageUploader::Attachment(:logo)
  validates :name, presence: true

  has_many :players, dependent: :destroy
  has_many :week_tables, dependent: :destroy
  has_many :team_competitions
  has_many :competitions, through: :team_competitions
end
