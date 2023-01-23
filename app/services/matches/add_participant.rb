# frozen_string_literal: true

module Matches
  class AddParticipant < Base
    def call
      if participant.save
        Helpers.send_message(message, match_text, markup_with_buttons)
      else
        Helpers.send_message(message, I18n.t('match.error_joining_match'))
      end
    end

    private

    def match_id
      @match_id ||= message.data.match(/\d+/)[0]
    end

    def match
      @match ||= Match.find_by(id: match_id)
    end

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    def participant
      @participant ||= Helpers.participant_object(user, match, true)
    end

    def match_text
      Helpers.match_info_text(match)
    end

    def markup_with_buttons
      @markup_with_buttons ||= Helpers.markup_object([Helpers.join_or_transfer_button(match, user),
                                                      Helpers.view_all_matches_button,
                                                      Helpers.add_plus_one_button(match_id),
                                                      Helpers.additional_participants_buttons(match_id, user.id)])
    end
  end
end
