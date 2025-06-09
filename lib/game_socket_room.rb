require_relative 'game'
class GameSocketRoom
  attr_reader :clients
  attr_accessor :game, :rounds

  def initialize(clients)
    puts 'Created game'
    @game = Game.new(clients.count)
    @rounds = 0
    @clients = clients

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

  def round
    current_client = clients[@rounds % clients.count]

    current_player = game.players[@rounds % game.players.count]
    @rounds += 1

    # loop for turn here
    turn_over = false

    until turn_over
      unless current_player.has_cards?
        if game.deck.has_cards?
          current_client.puts game.draw_if_hand_empty(current_player)
        else
          turn_over = true
          current_client.puts 'The deck is out of cards, you are out of the game.'
        end
      end

      current_client.puts "#{current_player.name} your cards are"
      current_player.hand.each do |card|
        current_client.puts "#{card.rank} of #{card.suit}"
      end

      opponent, rank = []
      until game.validate_input?(opponent, rank)
        opponent = get_opponent(current_client, current_player)
        opponent&.hand&.each do |card|
          current_client.puts "Opponent's cards #{card.rank} of #{card.suit}"
        end
        current_client.puts 'What rank do you want?'
        rank_input = gets.chomp
        rank = game.return_rank(current_player, rank_input)

      end
      # Add turn continuing functionality
      message = game.round(current_player, opponent, rank)
      current_client.puts message

      turn_over = true unless message.match("rank #{rank}")

      # check for matches

      current_client.puts current_player.find_matches
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
    opponent_input = gets.chomp
    binding.irb
    game.return_opponent(current_player, opponent_input)
  end

  def listen_for_client(current_client)
    sleep(0.1)
    begin
      client.read_nonblock(1000)
    rescue IO::WaitReadable
    end
  end
end
