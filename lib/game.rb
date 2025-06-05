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

  def round(opponent = nil, rank = nil)
    current_player = players[rounds % players.count]

    puts 'Which player would you like to ask for a card?'
    opponent = return_opponent(current_player) if opponent.nil?

    puts 'What rank?'
    rank = return_rank if rank.nil?

    self.rounds += 1
  end

  def return_opponent(player)
    opponent = []
    while [[], nil].include?(opponent)
      opponent_name = gets.chomp.downcase
      opponent = players.find { |p| p.name.downcase == opponent_name && opponent_name != player.name.downcase }
    end

    p opponent
    opponent
  end

  def return_rank
    rank = []
    # valididate that the rank is indeed an actual rank
    while rank == []
      input = gets.chomp.downcase
      rank = PlayingCard::RANK.find { |r| r.downcase == input }
      p rank
    end
    rank
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
