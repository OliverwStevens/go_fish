require_relative 'spec_helper'
require_relative '../lib/playing_card'

describe PlayingCard do
  it 'has a rank and suit' do
    card = PlayingCard.new('♥', '2')
    expect(card.rank).to eql('2')
    expect(card.suit).to eql('♥')
  end

  it 'has a value' do
    card = PlayingCard.new('♥', '2')
    expect(card.value).to eql(0)
  end
end
