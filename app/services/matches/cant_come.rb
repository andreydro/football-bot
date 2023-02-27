# frozen_string_literal: true

module Matches
  class CantCome < Base
    def call
      if leaving_time_is_over?
        Helpers.send_message(message,
                             I18n.t('match.cant_leave_match_before_start', hours: match.withdrawal_perion))
      else
        move_participant_to_wont_come
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

    def leaving_time_is_over?
      Time.current.between?(match.start - match.withdrawal_perion.hours, match.start)
    end

    def markup_with_buttons
      @markup_with_buttons ||= Helpers.markup_object([Helpers.show_match_button(match),
                                                      Helpers.view_all_matches_button])
    end

    def move_participant_to_wont_come
      if participant.go_to_wont_come!
        ParticipantsUpdater.new.call(match)
        Helpers.send_message(message, "#{I18n.t('match.status_change_message')} #{match.title}",
                             markup_with_buttons)
      else
        Helpers.send_message(message, I18n.t('match.error_changing_status'))
      end
    end
  end
end
