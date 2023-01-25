# frozen_string_literal: true

module Matches
  class FormProcessor < Base
    QUESTIONS = %i[question_one_answered question_two_answered question_three_answered question_four_answered
                   question_five_answered question_six_answered question_seven_answered].freeze

    def call
      case current_question_for_procession
      when :question_one_answered
        process_question_one
      when :question_two_answered
        process_question_two
      when :question_three_answered
        process_question_three
      when :question_four_answered
        process_question_four
      when :question_five_answered
        process_question_five
      when :question_six_answered
        process_question_six
      when :question_seven_answered
        process_question_seven
      end
    end

    # private

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    def form
      @form ||= user.match_forms.find_by(finished: false)
    end

    def current_question_for_procession
      QUESTIONS.detect { |question| form[question] == false }
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
