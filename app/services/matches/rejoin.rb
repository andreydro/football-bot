# frozen_string_literal: true

module Matches
  class Rejoin < Base
    def call
      if match.participants.main_cast.count >= match.number_of_players
        move_participant_to_replacement
      else
        move_participant_to_main_cast
      end
    end

    private

    def participant_id
      message.data.match(/\d+/)[0]
    end

    def participant
      @participant ||= Participant.find_by(id: participant_id)
    end

    def match
      @match ||= participant.match
    end

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    def match_text
      Matches::Info.new(match).call
    end

    def markup_with_buttons
      @markup_with_buttons ||= Helpers.markup_object([Helpers.join_or_transfer_button(match, user),
                                                      Helpers.view_all_matches_button,
                                                      Helpers.add_plus_one_button(match.id),
                                                      Helpers.additional_participants_buttons(match.id, user.id)])
    end

    def create_match_log(text)
      MatchLog.new.create_log(text, match.id)
    end

    def move_participant_to_replacement
      if participant.update(aasm_state: 'replacement')
        create_match_log("Participant #{participant.id} came back from wont_come to replacement")
        Helpers.send_message(message, match_text, markup_with_buttons)
      else
        Helpers.send_message(message, I18n.t('match.error_changing_status'))
      end
    end

    def move_participant_to_main_cast
      if participant.update(aasm_state: 'main_cast')
        create_match_log("Participant #{participant.id} came back from wont_come to main_cast")
        Helpers.send_message(message, match_text, markup_with_buttons)
      else
        Helpers.send_message(message, I18n.t('match.error_changing_status'))
      end
    end
  end
end
