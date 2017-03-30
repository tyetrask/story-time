json.user do
  json.id @user.id
  json.email @user.email
  json.settings @user.settings
  json.integrations @user.integrations do |integration|
    json.id integration.id
    json.service_type integration.service_type
  end
end
