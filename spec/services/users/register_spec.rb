# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Register do
  let(:message) do
    MessageHelpers::Message.new(1_111_111, 'username', 'first_name', 'last_name')
  end

  subject { Users::Register.new(message) }

  before do
    allow(Helpers).to receive(:send_message).and_return('message send')
  end

  context 'user does not exist' do
    it 'creates user' do
      expect(subject.call).to eq 'message send'
      expect(User.first.username).to eq message.from.username
    end
  end

  context 'user exists' do
    before do
      create(:user, telegram_id: 1_111_111)
    end

    it ' does not create user' do
      expect(subject.call).to eq 'message send'
      expect(User.count).to eq 1
    end
  end
end
