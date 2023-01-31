# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::Join do # rubocop:disable Metrics/BlockLength
  let(:match) { create(:match, number_of_players: 2) }
  let(:first_user) { create(:user, telegram_id: 1_111_111) }

  before do
    allow(Helpers).to receive(:send_message).and_return('joined')
  end

  context 'when new participant joining the match' do
    let(:second_user) { create(:user, telegram_id: 2_222_222) }
    let!(:participant) { create(:participant, match_id: match.id, user_id: first_user.id) }
    let(:message) do
      MessageHelpers::Message.new(second_user.telegram_id, 'username', 'first_name', 'last_name', match.id.to_s)
    end

    it 'should join new participant' do
      expect(Matches::Join.new(message).call).to eq 'joined'
      expect(match.participants.reload.count).to eq 2
    end
  end

  context 'when participant already joined the match' do
    let!(:participant) { create(:participant, match_id: match.id, user_id: first_user.id) }
    let(:message) do
      MessageHelpers::Message.new(first_user.telegram_id, 'username', 'first_name', 'last_name', match.id.to_s)
    end

    it 'should not join participant again' do
      Matches::Join.new(message).call
      expect(match.participants.count).to eq 1
    end
  end
end
