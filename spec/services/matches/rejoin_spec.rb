# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::Rejoin do
  let(:match) { create(:match, number_of_players: 1) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, match_id: match.id, user_id: user.id, aasm_state: 'wont_come') }
  let(:message) do
    MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', participant.id.to_s)
  end

  subject { Matches::Rejoin.new(message) }

  before do
    allow(Helpers).to receive(:send_message).and_return('form created')
  end

  context 'when main cast is full' do
    before do
      create_list(:participant, 1, match_id: match.id, user_id: user.id, aasm_state: 'main_cast')
    end

    it 'should move participant to replacement' do
      subject.call
      expect(participant.reload.aasm_state).to eq('replacement')
    end
  end

  context 'when main cast is not full' do
    it 'should move participnat to main cast' do
      subject.call
      expect(participant.reload.aasm_state).to eq('main_cast')
    end
  end
end
