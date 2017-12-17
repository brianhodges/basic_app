json.array!(@users) do |user|
  json.extract! user, :id, :last_name, :first_name, :email,
    :password_hash, :password_salt, :role_id
  json.role user.role.role
  json.url user_url(user, format: :json)
end
