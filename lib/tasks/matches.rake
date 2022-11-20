# frozen_string_literal: true

desc 'Change state for finished matches'
task update_state_for_matches: :environment do
  past_matches = Match.active.where('finish < ?', Time.zone.now)
  past_matches.each(&:finilazie!)
end
