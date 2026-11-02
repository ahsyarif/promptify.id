class AddPremiumToPrompts < ActiveRecord::Migration[8.1]
  def change
    add_column :prompts, :premium, :boolean, default: false, null: false
  end
end
