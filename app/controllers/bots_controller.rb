# frozen_string_literal: true

class BotsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    begin
      message = update.message
      callback_query = update.callback_query
      # Update attributes is inside update object (inline_query, chosen_inline_result, shipping_query, etc.)

      BotService.new(client, message || callback_query).run if message.present? || callback_query.present?
    rescue => e
      puts e
      Sentry.capture_message(e)
      head :ok
    end
  end

  private

  def client
    token = Rails.application.credentials.telegram[:token]
    Telegram::Bot::Client.new(token)
  end

  def update
    Telegram::Bot::Types::Update.new(bot_params)
  end

  def bot_params
    params.permit!
  end
end
