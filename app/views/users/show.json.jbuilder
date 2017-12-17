json.extract! @user, :id, :email, :password_hash, :password_salt,
    :first_name, :last_name, :role_id, :created_at, :updated_at
json.role @user.role.role
