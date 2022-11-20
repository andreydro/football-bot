class UpdateFieldsForMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :start, :datetime
    add_column :matches, :duration, :integer
    add_column :matches, :finish, :datetime
    remove_column :matches, :day, :string
    remove_column :matches, :time, :string
  end
end
