require_relative '../lib/card_deck'
describe CardDeck do
  it 'has 52 cards' do
    deck = CardDeck.new
    expect(deck.card_count).to eql(52)
  end

  it 'deals a card' do
    deck = CardDeck.new
    deck.deal
    expect(deck.card_count).to eql(51)
  end
end
