# frozen_string_literal: true

module Matches
  class FormProcessor < Base
    def call
      if form.question_one_answered == false
        process_question_one
      elsif form.question_two_answered == false
        process_question_two
      elsif form.question_three_answered == false
        process_question_three
      elsif form.question_four_answered == false
        process_question_four
      elsif form.question_five_answered == false
        process_question_five
      elsif form.question_six_answered == false
        process_question_six
      elsif form.question_seven_answered == false
        process_question_seven
      end
    end

    private

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    def form
      @form ||= user.match_forms.find_by(finished: false)
    end

    def process_question_one
      form.update(question_one_answered: true, question_one_answer: message.text)
      Helpers.send_message(message, I18n.t('chat.question_two'))
    end

    def process_question_two
      # Date validation
      if (message.text =~ /(\d{2}.\d{2}.\d{4})/).present?
        form.update(question_two_answered: true, question_two_answer: message.text)
        Helpers.send_message(message, I18n.t('chat.question_three'))
      else
        Helpers.send_message(message, I18n.t('chat.wrong_date_format'))
      end
    end

    def process_question_three
      # Time validation
      if (message.text =~ /(\d{2}:\d{2})/).present?
        form.update(question_three_answered: true, question_three_answer: message.text)
        Helpers.send_message(message, I18n.t('chat.question_four'))
      else
        Helpers.send_message(message, I18n.t('chat.wrong_time_format'))
      end
    end

    def process_question_four
      form.update(question_four_answered: true, question_four_answer: message.text)
      Helpers.send_message(message, I18n.t('chat.queston_five'))
    end

    def process_question_five
      form.update(question_five_answered: true, question_five_answer: message.text)
      Helpers.send_message(message, I18n.t('chat.question_six'))
    end

    def process_question_six
      form.update(question_six_answered: true, question_six_answer: message.text)
      Helpers.send_message(message, I18n.t('chat.question_seven'))
    end

    def process_question_seven
      form.update(question_seven_answered: true, question_seven_answer: message.text)
      match = create_match
      form.update(match_id: match.id, finished: true)

      markup = Helpers.markup_object([Helpers.show_match_button(match)])
      Helpers.send_message(message, I18n.t('match.created'), markup)
    end

    def create_match
      Match.create(match_object)
    end

    def match_object
      { title: form.question_one_answer,
        start: start_time,
        finish: finish_time,
        duration: form.question_four_answer.to_i,
        number_of_players: form.question_five_answer,
        user_id: user.id, have_ball_and_shirtfronts: form.question_six_answer,
        location: form.question_seven_answer, aasm_state: 'active' }
    end

    def start_time
      datetime_object(form)
    end

    def finish_time
      datetime_object(form) + form.question_four_answer.to_i.hours
    end

    def datetime_object(form)
      time_digits = form.question_three_answer.scan(/\d+/)
      hour = time_digits.first
      min = time_digits.last
      Time.zone.parse(form.question_two_answer).change(hour: hour, min: min)
    end
  end
end
