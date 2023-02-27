# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    title { 'Ursus' }
    location { 'http://google.maps.com' }
    number_of_players { 14 }
    have_ball_and_shirtfronts { 'Player' }
    duration { 2 }
    aasm_state { 'active' }
    start { Time.current + 2 }
    finish { Time.current + 4 }
    user_id { 1 }
    withdrawal_perion { 3 }
  end
end
