json.array!(@users) do |user|
  json.extract! user, :id, :email, :password, :pivotal_api_token
  json.url user_url(user, format: :json)
end
