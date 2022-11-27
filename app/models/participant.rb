# frozen_string_literal: true

class Participant < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :match

  aasm do
    state :main_cast, initial: true
    state :replacement, before_enter: proc {
      send_natification("Вы ці ваш +1 дададзены ў склад запасных на матч #{match.title}")
    }
    state :wont_come

    event :go_to_replacement do
      transitions from: :main_cast, to: :replacement
    end

    event :go_to_main_cast do
      transitions from: :replacement, to: :main_cast, after: proc {
        send_natification("Вы ці ваш +1 перанесены ў асноўны склад на матч #{match.title}")
      }
    end

    event :go_to_wont_come do
      transitions from: %i[main_cast replacement], to: :wont_come
    end

    event :come_back_to_main_cast do
      transitions from: :wont_come, to: :main_cast, after: proc {
        send_natification("Вы вярнуліся ў асноўны склад гульцоў на матч #{match.title}")
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
