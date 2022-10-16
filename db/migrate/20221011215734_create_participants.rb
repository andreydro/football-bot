class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string :state
      t.references :match, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
