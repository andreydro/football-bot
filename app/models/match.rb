# frozen_string_literal: true

class Match < ApplicationRecord
  include AASM

  has_many :participants

  aasm do
    state :active, initial: true
    state :finished

    event :finalize do
      transitions from: :active, to: :finished
    end

    event :activate do
      transitions from: :finished, to: :active
    end
  end
end
