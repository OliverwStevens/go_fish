require_relative 'playing_card'
class CardDeck
  attr_reader :cards

  def initialize
    @cards = PlayingCard::SUIT.flat_map do |suit|
      PlayingCard::RANK.map do |rank|
        PlayingCard.new(suit, rank)
      end
    end
  end
end
