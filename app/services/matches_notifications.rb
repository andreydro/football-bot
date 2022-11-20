# frozen_string_literal: true

class MatchesNotifications
  def send_reminder(hours)
    future_matches = Match.where(start: Time.zone.now..Time.zone.now + hours.hours)

    future_matches.each do |match|
      match.participants.each do |participant|
        NotificationJob.perform_later(participant.id, hours)
      end
    end
  end
end
