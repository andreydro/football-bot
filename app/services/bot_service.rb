# frozen_string_literal: true

# Main service that mannage telegram messages
class BotService
  attr_reader :client, :message

  def initialize(client, message)
    @client = client
    @message = message
  end

  def run
    begin
      case message
        # when callbackquery
      when Telegram::Bot::Types::CallbackQuery

        case message.data
        when 'info'
          return if UserService.validate_registration(client, message)

          UserService.show_info(client, message)
        when 'register'
          UserService.register_user(client, message)
        when 'create'
          return if UserService.validate_registration(client, message)

          MatchService.create_match_form(client, message)
        when %r{show_match/\d+}
          return if UserService.validate_registration(client, message)

          MatchService.show_match(client, message)
        when 'show_matches'
          return if UserService.validate_registration(client, message)

          MatchService.show_matches(client, message)
        when %r{join_match/\d+}
          return if UserService.validate_registration(client, message)

          MatchService.join_match(client, message)
        when %r{cant_come/\d+}
          return if UserService.validate_registration(client, message)

          MatchService.cant_come(client, message)
        when %r{add_participant/\d+}
          return if UserService.validate_registration(client, message)

          MatchService.add_participant(client, message)
        when %r{join_match_again/\d+}
          return if UserService.validate_registration(client, message)

          MatchService.join_match_again(client, message)
        else
          GeneralService.general_info(client, message)
        end

      # when messages
      when Telegram::Bot::Types::Message
        case message.text
        when '/info'
          return if UserService.validate_registration(client, message)

          UserService.show_info(client, message)
        when '/register'
          UserService.register_user(client, message)
        when '/create'
          return if UserService.validate_registration(client, message)

          MatchService.create_match_form(client, message)
        when '/show_matches'
          return if UserService.validate_registration(client, message)

          MatchService.show_matches(client, message)
        else
          user = User.find_by(telegram_id: message.from.id)
          if user && user.match_forms.pluck(:finished).include?(false)
            MatchService.answer_form_question(client, message)
          else
            GeneralService.general_info(client, message)
          end
        end
      end
    rescue => e
      Raven.capture_exception(e)
    end
  end
end
