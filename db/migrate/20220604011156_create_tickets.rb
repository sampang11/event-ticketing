class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.string :ticket_number
      t.references :participant, null: false, foreign_key: true
      t.integer :age_group, default: 1

      t.timestamps
    end
  end
end
