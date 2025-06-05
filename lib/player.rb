class Player
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
end
