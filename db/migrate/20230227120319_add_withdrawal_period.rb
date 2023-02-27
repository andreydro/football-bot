class AddWithdrawalPeriod < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :withdrawal_perion, :integer, null: false, default: 0
  end
end
