class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_images do |t|
      t.string :filename
      t.string :content_type
      t.binary :data
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
