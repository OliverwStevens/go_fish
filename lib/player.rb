require_relative 'playing_card'
class Player
  attr_reader :name
  attr_accessor :hand

  def initialize(name = 'Random Player')
    @hand = []
    @name = name
  end

  def add_card(card)
    hand.push(card)
  end

  def card_count
    hand.count
  end

  def has_card_of_rank?(rank)
    hand.any? { |card| card.rank == rank }
  end

  def remove_cards(rank)
    matched_cards = []
    hand.each do |card|
      matched_cards << card if card.rank == rank
    end
    self.hand -= matched_cards
    matched_cards
  end

  def add_cards(cards)
    self.hand += cards
  end

  def find_matches
    # PlayingCard::RANK.each do |rank|
    #   rank_array = []
    #   PlayingCard::SUIT.each do |suit|
    #     rank_array << PlayingCard.new(suit, rank)
    #   end

    #   p (hand.rank & rank_array.rank).any?
    # end
    h = {}
    hand.each do |card|
      h[card] = card.rank
    end
    g = h.group_by { |key, value| value }
    p g
  end
end
