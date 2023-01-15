# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    match_id { 1 }
    user_id { 2 }
    additional { false }
    aasm_state { 'main_cast' }
  end
end
