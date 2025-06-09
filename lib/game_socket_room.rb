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
      round
    end
  end

  def current_client
    clients[rounds % clients.count]
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
