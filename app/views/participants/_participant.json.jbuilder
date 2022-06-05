json.extract! participant, :id, :full_name, :email, :phone_no, :e_transfer_number, :status, :created_at, :updated_at
json.url participant_url(participant, format: :json)
