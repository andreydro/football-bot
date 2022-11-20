class AddBannedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :banned, :boolean, null: false, default: false
  end
end
