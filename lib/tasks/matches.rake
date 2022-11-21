# frozen_string_literal: true

desc 'Change state for finished matches'
task update_state_for_matches: :environment do
  current_time = Time.zone.now + 1.hour
  past_matches = Match.active.where('finish < ?', current_time)
  past_matches.each(&:finalize!)
end
