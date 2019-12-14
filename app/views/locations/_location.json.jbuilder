json.extract! location, :id, :user_uid, :city, :country, :postal_code, :lat, :lng, :status, :surfable, :created_at, :updated_at
json.url location_url(location, format: :json)
