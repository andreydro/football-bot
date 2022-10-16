class AddAdditionalToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :additional, :boolean, default: false
  end
end
