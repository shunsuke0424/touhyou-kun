class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :content, null: false, default: ''
      t.index ["content"], name: "index_keywords_on_content", unique: true
      t.timestamps
    end
  end
end
