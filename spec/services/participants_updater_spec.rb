# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantsUpdater do
  let(:match) { create(:match, number_of_players: 2) }
  let(:user) { create(:user) }

  subject { ParticipantsUpdater.new }

  context 'number of players bigger then needed' do
    let!(:participant) { create_list(:participant, 3, match_id: match.id, user_id: user.id) }

    it 'returns nil' do
      expect(subject.call(match)).to eq nil
    end
  end

  it 'update_participants_list' do
    expect(subject.call(match)).to eq []
  end
end
