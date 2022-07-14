class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name
      t.text :description
      t.text :image_data
      t.references :team, null: false, foreign_key: true
      t.string :position
      t.integer :player_role

      t.timestamps
    end
  end
end
