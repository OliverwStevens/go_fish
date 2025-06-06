require_relative 'card_deck'
require_relative 'player'
class Game
  attr_reader :deck
  attr_accessor :players

  def initialize(num_of_players = 2)
    @deck = CardDeck.new
    @players = Array.new(num_of_players) { |index| Player.new("Player #{index + 1}") }

    deck.shuffle!
  end

  def deal_cards
    if players.count < 4
      distrubute_cards(7)

    else
      distrubute_cards(5)
    end
  end

  def round(current_player, opponent, rank)
    if opponent.has_card_of_rank?(rank)
      cards = get_opponent_cards(current_player, opponent, rank)
      "You received #{cards.count} card(s) of rank #{cards.first.rank}"
    else
      current_player.add_card(deck.deal)
      "Go fish! You got a card of rank #{current_player.hand.last.rank}"
    end
  end

  def return_opponent(current_player, input_opponent)
    players.find do |p|
      p.name.downcase == input_opponent.downcase && input_opponent.downcase != current_player.name.downcase
    end
  end

  def return_rank(current_player, input_rank)
    rank = PlayingCard::RANK.find { |r| r.downcase == input_rank.downcase }
    # validates that the player has a card of that rank
    rank = [] unless current_player.has_card_of_rank?(rank)
    rank
  end

  def validate_input?(opponent, rank)
    !opponent.nil? && !rank.nil?
  end

  private

  def distrubute_cards(cards_to_deal)
    cards_to_deal.times do
      players.each do |player|
        player.add_card(deck.deal)
      end
    end
  end

  def get_opponent_cards(current_player, opponent, rank)
    cards = opponent.remove_cards(rank)
    current_player.add_cards(cards)
    cards
  end
end
