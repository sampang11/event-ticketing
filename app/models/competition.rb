class Competition < ApplicationRecord
  has_many :team_competitions
  has_many :teams, through: :team_competitions
  has_many :games, dependent: :destroy
  has_many :week_tables, dependent: :destroy

  after_save :save_team_competition

  def save_team_competition
    Team.all.each do |team|
      TeamCompetition.create!(team: team, competition: self, points: 0)
    end
  end
end
