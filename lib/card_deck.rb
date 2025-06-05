require_relative 'playing_card'
class CardDeck
  attr_accessor :cards

  def initialize
    @cards = PlayingCard::SUIT.flat_map do |suit|
      PlayingCard::RANK.map do |rank|
        PlayingCard.new(suit, rank)
      end
    end
  end

  def deal
    cards.pop
  end

  def card_count
    cards.count
  end

  def shuffle!
    cards.shuffle!
  end
end
