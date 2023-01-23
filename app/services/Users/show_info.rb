# frozen_string_literal: true

module Users
  class ShowInfo < Base
    def call
      markup = Helpers.markup_object(
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.create'), callback_data: 'create'),
         Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.join'), callback_data: 'show_matches')]
      )

      Helpers.send_message(message, I18n.t('general.join_message'), markup)
    end
  end
end
