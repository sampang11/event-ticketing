class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.text :logo_data

      t.timestamps
    end
  end
end
