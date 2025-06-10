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
      self.turn_over = false
      self.turn_over = true unless turn until turn_over

      self.rounds += 1
    end
  end

  def current_client
    clients[rounds % clients.count]
  end

  def current_player
    game.players[rounds % game.players.count]
  end

  def turn(opponent = nil, rank = nil)
    check_to_have_cards
    display_cards
    opponent ||= get_opponent
    rank ||= get_rank
    message_results(opponent, rank)
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

  def message_other_clients(message)
    other_clients = clients - [current_client]
    other_clients.each do |client|
      client.puts(message)
    end
  end

  def get_opponent
    opponent = nil
    while opponent.nil?
      current_client.puts 'What player do you want to ask for a card?'
      opponent_input = listen_for_client # gets.chomp
      opponent = game.return_opponent(current_player, opponent_input)
    end
    opponent
  end

  def get_rank
    rank = nil
    while rank.nil?
      current_client.puts 'What rank do you want?'
      rank_input = listen_for_client # gets.chomp
      rank = game.return_rank(current_player, rank_input)
    end
    rank
  end

  def listen_for_client
    sleep(0.1)
    begin
      # current_client.read_nonblock(1000)
      current_client.gets.chomp
    rescue IO::WaitReadable
    end
  end

  private

  def message_results(opponent, rank)
    message = game.round(current_player, opponent, rank)

    current_client.puts(message)

    current_client.puts(current_player.find_matches)
    message.include? "rank #{rank}"
  end
end
