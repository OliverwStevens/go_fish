require_relative 'game'
class GameSocketRoom
  attr_reader :clients
  attr_accessor :game, :rounds, :turn_over

  def initialize(clients)
    puts 'Created game'
    @game = Game.new(clients.count)
    @rounds = 0
    @clients = clients
    @turn_over = false
  end

  def start_game
    game.deal_cards

    message_all_clients('The players in this game are')
    game.players.each do |player|
      message_all_clients(player.name)
    end
  end

  def run_game
    start_game
    until game.game_end?
      # Loop here, this will be a turn

      round until turn_over
    end
  end

  def current_client
    clients[rounds % clients.count]
  end

  def current_player
    game.players[rounds % game.players.count]
  end

  def turn
    check_to_have_cards
    display_cards
    opponent, rank = player_choices
    message = game.round(current_player, opponent, rank)
    current_client.puts = message
    current_client.puts(current_player.find_matches)

    message
  end

  def round
    self.turn_over = true unless turn.match("rank #{rank}")
    self.rounds += 1
  end

  def check_to_have_cards
    return if current_player.has_cards?

    if game.deck.has_cards?
      current_client.puts game.draw_if_hand_empty(current_player)
    else
      self.turn_over = true
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
    clients.each do |client|
      client.puts(message)
    end
  end

  def player_choices
    opponent, rank = []
    until game.validate_input?(opponent, rank)
      opponent = get_opponent
      rank = get_rank
    end
    [opponent, rank]
  end

  def get_opponent
    current_client.puts 'What player do you want to ask for a card?'
    opponent_input = listen_for_client # gets.chomp
    game.return_opponent(current_player, opponent_input)
  end

  def get_rank
    current_client.puts 'What rank do you want?'
    rank_input = listen_for_client # gets.chomp
    game.return_rank(current_player, rank_input)
  end

  def listen_for_client
    sleep(0.1)
    begin
      current_client.read_nonblock(1000)
    rescue IO::WaitReadable
    end
  end
end
