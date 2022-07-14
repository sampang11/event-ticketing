class CreateWeekTables < ActiveRecord::Migration[6.0]
  def change
    create_table :week_tables do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :points
      t.integer :goal_for
      t.integer :goal_against
      t.integer :match_played
      t.integer :goal_diff
      t.integer :result

      t.timestamps
    end
  end
end
