# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantsUpdater do
  let(:user) { create(:user) }

  subject { ParticipantsUpdater.new }

  context 'number of players bigger then needed' do
    let(:match) { create(:match, number_of_players: 2) }
    let!(:participant) { create_list(:participant, 3, match_id: match.id, user_id: user.id) }

    it 'updates status from main_cast to replacement' do
      expect(subject.call(match).length).to eq 1
      expect(Participant.pluck(:aasm_state)).to eq %w[main_cast main_cast replacement]
    end
  end

  context 'number of players less then meeded' do
    let(:match) { create(:match, number_of_players: 4) }

    before do
      create_list(:participant, 2, match_id: match.id, user_id: user.id, aasm_state: 'main_cast')
      create_list(:participant, 2, match_id: match.id, user_id: user.id, aasm_state: 'replacement')
    end

    it 'updates status from replacement to main_cast' do
      expect(subject.call(match).length).to eq 2
      expect(Participant.pluck(:aasm_state).include?('main_cast')).to be true
      expect(Participant.pluck(:aasm_state).exclude?('replacement')).to be true
    end
  end
end
