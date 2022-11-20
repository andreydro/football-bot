# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :notification

  def perform(participant_id, hours)
    participant = Participant.find_by(id: participant_id)

    text = I18n.t('match.begin_in_notification', hours: hours)
    participant.send_natification(text)
  end
end
