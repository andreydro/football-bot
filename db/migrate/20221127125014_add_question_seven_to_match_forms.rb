class AddQuestionSevenToMatchForms < ActiveRecord::Migration[6.0]
  def change
    add_column :match_forms, :question_seven_answered, :boolean, default: false
    add_column :match_forms, :question_seven_answer, :string

    change_column_default(:match_forms, :question_one_answer, nil)
    change_column_default(:match_forms, :question_two_answer, nil)
    change_column_default(:match_forms, :question_three_answer, nil)
    change_column_default(:match_forms, :question_four_answer, nil)
    change_column_default(:match_forms, :question_five_answer, nil)
    change_column_default(:match_forms, :question_six_answer, nil)
  end
end
