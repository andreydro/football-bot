# frozen_string_literal: true

class MatchService
  include Helpers

  def self.create_match_form(client, message)
    user = User.find_by(telegram_id: message.from.id)
    if user.present?
      user.match_forms.create
      Helpers.send_message(client, message, I18n.t('chat.start'))
    end
  end

  def self.answer_form_question(client, message)
    user = User.find_by(telegram_id: message.from.id)
    form = user.match_forms.find_by(finished: false)
    if form.question_one_answered == false
      form.update(question_one_answered: true, question_one_answer: message.text)
      Helpers.send_message(client, message, I18n.t('chat.question_two'))
    elsif form.question_two_answered == false
      form.update(question_two_answered: true, question_two_answer: message.text)
      Helpers.send_message(client, message, I18n.t('chat.question_three'))
    elsif form.question_three_answered == false
      form.update(question_three_answered: true, question_three_answer: message.text)
      Helpers.send_message(client, message, I18n.t('chat.question_four'))
    elsif form.question_four_answered == false
      form.update(question_four_answered: true, question_four_answer: message.text)
      Helpers.send_message(client, message, I18n.t('chat.question_five'))
    elsif form.question_five_answered == false
      form.update(question_five_answered: true, question_five_answer: message.text)
      Helpers.send_message(client, message, I18n.t('chat.question_six'))
    elsif form.question_six_answered == false
      form.update(question_six_answered: true, question_six_answer: message.text)
      match = Match.create(title: form.question_one_answer, day: form.question_two_answer,
                           time: form.question_three_answer, location: form.question_four_answer,
                           number_of_players: form.question_five_answer,
                           user_id: user.id, have_ball_and_shirtfronts: form.question_six_answer)
      form.update(match_id: match.id, finished: true)

      markup = Helpers.markup_object([Helpers.show_match_button(match)])
      Helpers.send_message(client, message, I18n.t('chat.created'), markup)
    end
  end

  def self.show_matches(client, message)
    matches_kb = Match.all.map { |match| Helpers.show_match_button(match) }
    markup = Helpers.markup_object(matches_kb)
    Helpers.send_message(client, message, I18n.t('match.list'), markup)
  end

  def self.show_match(client, message)
    match_id = message.data.match(/\d+/)[0]
    match = Match.find_by(id: match_id)
    text = Helpers.match_info_text(match)
    user = User.find_by(telegram_id: message.from.id)
    markup = Helpers.markup_object([
      Helpers.join_or_transfer_button(match, user),
      Helpers.view_all_matches_button,
      Helpers.add_plus_one_button(mathc_id),
      Helpers.additional_participants_buttons(match_id, user.id)
    ].flatten)
    Helpers.send_message(client, message, text, markup)
  end

  def self.join_match(client, message)
    match_id = message.data.match(/\d/)[0]
    user = User.find_by(telegram_id: message.from.id)
    match = Match.find_by(id: match_id)
    participant = Helpers.sparticipant_object(user, match)

    if participant.save
      text = Helpers.match_info_text(match)
      markup = Helpers.markup_object([Helpers.view_all_matches_button,
                                      Helpers.cant_come_button(participant)])

      Helpers.send_message(client, message, text, markup)
    else
      Helpers.send_message(client, message, I18n.t('match.error_joining_match'))
    end
  end

  def self.add_participant(client, message)
    match_id = message.data.match(/\d+/)[0]
    match = Match.find_by(id: match_id)
    user = User.find_by(telegram_id: message.from.id)

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

    if participant.go_to_wont_come!
      match = participant.match
      ParticipantsService.new.update_participants_list(match)
      markup = Helpers.markup_object([Helpers.show_match_button(match),
                                      Helpers.view_all_matches_button])
      Helpers.send_message(client, message, "#{I18n.t('match.status_change_message')} #{match.title}", markup)
    else
      Helpers.send_message(client, message, I18n.t('match.error_changing_status'))
    end
  end
end
