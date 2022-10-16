class CreateMatchForms < ActiveRecord::Migration[6.0]
  def change
    create_table :match_forms do |t|
      t.boolean :question_one_answered, default: false
      t.boolean :question_two_answered, default: false
      t.boolean :question_three_answered, default: false
      t.boolean :question_four_answered, default: false
      t.boolean :question_five_answered, default: false
      t.boolean :question_six_answered, default: false
      t.string :question_one_answer, default: false
      t.string :question_two_answer, default: false
      t.string :question_three_answer, default: false
      t.string :question_four_answer, default: false
      t.string :question_five_answer, default: false
      t.string :question_six_answer, default: false
      t.boolean :finished, default: false
      t.integer :match_id
      t.references :user, null: false

      t.timestamps
    end
  end
end
