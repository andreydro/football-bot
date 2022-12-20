class CreateMatchLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :match_logs do |t|
      t.references :match, null: false
      t.string :content

      t.timestamps
    end
  end
end
