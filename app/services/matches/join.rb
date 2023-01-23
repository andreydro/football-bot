# frozen_string_literal: true

module Matches
  class Join < Base
    def call
      if participant_already_joined?
        Helpers.send_message(message, I18n.t('match.already_participating_in_the_match'))
      else
        save_participant
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
      @participant ||= Helpers.participant_object(user, match, false)
    end

    def participant_already_joined?
      match.participants.find_by(user_id: user.id, match_id: match.id, additional: false).present?
    end

    def match_text
      Helpers.match_info_text(match)
    end

    def save_participant
      if participant.save
        markup = Helpers.markup_object([Helpers.view_all_matches_button,
                                        Helpers.add_plus_one_button(match_id),
                                        Helpers.cant_come_button(participant)])
        Helpers.send_message(message, match_text, markup)
      else
        Helpers.send_message(message, I18n.t('match.error_joining_match'))
      end
    end
  end
end
