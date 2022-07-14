class CreateTeamCompetitions < ActiveRecord::Migration[6.0]
  def change
    create_table :team_competitions do |t|
      t.references :team, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.integer :points

      t.timestamps
    end
  end
end
