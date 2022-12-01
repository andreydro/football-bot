class AddLimitToTelegramIdInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :telegram_id, :integer, limit: 8
  end
end
