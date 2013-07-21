json.array!(@messages) do |message|
  json.extract! message, :subject, :sender, :content, :date, :user_id, :mail_id_uniqueness
  json.url message_url(message, format: :json)
end
