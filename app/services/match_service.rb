# frozen_string_literal: true

class MatchService
  include Helpers

  def self.cant_come(client, message)
    participant_id = message.data.match(/\d+/)[0]
    participant = Participant.find_by(id: participant_id)
    match ||= participant.match
    leaving_times_is_over = Time.current.between?(match.start - 3.hours, match.start)

    if leaving_times_is_over
      Helpers.send_message(client, message, I18n.t('match.cant_leave_match_before_start'))
    else
      if participant.go_to_wont_come!
        ParticipantsUpdater.new.call(match)
        markup = Helpers.markup_object([Helpers.show_match_button(match),
                                        Helpers.view_all_matches_button])
        Helpers.send_message(client, message, "#{I18n.t('match.status_change_message')} #{match.title}", markup)
      else
        Helpers.send_message(client, message, I18n.t('match.error_changing_status'))
      end
    end
  end
end
