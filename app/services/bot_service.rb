# frozen_string_literal: true

# Main service that mannage telegram messages
class BotService
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def run
    begin
      case message
        # when callbackquery
      when Telegram::Bot::Types::CallbackQuery

        case message.data
        when 'info'
          return if Users::Authenticator.new(message).call

          Users::ShowInfo.new(message).call
        when 'register'
          Users::Register.new(message).call
        when 'create'
          return if Users::Authenticator.new(message).call

          Matches::FormCreator.new(message).call
        when %r{show_match/\d+}
          return if Users::Authenticator.new(message).call

          Matches::Show.new(message).call
        when 'show_matches'
          return if Users::Authenticator.new(message).call

          Matches::Index.new(message).call
        when %r{join_match/\d+}
          return if Users::Authenticator.new(message).call

          Matches::Join.new(message).call
        when %r{cant_come/\d+}
          return if Users::Authenticator.new(message).call

          Matches::CantCome.new(message).call
        when %r{add_participant/\d+}
          return if Users::Authenticator.new(message).call

          Matches::AddParticipant.new(message).call
        when %r{join_match_again/\d+}
          return if Users::Authenticator.new(message).call

          Matches::Rejoin.new(message).call
        else
          General::Info.new(message).call
        end

      # when messages
      when Telegram::Bot::Types::Message
        case message.text
        when '/info'
          return if Users::Authenticator.new(message).call

          Users::ShowInfo.new(message).call
        when '/register'
          Users::Register.new(message).call
        when '/create'
          return if Users::Authenticator.new(message).call

          Matches::FormCreator.new(message).call
        when '/show_matches'
          return if Users::Authenticator.new(message).call

          Matches::Index.new(message).call
        else
          user = User.find_by(telegram_id: message.from.id)
          if user && user.match_forms.pluck(:finished).include?(false)
            Matches::FormProcessor.new(message).call
          else
            General::Info.new(message).call
          end
        end
      end
    rescue => e
      Raven.capture_exception(e)
    end
  end
end
