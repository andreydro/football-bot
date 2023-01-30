# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::Info do # rubocop:disable Metrics/BlockLength
  let(:match) { create(:match) }
  let(:user_for_main_cast) { create(:user, first_name: 'Maincast') }
  let(:user_for_replacement) { create(:user, first_name: 'Replacement') }
  let(:user_for_cant_come) { create(:user, first_name: 'CantCome') }

  subject { Matches::Info.new(match) }

  before do
    create(:participant, match_id: match.id, user_id: user_for_main_cast.id)
    create(:participant, match_id: match.id, user_id: user_for_replacement.id)
    create(:participant, match_id: match.id, user_id: user_for_cant_come.id)
  end

  it 'has title' do
    expect(subject.call.include?('Ursus')).to eq true
  end

  it 'has date' do
    expect(subject.call.include?(Time.current.strftime('%d.%m'))).to eq true
  end

  it 'has number of players' do
    expect(subject.call.include?('14')).to eq true
  end

  it 'has responsible for ball and shirtfronts' do
    expect(subject.call.include?('Player')).to eq true
  end

  it 'has location url' do
    expect(subject.call.include?('http://google.maps.com')).to eq true
  end

  it 'has main cast participant' do
    expect(subject.call.include?('Maincast')).to eq true
  end

  it 'has replacement participant' do
    expect(subject.call.include?('Replacement')).to eq true
  end

  it 'has cant come participant' do
    expect(subject.call.include?('CantCome')).to eq true
  end
end
