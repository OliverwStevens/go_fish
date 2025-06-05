require_relative '../lib/playing_card'

describe PlayingCard do
  it 'has a rank and suit' do
    card = PlayingCard.new('♥', '2')
    expect(card.rank).to eql('2')
    expect(card.suit).to eql('♥')
  end
end
