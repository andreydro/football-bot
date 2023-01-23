# frozen_string_literal: true

module Matches
  class FormCreator < Base
    def call
      return if user.blank?

      user.match_forms.create
      Helpers.send_message(message, I18n.t('chat.start'))
    end

    private

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end
  end
end
