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

  def self.validate_registration(client, message)
    if User.find_by(telegram_id: message.from.id).blank?
      button = Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t('general.register'),
                                                              callback_data: 'register')
      markup = Helpers.markup_object([button])
      Helpers.send_message(client, message, I18n.t('general.please_register'), markup)
      true
    end
  end

  def self.register_user(client, message)
    user = message.from
    if User.find_by(telegram_id: user.id).present?
      text = "#{I18n.t('user.self')} #{message.from.first_name} #{message.from.last_name} " \
      "#{I18n.t('user.already_exists')}"
    else
      User.create!(telegram_id: user.id, username: user.username, first_name: user.first_name,
                   last_name: user.last_name)
      text = "#{I18n.t('user.self')} #{message.from.first_name} #{message.from.last_name} #{I18n.t('user.created')}"
    end

    Helpers.send_message(client, message, text)
  end
end
