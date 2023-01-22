# frozen_string_literal: true

module Matches
  class Show
    include Helpers

    attr_reader :message, :client

    def initialize(client, message)
      @client = client
      @message = message
    end

    def call
      markup = Helpers.markup_object([
        Helpers.join_or_transfer_button(match, user),
        Helpers.view_all_matches_button,
        Helpers.add_plus_one_button(match_id),
        Helpers.additional_participants_buttons(match_id, user.id)
      ].flatten)
      Helpers.send_message(client, message, text, markup)
    end

    private

    def match_id
      @match_id ||= message.data.match(/\d+/)[0]
    end

    def match
      @match ||= Match.find_by(id: match_id)
    end

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    def text
      Helpers.match_info_text(match)
    end
  end
end
