# frozen_string_literal: true

desc 'Send reminder before match: 2 hours'
task send_matchs_reminders_before_2_hours: :environment do
  MatchesNotifications.new.send_reminder(2)
end

desc 'Send morning remider'
task send_morning_reminder: :environment do
  MatchesNotifications.new.send_morning_reminder
end
