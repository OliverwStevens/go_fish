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
end
