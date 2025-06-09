require_relative 'game'
class GameSocketRoom
  attr_reader :clients
  attr_accessor :game, :rounds

  def initialize(clients)
    puts 'Created game'
    @game = Game.new(clients.count)
    @rounds = 0
    @clients = clients
  end

  def start_game
    game.deal_cards

    message_all_clients('The players in this game are')
    game.players.each do |player|
      message_all_clients(player.name)
    end
  end

  def run_game
    until game.game_end?
      # Loop here, this will be a turn
      check_to_have_cards
      display_cards
      round
    end
  end

  def current_client
    clients[rounds % clients.count]
  end

  def current_player
    game.players[rounds % game.players.count]
  end

  def round
    check_to_have_cards
  end

  def turn
  end

  def check_to_have_cards
    return if current_player.has_cards?

    if game.deck.has_cards?
      current_client.puts game.draw_if_hand_empty(current_player)
    else
      turn_over = true
      current_client.puts 'The deck is out of cards, you are out of the game.'
    end
  end

  def display_cards
    current_client.puts "#{current_player.name} your cards are"
    current_player.hand.each do |card|
      current_client.puts "#{card.rank} of #{card.suit}"
    end
  end

  def message_all_clients(message)
    # binding.irb
    clients.each do |client|
      client.puts(message)
    end
  end

  def get_opponent(current_client, current_player)
    current_client.puts 'What player do you want to ask for a card?'
    opponent_input = listen_for_client(current_client) # gets.chomp
    game.return_opponent(current_player, opponent_input)
  end

  def get_rank(current_client, current_player)
    current_client.puts 'What rank do you want?'
    rank_input = listen_for_client(current_client) # gets.chomp
    game.return_rank(current_player, rank_input)
  end

  def listen_for_client(current_client)
    sleep(0.1)
    begin
      current_client.read_nonblock(1000)
    rescue IO::WaitReadable
    end
  end
end
