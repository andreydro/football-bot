# frozen_string_literal: true

# module with helper methods for other services
module Helpers
  def self.markup_object(array_of_objects)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: array_of_objects)
  end

  def self.send_message(client, message, text, markup = nil)
    if markup.present?
      client.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
    else
      client.api.send_message(chat_id: message.from.id, text: text)
    end
  end

  def self.participants(participants)
    participants.sorted.map.with_index do |participant, index|
      "#{index + 1}) #{participant.additional ? I18n.t('match.one_of') : ''}" \
      "#{participant.user&.first_name} #{participant.user&.last_name} \n"
    end.join('')
  end

  def self.participant_object(user, match, additional = false)
    if match.participants.main_cast.count >= match.number_of_players
      if additional
        Participant.new(user_id: user.id, match_id: match.id, aasm_state: :replacement, additional: true)
      else
        Participant.new(user_id: user.id, match_id: match.id, aasm_state: :replacement)
      end
    else
      if additional
        Participant.new(user_id: user.id, match_id: match.id, additional: true)
      else
        Participant.new(user_id: user.id, match_id: match.id)
      end
    end
  end

  def self.match_info_text(match)
    "#{match.title} #{match.start.strftime('%d')}.#{match.start.strftime('%m')} " \
      "(#{Helpers.week_day(match.start.strftime('%A'))}) \n" \
      "#{I18n.t('match.time')} #{match.start.strftime('%H')}:#{match.start.strftime('%M')} " \
      "- #{match.finish.strftime('%H')}:#{match.finish.strftime('%M')} \n" \
      "#{I18n.t('match.be_ready')} #{(match.start - 15.minutes).strftime('%H')}:" \
      "#{(match.start - 15.minutes).strftime('%M')} \n" \
      "#{I18n.t('match.number_of_participants')} #{match.number_of_players} \n" \
      "#{I18n.t('match.responsible_for_shirts')} #{match.have_ball_and_shirtfronts} \n" \
      "#{I18n.t('match.location')} #{match.location} \n" \
      "\n" \
      "#{I18n.t('match.participants')} \n" \
      "#{participants(match.participants.main_cast)}" \
      "\n" \
      "#{I18n.t('match.changes')} \n" \
      "#{participants(match.participants.replacement)}" \
      "\n" \
      "#{I18n.t('match.participants_cant_come')} \n" \
      "#{participants(match.participants.wont_come)}" \
  end

  def self.view_all_matches_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.view_all'), callback_data: 'show_matches')
  end

  def self.additional_participants_buttons(match_id, user_id)
    additional_participants = Participant.where(match: match_id, user_id: user_id, additional: true,
                                                aasm_state: %i[main_cast replacement])
    additional_participants.map do |add_part|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.plus_one_cant_cone'),
                                                     callback_data: "cant_come/#{add_part.id}")
    end
  end

  def self.add_plus_one_button(match_id)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.add_one'),
                                                   callback_data: "add_participant/#{match_id}")
  end

  def self.show_match_button(match)
    text = "#{I18n.t('match.self')}: #{match.title} #{match.start.strftime('%d')}.#{match.start.strftime('%m')}
    #{match.start.strftime('%H')}:#{match.start.strftime('%M')}"
    Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: "show_match/#{match.id}")
  end

  def self.cant_come_button(participant)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.cant_come'),
                                                   callback_data: "cant_come/#{participant.id}")
  end

  def self.join_match_button(match)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.join'), callback_data: "join_match/#{match.id}")
  end

  def self.change_status_to_main_cast(participant)
    Telegram::Bot::Types::InlineKeyboardButton.new(
      text: I18n.t('match.join_again'),
      callback_data: "join_match_again/#{participant.id}"
    )
  end

  def self.join_or_transfer_button(match, user)
    participant = match.participants.find_by(user_id: user.id, additional: false)
    if participant && match.participants.pluck(:id).include?(participant.id)
      if participant.wont_come?
        Helpers.change_status_to_main_cast(participant)
      else
        Helpers.cant_come_button(participant)
      end
    else
      Helpers.join_match_button(match)
    end
  end

  def self.datetime_object(form)
    time_digits = form.question_three_answer.scan(/\d+/)
    hour = time_digits.first
    min = time_digits.last
    Time.parse(form.question_two_answer).change(hour: hour, min: min)
  end

  def self.week_day(day)
    case day
    when 'Monday'
      I18n.t('days.monday')
    when 'Tuesday'
      I18n.t('days.tuesday')
    when 'Wednesday'
      I18n.t('days.wednesday')
    when 'Thursday'
      I18n.t('days.thursday')
    when 'Friday'
      I18n.t('days.friday')
    when 'Saturday'
      I18n.t('days.saturday')
    when 'Sunday'
      I18n.t('days.sunday')
    end
  end
end
