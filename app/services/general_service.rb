# frozen_string_literal: true

class GeneralService
  def self.general_info(client, message)
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Інфармацыя', callback_data: 'info'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зарэгістравацца', callback_data: 'register')
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    client.api.send_message(chat_id: message.from.id,
                            text: 'Каб выкарыстаць гэты бот вам трэба зарэгістравацца. Калі вы ўжо зарэгістраваны, тады націсніце інфармацыя',
                            reply_markup: markup)
  end
end
