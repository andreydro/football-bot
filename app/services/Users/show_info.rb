# frozen_string_literal: true

module Users
  class ShowInfo
    include Helpers

    attr_reader :message, :client

    def initialize(client, message)
      @client = client
      @message = message
    end

    def call
      markup = Helpers.markup_object(
        [Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.create'), callback_data: 'create'),
         Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.join'), callback_data: 'show_matches')]
      )

      Helpers.send_message(client, message, I18n.t('general.join_message'), markup)
    end
  end
end
