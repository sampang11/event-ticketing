class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :team_one_id
      t.integer :team_two_id
      t.integer :team_one_score
      t.integer :team_two_score
      t.integer :game_week
      t.integer :game_number

      t.timestamps
    end
  end
end
