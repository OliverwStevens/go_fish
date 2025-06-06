require_relative 'card_deck'
require_relative 'player'
class Game
  attr_reader :deck
  attr_accessor :players, :rounds

  def initialize(num_of_players = 2)
    @deck = CardDeck.new
    @players = Array.new(num_of_players) { |index| Player.new("Player #{index + 1}") }
    @rounds = 0

    deck.shuffle!
    displays_player_names
  end

  def deal_cards
    if players.count < 4
      distrubute_cards(7)

    else
      distrubute_cards(5)
    end
  end

  def round(input_opponent, input_rank)
    current_player = players[rounds % players.count]

    # print out cards
    puts 'Your cards are'
    current_player.hand.each do |card|
      puts "#{card.rank} of #{card.suit}"
    end

    # ask for cards
    puts 'Which player would you like to ask for a card?'
    opponent = return_opponent(current_player, input_opponent)

    puts 'What rank?'

    rank = return_rank(current_player, input_rank)
    self.rounds += 1
  end

  def return_opponent(current_player, input_opponent)
    opponent = players.find do |p|
      p.name.downcase == input_opponent.downcase && input_opponent.downcase != current_player.name.downcase
    end

    p opponent
    opponent
  end

  def return_rank(current_player, input_rank)
    rank = PlayingCard::RANK.find { |r| r.downcase == input_rank.downcase }
    # validates that the player has a card of that rank
    rank = [] unless current_player.has_card_of_rank?(rank)
    p rank
    rank
  end

  def validate_input(opponent, rank)
    opponent != [] && rank != []
  end

  private

  def distrubute_cards(cards_to_deal)
    cards_to_deal.times do
      players.each do |player|
        player.add_card(deck.deal)
      end
    end
  end

  def displays_player_names
    puts 'The players in this game are:'
    players.each do |player|
      puts player.name
    end
  end
end
