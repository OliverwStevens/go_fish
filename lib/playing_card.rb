class PlayingCard
  SUIT = %w[♥ ♦ ♠ ♣].freeze
  RANK = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end
end
