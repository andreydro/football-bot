# frozen_string_literal: true

class UserService
  def self.show_info(client, message)
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Стварыць матч', callback_data: 'create'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Далучыцца да матчу', callback_data: 'show_matches')
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    client.api.send_message(chat_id: message.from.id,
                            text: 'У гэтым боце вы можаце стварыць або далучыцца да гульні',
                            reply_markup: markup)
  end

  def self.validate_registration(client, message)
    if User.find_by(telegram_id: message.from.id).blank?
      kb = [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зарэгістравацца', callback_data: 'register')]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      client.api.send_message(chat_id: message.chat.id, text: 'Калі ласка, зарэгіструйцеся перад выкарыстаннем бота', reply_markup: markup)
      true
    end
  end

  def self.register_user(client, message)
    user = message.from
    if User.find_by(telegram_id: user.id).present?
      client.api.send_message(chat_id: message.from.id, text: "Карыстальнік #{message.from.first_name} #{message.from.last_name} ужо існуе")
    else
      User.create!(telegram_id: user.id, username: user.username, first_name: user.first_name, last_name: user.last_name)
      client.api.send_message(chat_id: message.from.id, text: "Карыстальнік #{message.from.first_name} #{message.from.last_name} створаны")
    end
  end
end
