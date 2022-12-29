class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :like_user, foreign_key: { to_table: :users }, index: true
      t.references :liked_user, foreign_key: { to_table: :users }, index: true
      t.index [:like_user_id, :liked_user_id], unique: true

      t.timestamps
    end
  end
end
