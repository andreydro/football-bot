# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::CantCome do
  let(:user) { create(:user) }
  let(:participant) { create(:participant, match_id: match.id, user_id: user.id) }
  let(:message) do
    MessageHelpers::Message.new(user.telegram_id, 'username', 'first_name', 'last_name', participant.id.to_s)
  end

  subject { Matches::CantCome.new(message) }

  context 'participant can leave' do
    let(:match) { create(:match, start: Time.current - 4.hours) }

    before do
      allow(Helpers).to receive(:send_message).and_return('participant left')
    end

    it 'changes participant state to wont_come' do
      expect(subject.call).to eq 'participant left'
      expect(participant.reload.aasm_state).to eq 'wont_come'
    end
  end

  context 'participant can not leave' do
    let(:match) { create(:match, start: Time.current + 2.hours) }

    before do
      allow(Helpers).to receive(:send_message).and_return('participant cant leave')
    end

    it 'should not leave participant' do
      expect(subject.call).to eq 'participant cant leave'
      expect(participant.reload.aasm_state).to eq 'main_cast'
    end
  end
end
