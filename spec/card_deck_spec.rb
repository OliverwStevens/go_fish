require_relative '../lib/card_deck'
describe CardDeck do
  it 'has 52 cards' do
    deck = CardDeck.new
    expect(deck.cards.count).to eql(52)
  end
end
