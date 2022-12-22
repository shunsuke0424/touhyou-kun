class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :voter, foreign_key: { to_table: :users }, index: true
      t.references :voted, foreign_key: { to_table: :users }, index: true
      t.references :keyword, foreign_key: true, index: true
      t.index [:voter_id, :keyword_id, :voted_id], unique: true
      t.timestamps
    end
  end
end
