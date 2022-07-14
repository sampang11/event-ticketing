json.extract! player, :id, :name, :description, :image_data, :team_id, :position, :player_role, :created_at, :updated_at
json.url player_url(player, format: :json)
