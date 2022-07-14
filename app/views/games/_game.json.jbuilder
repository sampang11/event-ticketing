json.extract! game, :id, :team_one, :team_two, :team_one_score, :team_two_score, :game_week, :game_number, :created_at, :updated_at
json.url game_url(game, format: :json)
