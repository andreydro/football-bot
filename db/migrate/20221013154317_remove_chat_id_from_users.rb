class RemoveChatIdFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :chat_id
  end
end
