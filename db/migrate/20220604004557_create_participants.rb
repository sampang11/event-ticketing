class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string :full_name
      t.string :email
      t.string :phone_no
      t.string :e_transfer_number
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
