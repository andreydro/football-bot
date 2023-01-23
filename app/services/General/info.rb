# frozen_string_literal: true

module General
  class Info < Base
    def call
      markup = Helpers.markup_object(
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.information'), callback_data: 'info'),
         Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.register'), callback_data: 'register')]
      )

      Helpers.send_message(message, I18n.t('general.information_message'), markup)
    end
  end
end
