class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.references :ticket, null: false, foreign_key: true
      t.integer :status, default: 0
      t.datetime :entry_time

      t.timestamps
    end
  end
end
