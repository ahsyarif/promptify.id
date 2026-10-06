class CreatePrompts < ActiveRecord::Migration[8.1]
  def change
    create_table :prompts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.text :negative_prompt
      t.string :ai_model
      t.string :aspect_ratio
      t.references :category, null: false, foreign_key: true
      t.integer :bookmarks_count, null: false, default: 0

      t.timestamps
    end
    add_index :prompts, :slug, unique: true
    add_index :prompts, :bookmarks_count
    add_index :prompts, :created_at
  end
end
