require_relative 'playing_card'
class Player
  attr_reader :name
  attr_accessor :hand, :matches

  def initialize(name = 'Random Player')
    @hand = []
    @name = name
    @matches = {}
  end

  def add_card(card)
    hand.push(card)
  end

  def has_cards?
    hand.any?
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
    sorted_hash = get_sorted_hash
    processed = process_matching(sorted_hash)
    return 'No matches' unless processed.any?

    print_matching(processed)
  end

  def print_matching(printing)
    string = ''
    printing.each_with_index do |(key, value), index|
      # binding.irb
      string.concat("#{PlayingCard::RANK[key]}'s")
      string.concat(' and ') if index + 1 < printing.count
    end
    'You matched the '.concat(string)
  end

  # matches.max
  #
  private

  def get_sorted_hash
    hand_hash = {}
    hand.each do |card|
      hand_hash[card] = card.value
    end
    sorted_hash = hand_hash.group_by { |key, value| value }
  end

  def process_matching(sorted_hash, printing = {})
    sorted_hash.each do |key, value|
      next unless sorted_hash[key].count == 4

      matches[key] = value
      printing[key] = value
      remove_cards(PlayingCard::RANK[key])
    end
    printing
  end
end
