class Game < ApplicationRecord
  belongs_to :team_one_id, class_name: "Team", foreign_key: "team_one_id"
  belongs_to :team_two_id, class_name: "Team", foreign_key: "team_two_id"
  belongs_to :competition

  after_save :save_week_table

  after_destroy :delete_from_week_table

  def save_week_table
    save_team_one_record
    save_team_two_record
  end

  def delete_from_week_table
    delete_team_one_record
    delete_team_two_record
  end

  def save_team_one_record
    if team_one_score > team_two_score
      points = 3
      result = :win
    elsif team_one_score == team_two_score
      points = 1
      result = :draw
    else
      points = 0
      result = :lost
    end
    current_week_game = Game.where("game_number = ?", game_number)
    match_played = current_week_game.where("(games.team_one_id = ? AND games.team_two_id = ?) OR
(games.team_two_id = ? AND games.team_one_id = ?)", team_one_id, team_two_id, team_one_id, team_two_id)

    week_table = WeekTable.find_by("created_at >= ?", self.created_at)
    if week_table.nil?
      WeekTable.create!(team: team_one_id, points: points, goal_for: team_one_score, goal_against: team_two_score,
                        goal_diff: (team_one_score - team_two_score), match_played: match_played.count, result: result,
                        competition_id: competition_id)
    else
      week_table.update!(team: team_one_id, points: points, goal_for: team_one_score, goal_against: team_two_score,
                         goal_diff: (team_one_score - team_two_score), match_played: match_played.count, result: result,
                         competition_id: competition_id)
    end
    team_competition = TeamCompetition.find_by(team_id: team_one_id, competition_id: competition_id)
    team_competition_pts = team_competition.points.to_i + points
    team_competition.update!(points: team_competition_pts)
  end

  def save_team_two_record
    if team_two_score > team_one_score
      points = 3
      result = :win
    elsif team_two_score == team_one_score
      points = 1
      result = :draw
    else
      points = 0
      result = :lost
    end
    current_week_game = Game.where("game_number = ?", game_number)
    match_played = current_week_game.where("(games.team_one_id = ? AND games.team_two_id = ?) OR
(games.team_two_id = ? AND games.team_one_id = ?)", team_one_id, team_two_id, team_one_id, team_two_id)

    week_table = WeekTable.find_by("created_at >= ?", self.created_at)
    if week_table.nil?
      WeekTable.create!(team: team_two_id, points: points, goal_for: team_two_score, goal_against: team_one_score,
                        goal_diff: (team_two_score - team_one_score), match_played: match_played.count, result: result,
                        competition_id: competition_id)
    else
      week_table.update!(team: team_two_id, points: points, goal_for: team_two_score, goal_against: team_one_score,
                         goal_diff: (team_two_score - team_one_score), match_played: match_played.count, result: result,
                         competition_id: competition_id)
    end

    team_competition = TeamCompetition.find_by(team_id: team_two_id, competition_id: competition_id)
    team_competition_pts = team_competition.points.to_i + points
    team_competition.update!(points: team_competition_pts)
  end

  def delete_team_one_record
    week_table = WeekTable.find_by("created_at >= ?", self.created_at)
    week_table.destroy!

    if team_one_score > team_two_score
      points = 3
    elsif team_one_score == team_two_score
      points = 1
    else
      points = 0
    end

    team_competition = TeamCompetition.find_by(team_id: team_one_id, competition_id: competition_id)
    team_competition_pts = team_competition.points.to_i - points
    team_competition.update!(points: team_competition_pts)
  end

  def delete_team_two_record
    week_table = WeekTable.find_by("created_at >= ?", self.created_at)
    week_table.destroy!

    if team_two_score > team_one_score
      points = 3
    elsif team_two_score == team_one_score
      points = 1
    else
      points = 0
    end

    team_competition = TeamCompetition.find_by(team_id: team_two_id, competition_id: competition_id)
    team_competition_pts = team_competition.points.to_i - points
    team_competition.update!(points: team_competition_pts)
  end

  def current_week_game
    Game.where("game_number = ?", game_number)
  end
end
