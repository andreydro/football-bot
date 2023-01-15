# frozen_string_literal: true

class ParticipantsUpdater
  def call(match)
    return unless match.participants.main_cast.count < match.number_of_players

    how_many_participants_needed = match.number_of_players - match.participants.main_cast.count
    replacement_participants = match.participants.ordered.replacement.first(how_many_participants_needed)
    replacement_participants.each(&:go_to_main_cast!)
  end
end
