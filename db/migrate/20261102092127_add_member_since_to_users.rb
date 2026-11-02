class AddMemberSinceToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :member_since, :datetime
  end
end
