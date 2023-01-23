# frozen_string_literal: true

module Users
  class Authenticator < Base
    def call
      return true if user_banned?

      registration_needed?
    end

    private

    def user_banned?
      if User.find_by(telegram_id: message.from.id).present? && User.find_by(telegram_id: message.from.id).banned
        Helpers.send_message(message, I18n.t('user.banned'))
        true
      else
        false
      end
    end

    def registration_needed?
      if User.find_by(telegram_id: message.from.id).blank?
        button = Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.register'),
                                                                callback_data: 'register')
        markup = Helpers.markup_object([button])
        Helpers.send_message(message, I18n.t('general.please_register'), markup)
        true
      else
        false
      end
    end
  end
end
