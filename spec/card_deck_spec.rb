require_relative '../lib/card_deck'
describe CardDeck do
  let(:deck) { CardDeck.new }
  it 'has 52 cards' do
    expect(deck.card_count).to eql(52)
  end

  it 'deals a card' do
    deck.deal
    expect(deck.card_count).to eql(51)
  end

  it 'shuffles the deck' do
    deck.shuffle!
    expect(deck.cards).to_not contain_exactly(deck.cards)
  end
  it 'checks to see if it has cards' do
    expect(deck.has_cards?).to eql(true)
    deck.cards = []
    expect(deck.has_cards?).to eql(false)
  end
end
