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
          return if Users::Authenticator.new(client, message).call

          UserService.show_info(client, message)
        when 'register'
          Users::Register.new(client, message).call
        when 'create'
          return if Users::Authenticator.new(client, message).call

          MatchService.create_match_form(client, message)
        when %r{show_match/\d+}
          return if Users::Authenticator.new(client, message).call

          MatchService.show_match(client, message)
        when 'show_matches'
          return if Users::Authenticator.new(client, message).call

          MatchService.show_matches(client, message)
        when %r{join_match/\d+}
          return if Users::Authenticator.new(client, message).call

          MatchService.join_match(client, message)
        when %r{cant_come/\d+}
          return if Users::Authenticator.new(client, message).call

          MatchService.cant_come(client, message)
        when %r{add_participant/\d+}
          return if Users::Authenticator.new(client, message).call

          MatchService.add_participant(client, message)
        when %r{join_match_again/\d+}
          return if Users::Authenticator.new(client, message).call

          MatchService.join_match_again(client, message)
        else
          GeneralService.general_info(client, message)
        end

      # when messages
      when Telegram::Bot::Types::Message
        case message.text
        when '/info'
          return if Users::Authenticator.new(client, message).call

          UserService.show_info(client, message)
        when '/register'
          Users::Register.new(client, message).call
        when '/create'
          return if Users::Authenticator.new(client, message).call

          MatchService.create_match_form(client, message)
        when '/show_matches'
          return if Users::Authenticator.new(client, message).call

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
