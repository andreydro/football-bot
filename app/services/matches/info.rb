# frozen_string_literal: true

module Matches
  class Info
    include Helpers

    attr_reader :match

    WEEK_DAYS = {
      monday: I18n.t('days.monday'),
      tuesday: I18n.t('days.tuesday'),
      wednesday: I18n.t('days.wednesday'),
      thursday: I18n.t('days.thursday'),
      friday: I18n.t('days.friday'),
      saturday: I18n.t('days.saturday'),
      sunday: I18n.t('days.sunday')
    }.freeze

    def initialize(match)
      @match = match
    end

    def call
      "#{title}" \
      "#{match_time}" \
      "#{meeting_time}" \
      "#{number_of_participants}" \
      "#{responsible_for_shirts}" \
      "#{location}" \
      "#{main_cast_participants}" \
      "#{replacement_participants}" \
      "#{participants_who_cant_come}"
    end

    private

    def title
      "#{match.title} #{match.start.strftime('%d.%m')} " \
      "(#{week_day(match.start.strftime('%A'))}) \n"
    end

    def match_time
      "#{I18n.t('match.time')} #{match.start.strftime('%H:%M')} " \
      "- #{match.finish.strftime('%H:%M')} \n"
    end

    def meeting_time
      "#{I18n.t('match.be_ready')} #{(match.start - 15.minutes).strftime('%H:%M')} \n"
    end

    def number_of_participants
      "#{I18n.t('match.number_of_participants')} #{match.number_of_players} \n"
    end

    def responsible_for_shirts
      "#{I18n.t('match.responsible_for_shirts')} #{match.have_ball_and_shirtfronts} \n"
    end

    def location
      "#{I18n.t('match.location')} #{match.location} \n" \
      "\n"
    end

    def participants_who_cant_come
      "#{I18n.t('match.participants_cant_come')} \n" \
      "#{filtered_participants(match.participants.wont_come)}" \
    end

    def replacement_participants
      "#{I18n.t('match.changes')} \n" \
      "#{filtered_participants(match.participants.replacement)}" \
      "\n"
    end

    def main_cast_participants
      "#{I18n.t('match.participants')} \n" \
      "#{filtered_participants(match.participants.main_cast)}" \
      "\n"
    end

    def filtered_participants(participants)
      participants.ordered.map.with_index do |participant, index|
        "#{index + 1}) #{participant.additional ? I18n.t('match.one_of') : ''}" \
        "#{participant.user&.first_name} #{participant.user&.last_name} " \
        "(#{participant.created_at.strftime('%d.%m %H:%M')}) " \
        "#{user_name(participant.user)} \n"
      end.join('')
    end

    def user_name(user)
      user&.username ? "@#{user&.username}" : ''
    end

    def week_day(day)
      WEEK_DAYS[day.downcase.to_sym]
    end
  end
end
