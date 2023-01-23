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

          Users::ShowInfo.new(client, message).call
        when 'register'
          Users::Register.new(client, message).call
        when 'create'
          return if Users::Authenticator.new(client, message).call

          Matches::FormCreator.new(client, message).call
        when %r{show_match/\d+}
          return if Users::Authenticator.new(client, message).call

          Matches::Show.new(client, message).call
        when 'show_matches'
          return if Users::Authenticator.new(client, message).call

          Matches::Index.new(client, message).call
        when %r{join_match/\d+}
          return if Users::Authenticator.new(client, message).call

          Matches::Join.new(client, message).call
        when %r{cant_come/\d+}
          return if Users::Authenticator.new(client, message).call

          MatchService.cant_come(client, message)
        when %r{add_participant/\d+}
          return if Users::Authenticator.new(client, message).call

          Matches::AddParticipant.new(client, message).call
        when %r{join_match_again/\d+}
          return if Users::Authenticator.new(client, message).call

          Matches::Rejoin.new(client, message).call
        else
          General::Info.new(client, message).call
        end

      # when messages
      when Telegram::Bot::Types::Message
        case message.text
        when '/info'
          return if Users::Authenticator.new(client, message).call

          Users::ShowInfo.new(client, message).call
        when '/register'
          Users::Register.new(client, message).call
        when '/create'
          return if Users::Authenticator.new(client, message).call

          Matches::FormCreator.new(client, message).call
        when '/show_matches'
          return if Users::Authenticator.new(client, message).call

          Matches::Index.new(client, message).call
        else
          user = User.find_by(telegram_id: message.from.id)
          if user && user.match_forms.pluck(:finished).include?(false)
            Matches::FormProcessor.new(client, message).call
          else
            General::Info.new(client, message).call
          end
        end
      end
    rescue => e
      Raven.capture_exception(e)
    end
  end
end
