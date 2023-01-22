# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Register do
  context 'user does not exist' do
    let(:client) { nil }
    let(:message) do
      MessageHelpers::Message.new(1_111_111, 'username', 'first_name', 'last_name')
    end

    subject { Users::Register.new(client, message) }

    before do
      allow(Helpers).to receive(:send_message).and_return('message send')
    end

    it 'creates user' do
      expect(subject.call).to eq 'message send'
      expect(User.first.username).to eq message.from.username
    end
  end

  # context 'user exists' do
  # end
end
