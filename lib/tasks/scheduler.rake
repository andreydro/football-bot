# frozen_string_literal: true

desc 'Send reminder before match: 1 hours'
task send_matchs_reminders_before_1_hours: :environment do
  MatchesNotifications.new.send_reminder(1)
end

desc 'Send reminder before match: 2 hours'
task send_matchs_reminders_before_2_hours: :environment do
  MatchesNotifications.new.send_reminder(2)
end
