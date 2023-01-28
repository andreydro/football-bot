# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::Info do
  let(:match) { create(:match) }
  let(:user) { create(:user) }

  subject { Matches::Info.new(match) }

  before do
    create_list(:participant, 3, match_id: match.id, user_id: user.id)
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
end
