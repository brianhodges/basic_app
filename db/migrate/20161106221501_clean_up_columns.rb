class CleanUpColumns < ActiveRecord::Migration
  def change
    change_column :roles, :role, :string, default: "", null: false
    change_column :user_images, :filename, :string, default: "", null: false
    change_column :user_images, :content_type, :string, default: "", null: false
    change_column :users, :email, :string, default: "", null: false
    change_column :users, :password_hash, :string, default: "", null: false
    change_column :users, :password_salt, :string, default: "", null: false
    change_column :users, :first_name, :string, default: "", null: false
    change_column :users, :last_name, :string, default: "", null: false
  end
end
