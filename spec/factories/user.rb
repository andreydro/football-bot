# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Name' }
    last_name { 'Surname' }
    username { 'username' }
    telegram_id { 111_100_000 }
    banned { false }
  end
end
