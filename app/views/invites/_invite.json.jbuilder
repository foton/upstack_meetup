json.extract! invite, :id, :from_uid, :to_address, :created_at, :updated_at
json.url invite_url(invite, format: :json)
