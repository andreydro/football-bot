# frozen_string_literal: true

class MatchService
  include Helpers

  def self.join_match_again(client, message)
    participant_id = message.data.match(/\d+/)[0]
    participant = Participant.find_by(id: participant_id)
    match ||= participant.match

    if match.participants.main_cast.count >= match.number_of_players
      if participant.update(aasm_state: 'replacement')
        MatchLog.new.create_log("Participant #{participant.id} came back from wont_come to replacement", match.id)
        user ||= User.find_by(telegram_id: message.from.id)
        text = Helpers.match_info_text(match)
        markup = Helpers.markup_object([Helpers.join_or_transfer_button(match, user),
                                        Helpers.view_all_matches_button,
                                        Helpers.add_plus_one_button(match.id),
                                        Helpers.additional_participants_buttons(match.id, user.id)])
        Helpers.send_message(client, message, text, markup)
      else
        Helpers.send_message(client, message, I18n.t('match.error_changing_status'))
      end
    else
      if participant.update(aasm_state: 'main_cast')
        MatchLog.new.create_log("Participant #{participant.id} came back from wont_come to main_cast", match.id)
        user = User.find_by(telegram_id: message.from.id)
        text = Helpers.match_info_text(match)
        markup = Helpers.markup_object([Helpers.join_or_transfer_button(match, user),
                                        Helpers.view_all_matches_button,
                                        Helpers.add_plus_one_button(match.id),
                                        Helpers.additional_participants_buttons(match.id, user.id)])
        Helpers.send_message(client, message, text, markup)
      else
        Helpers.send_message(client, message, I18n.t('match.error_changing_status'))
      end
    end
  end

  def self.add_participant(client, message)
    match_id = message.data.match(/\d+/)[0]
    match ||= Match.find_by(id: match_id)
    user ||= User.find_by(telegram_id: message.from.id)

    participant = Helpers.participant_object(user, match, true)
    if participant.save
      text = Helpers.match_info_text(match)
      markup = Helpers.markup_object([Helpers.join_or_transfer_button(match, user),
                                      Helpers.view_all_matches_button,
                                      Helpers.add_plus_one_button(match_id),
                                      Helpers.additional_participants_buttons(match_id, user.id)])

      Helpers.send_message(client, message, text, markup)
    else
      Helpers.send_message(client, message, I18n.t('match.error_joining_match'))
    end
  end

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
