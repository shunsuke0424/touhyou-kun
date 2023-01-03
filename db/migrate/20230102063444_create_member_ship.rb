class CreateMemberShip < ActiveRecord::Migration[7.0]
  def change
    create_table :member_ships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.index [:user_id, :group_id], unique: true

      t.timestamps
    end
  end
end
