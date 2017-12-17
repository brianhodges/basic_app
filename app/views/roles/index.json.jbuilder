json.array!(@roles) do |role|
  json.extract! role, :id, :role
  json.num_of_users role.users.size
  json.url role_url(role, format: :json)
end
