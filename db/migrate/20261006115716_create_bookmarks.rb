class CreateBookmarks < ActiveRecord::Migration[8.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bookmarks, [ :user_id, :prompt_id ], unique: true
  end
end
