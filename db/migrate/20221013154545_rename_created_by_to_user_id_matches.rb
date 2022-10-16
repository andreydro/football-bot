class RenameCreatedByToUserIdMatches < ActiveRecord::Migration[6.0]
  def change
    rename_column :matches, :created_by, :user_id
  end
end
