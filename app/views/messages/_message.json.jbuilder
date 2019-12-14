json.extract! message, :id, :from_uid, :to_uid, :body, :is_read, :created_at, :updated_at
json.url message_url(message, format: :json)
