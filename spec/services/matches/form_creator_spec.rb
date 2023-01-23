# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::FormCreator do
  let(:message) do
    MessageHelpers::Message.new(1_111_111, 'username', 'first_name', 'last_name')
  end

  subject { Matches::FormCreator.new(message) }

  before do
    allow(Helpers).to receive(:send_message).and_return('form created')
  end

  context 'user does not exist' do
    it 'does not create form' do
      expect(subject.call).to eq nil
      expect(MatchForm.count).to eq 0
    end
  end

  context 'user exists' do
    before { create(:user, telegram_id: 1_111_111) }

    it 'creates form' do
      expect(subject.call).to eq 'form created'
      expect(MatchForm.count).to eq 1
    end
  end
end
