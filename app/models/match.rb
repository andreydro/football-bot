# frozen_string_literal: true

class Match < ApplicationRecord
  include AASM

  has_many :participants
  has_many :match_logs

  aasm do
    state :active, initial: true, before_enter: proc { MatchLog.new.create_log("Match #{id} created", id) }
    state :finished, before_enter: proc { MatchLog.new.create_log("Match #{id} finished", id) }
    state :canceled, before_enter: proc { MatchLog.new.create_log("Match #{id} canceled", id) }

    event :finalize do
      transitions from: :active, to: :finished
    end

    event :activate do
      transitions from: :finished, to: :active
    end

    event :cancel do
      transitions from: %i[finished active], to: :canceled, after: proc {
        MatchesNotifications.new.send_match_canceled(self)
      }
    end
  end
end
