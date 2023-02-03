# frozen_string_literal: true

class ParticipantsUpdater
  def call(match)
    if match.participants.main_cast.count > match.number_of_players
      move_main_cast_participants_to_replacement(match)
    else
      move_replacement_participants_to_main_cast(match)
    end
  end

  private

  def move_replacement_participants_to_main_cast(match)
    how_many_participants_needed = (match.number_of_players - match.participants.main_cast.count).abs
    replacement_participants = match.participants.ordered.replacement.first(how_many_participants_needed)
    replacement_participants.each(&:go_to_main_cast!)
  end

  def move_main_cast_participants_to_replacement(match)
    how_many_participants_needed = (match.number_of_players - match.participants.main_cast.count).abs
    main_cast_participants = match.participants.ordered.main_cast.last(how_many_participants_needed)
    main_cast_participants.each(&:go_to_replacement!)
  end
end
