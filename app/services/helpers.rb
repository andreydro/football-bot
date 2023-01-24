# frozen_string_literal: true

# module with helper methods for other services
module Helpers
  def self.markup_object(array_of_objects)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: array_of_objects)
  end

  def self.send_message(message, text, markup = nil)
    if markup.present?
      BotClient.instance.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
    else
      BotClient.instance.api.send_message(chat_id: message.from.id, text: text)
    end
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
end
