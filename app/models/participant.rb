# frozen_string_literal: true

class Participant < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :match

  scope :ordered, -> { order(:id) }

  aasm do
    state :main_cast, initial: true, before_enter: proc {
      MatchLog.new.create_log("Participant #{id} joined the match", match.id)
    }
    state :replacement, before_enter: proc {
      send_natification("Вы ці ваш +1 дададзены ў склад запасных на матч #{match.title}")
      MatchLog.new.create_log("Participant #{id} went to replacement", match.id)
    }
    state :wont_come

    event :go_to_replacement do
      transitions from: :main_cast, to: :replacement
    end

    event :go_to_main_cast do
      transitions from: :replacement, to: :main_cast, after: proc {
        send_natification("Вы ці ваш +1 перанесены ў асноўны склад на матч #{match.title}")
        MatchLog.new.create_log("Participant #{id} went to main_cast from replacement", match.id)
      }
    end

    event :go_to_wont_come do
      transitions from: %i[main_cast replacement], to: :wont_come, after: proc {
        MatchLog.new.create_log("Participant #{id} went to wont_come from main_cast or replacement", match.id)
      }
    end

    event :come_back_to_main_cast do
      transitions from: :wont_come, to: :main_cast, after: proc {
        send_natification("Вы вярнуліся ў асноўны склад гульцоў на матч #{match.title}")
        MatchLog.new.create_log("Participant #{id} came back from wont_come to main_cast", match.id)
      }
    end
  end

  def send_natification(text)
    client.api.send_message(chat_id: user.telegram_id, text: text)
  end

  def client
    token = Rails.application.credentials.telegram[:token]
    Telegram::Bot::Client.new(token)
  end
end
