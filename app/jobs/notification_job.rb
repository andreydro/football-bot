# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :notification

  def perform(participant_id, text)
    participant = Participant.find_by(id: participant_id)
    participant.send_natification(text)
  end
end
