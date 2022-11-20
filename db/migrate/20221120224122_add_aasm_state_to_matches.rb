class AddAasmStateToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :aasm_state, :string
  end
end
