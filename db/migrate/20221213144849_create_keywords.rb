class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :option, null: false, default: ''
      t.timestamps
    end
  end
end
