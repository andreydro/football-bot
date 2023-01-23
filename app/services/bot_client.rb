# frozen_string_literal: true

class BotClient
  def self.instance
    token = if Rails.env.production?
              Rails.application.credentials.production[:telegram][:token]
            else
              Rails.application.credentials.staging[:telegram][:token]
            end
    Telegram::Bot::Client.new(token)
  end
end
