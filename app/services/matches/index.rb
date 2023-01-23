# frozen_string_literal: true

module Matches
  class Index < Base
    def call
      matches_kb = Match.active.map { |match| Helpers.show_match_button(match) }
      markup = Helpers.markup_object(matches_kb)
      Helpers.send_message(message, I18n.t('match.list'), markup)
    end
  end
end
