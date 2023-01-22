# frozen_string_literal: true

# Class with user methods
class UserService
  include Helpers

  def self.show_info(client, message)
    markup = Helpers.markup_object(
      [Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.create'), callback_data: 'create'),
       Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('match.join'), callback_data: 'show_matches')]
    )

    Helpers.send_message(client, message, I18n.t('general.join_message'), markup)
  end

  def self.user_name(user)
    user&.username ? "@#{user&.username}" : ''
  end
end
