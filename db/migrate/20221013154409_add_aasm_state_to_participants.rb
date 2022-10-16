class AddAasmStateToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :aasm_state, :string
    remove_column :participants, :state
  end
end
