# frozen_string_literal: true

module Users
  class Register
    include Helpers

    attr_reader :message, :client

    def initialize(client, message)
      @client = client
      @message = message
    end

    def call
      if User.find_by(telegram_id: user.id).present?
        user_exist_message
      else
        user_created_message
      end
    end

    private

    def user_exist_message
      text = "#{I18n.t('user.self')} #{message.from&.first_name} #{message.from&.last_name} " \
        "#{I18n.t('user.already_exists')}"
      Helpers.send_message(client, message, text)
    end

    def user_created_message
      text = if user_created?
               "#{I18n.t('user.self')} #{user&.first_name} #{user&.last_name} #{I18n.t('user.created')}"
             else
               "#{I18n.t('user.self')} #{I18n.t('user.not_created')}. #{I18n.t('general.error')}"
             end
      Helpers.send_message(client, message, text)
    end

    def user
      @user ||= message.from
    end

    def user_created?
      User.new(telegram_id: user.id, username: user&.username, first_name: user&.first_name,
               last_name: user&.last_name).save
    end
  end
end
