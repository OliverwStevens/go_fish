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

  def round
    player = players[rounds % players.count]

    puts 'Which player would you like to ask for a card?'
    opponent = return_opponent(player)

    p opponent
    puts 'What rank?'
    # rank = return_rank

    self.rounds += 1
  end

  def return_opponent(player)
    opponent = []
    while opponent == []
      opponent_name = gets.chomp.downcase
      opponent = players.find { |p| p.name.downcase == opponent_name && opponent_name != player.name.downcase }
    end

    opponent
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
