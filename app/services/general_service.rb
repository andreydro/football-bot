# frozen_string_literal: true

# Class with general methods
class GeneralService
  include Helpers

  def self.general_info(client, message)
    markup = Helpers.markup_object(
      [Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.information'), callback_data: 'info'),
       Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.register'), callback_data: 'register')]
    )

    Helpers.send_message(client, message, I18n.t('general.information_message'), markup)
  end
end
