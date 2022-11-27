# frozen_string_literal: true

class MatchesNotifications
  attr_reader :current_time

  def initialize
    @current_time = Time.zone.now + 1.hour
  end

  def send_reminder(hours)
    future_matches = Match.active.where(start: current_time..current_time + hours.hours)
    text = I18n.t('match.begin_in_notification', hours: hours)

    future_matches.each do |match|
      match.participants.each do |participant|
        NotificationJob.perform_later(participant.id, text)
      end
    end
  end

  def send_morning_reminder
    future_matches = Match.active.where(start: current_time.beginning_of_day..current_time.end_of_day)
    text = I18n.t('match.morning_notification')

    future_matches.each do |match|
      match.participants.each do |participant|
        NotificationJob.perform_later(participant.id, text)
      end
    end
  end
end
