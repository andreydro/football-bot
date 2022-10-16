class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :title
      t.string :day
      t.string :time
      t.string :location
      t.integer :number_of_players
      t.integer :created_by, null: false
      t.string :have_ball_and_shirtfronts

      t.timestamps
    end
  end
end
