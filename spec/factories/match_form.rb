# frozen_string_literal: true

FactoryBot.define do
  factory :match_form do
    question_one_answered { false }
    question_two_answered { false }
    question_three_answered { false }
    question_four_answered { false }
    question_five_answered { false }
    question_six_answered { false }
    question_seven_answered { false }
    question_one_answer { '' }
    question_two_answer { '' }
    question_three_answer { '' }
    question_four_answer { '' }
    question_five_answer { '' }
    question_six_answer { '' }
    question_seven_answer { '' }
    finished { false }
    match_id { nil }
    user_id { nil }
  end
end
