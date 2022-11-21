# frozen_string_literal: true

class MatchesNotifications
  def send_reminder(hours)
    current_time = Time.zone.now + 1.hour
    future_matches = Match.where(start: current_time..current_time + hours.hours)

    future_matches.each do |match|
      match.participants.each do |participant|
        NotificationJob.perform_later(participant.id, hours)
      end
    end
  end
end
