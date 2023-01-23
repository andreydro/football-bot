# frozen_string_literal: true

class Base
  include Helpers

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def participant_object(additional)
    if match.participants.main_cast.count >= match.number_of_players
      Participant.new(user_id: user.id, match_id: match.id, aasm_state: :replacement, additional: additional)
    else
      Participant.new(user_id: user.id, match_id: match.id, additional: additional)
    end
  end
end
