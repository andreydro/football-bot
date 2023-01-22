# frozen_string_literal: true

module General
  class Info
    include Helpers

    attr_reader :message, :client

    def initialize(client, message)
      @client = client
      @message = message
    end

    def call
      markup = Helpers.markup_object(
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.information'), callback_data: 'info'),
         Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.register'), callback_data: 'register')]
      )

      Helpers.send_message(client, message, I18n.t('general.information_message'), markup)
    end
  end
end
