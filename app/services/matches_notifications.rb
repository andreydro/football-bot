# frozen_string_literal: true

class MatchesNotifications
  attr_reader :current_time

  def initialize
    # Update it when time zone changes in Poland
    # + 1.hour in winter
    # + 2.hours in summer
    @current_time = Time.zone.now + 2.hours
  end

  def send_reminder
    text = I18n.t('match.begin_in_notification', hours: 2)
    two_hour_matches.each do |match|
      match.participants.main_cast.each do |participant|
        NotificationJob.perform_later(participant.id, text)
      end
    end
  end

  def send_morning_reminder
    future_matches = Match.active.where(start: current_time.beginning_of_day..current_time.end_of_day)
    text = I18n.t('match.morning_notification')

    future_matches.each do |match|
      match.participants.main_cast.each do |participant|
        NotificationJob.perform_later(participant.id, text)
      end
    end
  end

  def send_match_canceled(match)
    text = I18n.t('match.cancel_match_notification', title: match.title)
    match.participants.main_cast.each do |participant|
      NotificationJob.perform_later(participant.id, text)
    end
  end

  private

  def two_hour_matches
    hours = 2
    Match.active.where(start: current_time..current_time + hours.hours)
         .where.not(start: current_time..current_time + (hours - 1).hours)
  end
end
