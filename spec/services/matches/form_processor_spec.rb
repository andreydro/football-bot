# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::FormProcessor do
  let(:user) { create(:user) }
  let(:message) do
    MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name')
  end

  subject { Matches::FormProcessor.new(message) }

  before do
    allow(Helpers).to receive(:send_message).and_return('form processed')
  end

  context 'question one' do
    let!(:match_form) { create(:match_form, user_id: user.id) }
    let(:message) do
      MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', 'Ursus')
    end

    it 'process question one' do
      expect(subject.call).to eq 'form processed'
      expect(match_form.reload.question_one_answered).to eq true
      expect(match_form.reload.question_one_answer).to eq 'Ursus'
    end
  end

  context 'question two' do
    context 'correct date' do
      let!(:match_form) { create(:match_form, user_id: user.id, question_one_answered: true) }
      let(:message) do
        MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', '25.02.2012')
      end

      it 'process question two' do
        expect(subject.call).to eq 'form processed'
        expect(match_form.reload.question_two_answered).to eq true
        expect(match_form.reload.question_two_answer).to eq '25.02.2012'
      end
    end

    context 'incorrect date' do
      let!(:match_form) { create(:match_form, user_id: user.id, question_one_answered: true) }
      let(:message) do
        MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', '25.02')
      end

      it 'does not process question two' do
        expect(subject.call).to eq 'form processed'
        expect(match_form.reload.question_two_answered).to eq false
        expect(match_form.reload.question_two_answer).to eq ''
      end
    end
  end

  context 'question three' do
    context 'correct time' do
      let!(:match_form) do
        create(:match_form, user_id: user.id, question_one_answered: true, question_two_answered: true)
      end
      let(:message) do
        MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', '16:00')
      end

      it 'process question three' do
        expect(subject.call).to eq 'form processed'
        expect(match_form.reload.question_three_answered).to eq true
        expect(match_form.reload.question_three_answer).to eq '16:00'
      end
    end

    context 'incorrect time' do
      let!(:match_form) do
        create(:match_form, user_id: user.id, question_one_answered: true, question_two_answered: true)
      end
      let(:message) do
        MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', '16')
      end

      it 'does not process question three' do
        expect(subject.call).to eq 'form processed'
        expect(match_form.reload.question_three_answered).to eq false
        expect(match_form.reload.question_three_answer).to eq ''
      end
    end
  end

  context 'question four' do
    let!(:match_form) do
      create(:match_form, user_id: user.id, question_one_answered: true, question_two_answered: true,
                          question_three_answered: true)
    end
    let(:message) do
      MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', '2')
    end

    it 'process question four' do
      expect(subject.call).to eq 'form processed'
      expect(match_form.reload.question_four_answered).to eq true
      expect(match_form.reload.question_four_answer).to eq '2'
    end
  end

  context 'question five' do
    let!(:match_form) do
      create(:match_form, user_id: user.id, question_one_answered: true, question_two_answered: true,
                          question_three_answered: true, question_four_answered: true)
    end
    let(:message) do
      MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', '14')
    end

    it 'process question five' do
      expect(subject.call).to eq 'form processed'
      expect(match_form.reload.question_five_answered).to eq true
      expect(match_form.reload.question_five_answer).to eq '14'
    end
  end

  context 'question six' do
    let!(:match_form) do
      create(:match_form, user_id: user.id, question_one_answered: true, question_two_answered: true,
                          question_three_answered: true, question_four_answered: true,
                          question_five_answered: true)
    end
    let(:message) do
      MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', 'Player')
    end

    it 'process question six' do
      expect(subject.call).to eq 'form processed'
      expect(match_form.reload.question_six_answered).to eq true
      expect(match_form.reload.question_six_answer).to eq 'Player'
    end
  end

  context 'question seven and match creation' do
    let!(:match_form) do
      create(:match_form, user_id: user.id, question_one_answered: true, question_one_answer: 'Ursus',
                          question_two_answered: true, question_two_answer: '25.02.2012',
                          question_three_answered: true, question_three_answer: '16:00',
                          question_four_answered: true, question_four_answer: '2',
                          question_five_answered: true, question_five_answer: '14',
                          question_six_answered: true, question_six_answer: 'Player')
    end
    let(:message) do
      MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', 'http://googlemaps.com')
    end

    before do
      subject.call
    end

    it 'process question six' do
      expect(match_form.reload.question_seven_answered).to eq true
      expect(match_form.reload.question_seven_answer).to eq 'http://googlemaps.com'
    end

    it 'creates match' do
      expect(match_form.reload.finished).to eq true
      expect(match_form.reload.match.present?).to eq true
    end

    it 'creates match with correct attributes' do
      match = match_form.reload.match
      expect(match.title).to eq 'Ursus'
      expect(match.duration).to eq 2
      expect(match.have_ball_and_shirtfronts).to eq 'Player'
      expect(match.number_of_players).to eq 14
      expect(match.start).to eq Time.zone.parse('25.02.2012').change(hour: '16', min: '00')
      expect(match.finish).to eq Time.zone.parse('25.02.2012').change(hour: '18', min: '00')
      expect(match.location).to eq 'http://googlemaps.com'
      expect(match.aasm_state).to eq 'active'
      expect(match.user_id).to eq user.id
    end
  end
end
