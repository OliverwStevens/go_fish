require_relative 'spec_helper'
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
    unshuffled_deck = deck.cards.dup
    deck.shuffle!
    expect(unshuffled_deck).to match_array deck.cards
    expect(unshuffled_deck).to_not eql deck.cards
  end
  it 'checks to see if it has cards' do
    expect(deck.has_cards?).to eql(true)
    deck.cards = []
    expect(deck.has_cards?).to eql(false)
  end
end
