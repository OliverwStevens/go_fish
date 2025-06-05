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

  it 'shuffles the deck' do
    deck = CardDeck.new
    deck.shuffle!
    expect(deck.cards).to_not contain_exactly(deck.cards)
  end
end
