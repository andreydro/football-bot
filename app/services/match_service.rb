# frozen_string_literal: true

class MatchService
  VIEW_ALL_MATCHES_BUTTON = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Паглядзець усе матчы', callback_data: 'show_matches')

  def self.create_match_form(client, message)
    user = User.find_by(telegram_id: message.from.id)
    if user.present?
      user.match_forms.create
      client.api.send_message(chat_id: message.from.id, text: 'Вы запусцілі стварэнне чата. Каб скончыць вам трэба адказаць на 6 пытанняў. Пытанне 1) Назавіце месца гульні (Напрыклад: Урсус)')
    end
  end

  def self.answer_form_question(client, message)
    user = User.find_by(telegram_id: message.from.id)
    form = user.match_forms.find_by(finished: false)
    if form.question_one_answered == false
      form.update(question_one_answered: true, question_one_answer: message.text)
      client.api.send_message(chat_id: message.chat.id, text: 'Пытанне 2) У які дзень? (Напрыклад: Субота( 22.10))')
    elsif form.question_two_answered == false
      form.update(question_two_answered: true, question_two_answer: message.text)
      client.api.send_message(chat_id: message.chat.id, text: 'Пытанне 3) У які час? (напрыклад: 16.00 - 18.00)')
    elsif form.question_three_answered == false
      form.update(question_three_answered: true, question_three_answer: message.text)
      client.api.send_message(chat_id: message.chat.id, text: 'Пытанне 4) Дайце Google спасылку на лакацыю')
    elsif form.question_four_answered == false
      form.update(question_four_answered: true, question_four_answer: message.text)
      client.api.send_message(chat_id: message.chat.id, text: 'Пытанне 5) Укажыце колькасць гульцоў (Напрыклад: 14)')
    elsif form.question_five_answered == false
      form.update(question_five_answered: true, question_five_answer: message.text)
      client.api.send_message(chat_id: message.chat.id, text: 'Пытанне 6) Хто адказны за мяч і манішкі ?(Напрыклад Антось)')
    elsif form.question_six_answered == false
      form.update(question_six_answered: true, question_six_answer: message.text)
      match = Match.create(title: form.question_one_answer, day: form.question_two_answer, time: form.question_three_answer,
                           location: form.question_four_answer, number_of_players: form.question_five_answer,
                           user_id: user.id, have_ball_and_shirtfronts: form.question_six_answer)
      form.update(match_id: match.id, finished: true)

      kb = [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Матч: #{match.title} #{match.day} #{match.time}", callback_data: "show_match/#{match.id}")]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      client.api.send_message(chat_id: message.chat.id, text: 'Матч створаны', reply_markup: markup)
    end
  end

  def self.show_matches(client, message)
    matches_kb = Match.all.map do |match|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "Матч: #{match.title} #{match.day} #{match.time}", callback_data: "show_match/#{match.id}")
    end

    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: matches_kb)

    client.api.send_message(chat_id: message.from.id,
                            text: 'Спіс бягучых матчаў',
                            reply_markup: markup)
  end

  def self.show_match(client, message)
    match_id = message.data.match(/\d+/)[0]
    match = Match.find_by(id: match_id)
    text = match_info_text(match)
    user = User.find_by(telegram_id: message.from.id)
    kb = [
      join_or_transfer_button(match, user),
      VIEW_ALL_MATCHES_BUTTON,
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Дадаць +1', callback_data: "add_participant/#{match.id}"),
      additional_participants_buttons(match_id, user.id)
    ].flatten
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    client.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
  end

  def self.participant_object(user, match, additional = false)
    if match.participants.main_cast.count >= match.number_of_players
      if additional
        Participant.new(user_id: user.id, match_id: match.id, aasm_state: :replacement, additional: true)
      else
        Participant.new(user_id: user.id, match_id: match.id, aasm_state: :replacement)
      end
    else
      if additional
        Participant.new(user_id: user.id, match_id: match.id, additional: true)
      else
        Participant.new(user_id: user.id, match_id: match.id)
      end
    end
  end

  def self.join_match(client, message)
    match_id = message.data.match(/\d/)[0]
    user = User.find_by(telegram_id: message.from.id)
    match = Match.find_by(id: match_id)
    participant = participant_object(user, match)

    if participant.save
      text = match_info_text(match)

      kb = [VIEW_ALL_MATCHES_BUTTON,
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Не змагу прыйсці', callback_data: "cant_come/#{participant.id}")]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

      client.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
    else
      client.api.send_message(chat_id: message.from.id, text: 'адбылася памылка пры даданні да матчу')
    end
  end

  def self.add_participant(client, message)
    match_id = message.data.match(/\d+/)[0]
    match = Match.find_by(id: match_id)
    user = User.find_by(telegram_id: message.from.id)

    participant = participant_object(user, match, true)
    if participant.save
      text = match_info_text(match)

      kb = [join_or_transfer_button(match, user),
            VIEW_ALL_MATCHES_BUTTON,
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Дадаць +1', callback_data: "add_participant/#{match.id}"),
            additional_participants_buttons(match_id, user.id)]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

      client.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
    else
      client.api.send_message(chat_id: message.from.id, text: 'Адбылася памылка пры даданні да матчу')
    end
  end

  def self.cant_come(client, message)
    participant_id = message.data.match(/\d+/)[0]
    participant = Participant.find_by(id: participant_id)

    puts participant_id

    puts participant.aasm_state

    if participant.go_to_wont_come!
      match = participant.match
      # recalcultion of list main cast list
      ParticipantsService.new.update_participants_list(match)
      kb = [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Матч: #{match.title} #{match.day} #{match.time}", callback_data: "show_match/#{match.id}"),
            VIEW_ALL_MATCHES_BUTTON]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      client.api.send_message(chat_id: message.from.id, text: "Вы або ваш +1 перанесены ў спіс гульцоў якія не прыйдуць на #{match.title}", reply_markup: markup)
    else
      client.api.send_message(chat_id: message.from.id, text: 'Здарылася памылка пры пераносе гульца')
    end
  end

  def self.join_or_transfer_button(match, user)
    participant = match.participants.find_by(user_id: user.id, additional: false)
    if match.participants.pluck(:id).include?(participant.id)
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Не змагу прыйсці', callback_data: "cant_come/#{participant.id}")
    else
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Далучыцца да матчу', callback_data: "join_match/#{match.id}")
    end
  end

  def self.match_info_text(match)
    "#{match.title} #{match.day} #{match.time} \n" \
      "Колькасць гульцоў: #{match.number_of_players} \n" \
      "Адказны за мяч і манішкі: #{match.have_ball_and_shirtfronts} \n" \
      "\n" \
      "Гульцы: \n" \
      "#{participants(match.participants.main_cast)}" \
      "\n" \
      "Замены: \n" \
      "#{participants(match.participants.replacement)}" \
      "\n" \
      "Не змогуць прыйсці: \n" \
      "#{participants(match.participants.wont_come)}" \
  end

  def self.participants(participants)
    participants.map.with_index { |participant, index| "#{index + 1}) #{participant.additional ? '+1 ад' : ''} #{participant.user.first_name} #{participant.user.last_name} \n"  }.join("")
  end

  def self.additional_participants_buttons(match_id, user_id)
    additional_participants = Participant.where(match: match_id, user_id: user_id, additional: true, aasm_state: %i[main_cast replacement])
    puts additional_participants.pluck(:id)
    additional_participants.map do |add_part|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '+1 не зможа прыйсці', callback_data: "cant_come/#{add_part.id}")
    end
  end
end
