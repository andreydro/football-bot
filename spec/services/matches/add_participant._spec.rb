# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::AddParticipant do
  let(:match) { create(:match) }
  let(:message) do
    MessageHelpers::Message.new(1_111_111, 'username', 'first_name', 'last_name', match.id.to_s)
  end

  subject { Matches::AddParticipant.new(message) }

  before do
    allow(Helpers).to receive(:send_message).and_return('participant saved')
    create(:user, telegram_id: 1_111_111)
  end

  context 'participant saved' do
    it 'should save participant' do
      expect(subject.call).to eq 'participant saved'
      expect(Participant.count).to eq 1
    end
  end
end
