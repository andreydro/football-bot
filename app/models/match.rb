# frozen_string_literal: true

class Match < ApplicationRecord
  include AASM

  after_create :creation_log

  has_many :participants, dependent: :destroy
  has_many :match_logs, dependent: :destroy

  aasm do
    state :active, initial: true
    state :finished
    state :canceled

    event :finalize do
      transitions from: :active, to: :finished, after: proc {
        MatchLog.new.create_log("Match #{self.id} finished", id)
      }
    end

    event :activate do
      transitions from: :finished, to: :active, after: proc {
        MatchLog.new.create_log("Match #{self.id} was activated", id)
      }
    end

    event :cancel do
      transitions from: %i[finished active], to: :canceled, after: proc {
        MatchesNotifications.new.send_match_canceled(self)
        MatchLog.new.create_log("Match #{id} canceled", id)
      }
    end
  end

  def creation_log
    MatchLog.new.create_log("Match #{self.id} created", id)
  end
end
