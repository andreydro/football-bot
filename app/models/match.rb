# frozen_string_literal: true

class Match < ApplicationRecord
  include AASM

  has_many :participants

  aasm do
    state :active, initial: true
    state :finished
    state :canceled

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
