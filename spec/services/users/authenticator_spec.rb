# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Authenticator do
  let(:message) do
    MessageHelpers::Message.new(1_111_111, 'username', 'first_name', 'last_name')
  end

  subject { Users::Authenticator.new(message) }

  before do
    allow(Helpers).to receive(:send_message).and_return('message send')
  end

  context 'when user does not exist' do
    it 'should show message' do
      expect(subject.call).to eq true
    end
  end

  context 'when user exists' do
    context 'when user banned' do
      before { create(:user, telegram_id: 1_111_111, banned: true) }
      it { expect(subject.call).to eq true }
    end

    context 'when user not banned' do
      before { create(:user, telegram_id: 1_111_111) }
      it { expect(subject.call).to eq false }
    end
  end
end
