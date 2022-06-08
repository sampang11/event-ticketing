class AddAddressToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :address, :string
  end
end
